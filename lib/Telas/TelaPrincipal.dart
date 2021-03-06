import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:senturionletters/Telas/Listagem.dart';
import 'package:senturionletters/Uteis/Constantes.dart';
import 'package:senturionletters/Uteis/Servicos/ServicoGerarArquivo.dart';
import 'package:senturionletters/Uteis/Textos.dart';
import 'package:senturionletters/Telas/Carregamentos/TelaCarregamento.dart';

import '../Uteis/Servicos/ServicoPesquisa.dart';

class TelaPrincipal extends StatefulWidget {
  final List retornoPesquisa;
  final String tipoModelo;

  const TelaPrincipal(
      {Key? key, required this.retornoPesquisa, required this.tipoModelo})
      : super(key: key);

  @override
  _TelaPrincipalState createState() =>
      _TelaPrincipalState(retornoPesquisa, tipoModelo);
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  TextEditingController controllerPesquisa = TextEditingController(text: "");
  final chaveFormulario = GlobalKey<FormState>();

  String tipoTelaExibir = Contantes.telaExibirInicio;
  bool exibirBotoesAcoes = false;
  List retornoPesquisa = [];
  int valorRadioButton = -1;
  String removerItemLista = "";
  String tipoModelo = Contantes.tipoRadioGeral;

  _TelaPrincipalState(this.retornoPesquisa, this.tipoModelo);

  // Metodos responsaveis por verificar a conexao com a internet
  // codigo exemplo da api
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      debugPrint(
        'Couldn\'t check connectivity status$e',
      );
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

//-------------------------------------- Final dos metodos para verificar a conexao ------------------------

  chamarMetodoPesquisarLetra(String link) async {
    // metodo responsavel por pegar a letra no site
    retornoPesquisa = await ServicoPesquisa.pesquisarLetra(link);

    if (retornoPesquisa == null || retornoPesquisa.isEmpty) {
      SnackBar snackBarErro = SnackBar(content: Text(Textos.erroCarregarLetra));
      ScaffoldMessenger.of(context).showSnackBar(snackBarErro);
      controllerPesquisa.text = "";
      setState(() {
        tipoTelaExibir = Contantes.telaExibirInicio;
      });
    } else if (retornoPesquisa.isNotEmpty) {
      setState(() {
        tipoTelaExibir = Contantes.telaExibirRadioButton;
        valorRadioButton = -1;
      });
    }
  }

  chamarMetodoPesquisa() async {
    //metodo resposavel por pesquisar no buscador links contendo a pesquisa do usuario
    String itemDigitado = controllerPesquisa.text;
    dynamic retornoPesquisa =
        await ServicoPesquisa.pesquisar(itemDigitado.replaceAll(
            RegExp(
              r' ',
            ),
            '+'));
    if (retornoPesquisa == null || retornoPesquisa.isEmpty) {
      SnackBar snackBarErro = SnackBar(content: Text(Textos.erroPesquisa));
      ScaffoldMessenger.of(context).showSnackBar(snackBarErro);
      controllerPesquisa.text = "";
      setState(() {
        tipoTelaExibir = Contantes.telaExibirInicio;
      });
    } else if (retornoPesquisa.isNotEmpty) {
      chamarMetodoPesquisarLetra(retornoPesquisa);
    }
  }

  @override
  void initState() {
    super.initState();
    if (retornoPesquisa.isNotEmpty) {
      setState(() {
        recuperarTituloLetra();
        tipoTelaExibir = Contantes.telaExibirlistagem;
        exibirBotoesAcoes = true;
      });
    }
    // verificacao da conexao
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  recuperarTituloLetra() async {
    //metodo para recuperar o titulo da musica
    await ServicoPesquisa.exibirTituloLetra().then((valor) {
      setState(() {
        controllerPesquisa.text = valor;
      });
    });
  }

  chamarGerarArquivo() async {
    //metodo para chamar metodo para gerar o arquivo de slides
    var letraCompleta = retornoPesquisa.join("");
    var retorno = await ServicoGerarArquivo.gerarArquivo(
        letraCompleta, ServicoPesquisa.tituloLetra, tipoModelo);
    if (retorno) {
      Timer(const Duration(seconds: 5), () {
        setState(() {
          tipoTelaExibir = Contantes.telaExibirCarregamento;
          exibirBotoesAcoes = false;
        });
        SnackBar snackBarSucesso =
            SnackBar(content: Text(Textos.sucessoGerarArquivo));
        ScaffoldMessenger.of(context).showSnackBar(snackBarSucesso);
        ServicoGerarArquivo.abrirNavegador(ServicoPesquisa.tituloLetra);
        setState(() {
          tipoTelaExibir = Contantes.telaExibirlistagem;
          exibirBotoesAcoes = true;
        });
      });

    } else {
      SnackBar snackBarErro = SnackBar(content: Text(Textos.erroGerarArquivo));
      ScaffoldMessenger.of(context).showSnackBar(snackBarErro);
      setState(() {
        tipoTelaExibir = Contantes.telaExibirlistagem;
        exibirBotoesAcoes = true;
      });
    }
  }

  void mudarRadioButton(int value) {
    //metodo para mudar o estado do radio button
    setState(() {
      valorRadioButton = value;
      tipoTelaExibir = Contantes.telaExibirlistagem;
      exibirBotoesAcoes = true;
      switch (valorRadioButton) {
        case 0:
          setState(() {
            tipoModelo = Contantes.tipoRadioGeral;
          });
          break;
        case 1:
          setState(() {
            tipoModelo = Contantes.tipoRadioGeracao;
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;
    double alturaBarraStatus = MediaQuery.of(context).padding.top;
    double alturaAppBar = AppBar().preferredSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(Textos.tituloTelaPrincipal),
      ),
      body: SingleChildScrollView(
          child: Center(
        child: SizedBox(
          width: largura,
          height: altura - alturaBarraStatus - alturaAppBar,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (tipoTelaExibir == Contantes.telaExibirInicio) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      child: Text(
                        Textos.txtDescricaoPesquisa,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //CAIXA DE PESQUISA
                        SizedBox(
                          height: altura * 0.12,
                          child: Container(
                              alignment: Alignment.center,
                              width: largura * 0.65,
                              child: Form(
                                key: chaveFormulario,
                                child: TextFormField(
                                    controller: controllerPesquisa,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return Textos.erroCampoPesquisa;
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1, color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1, color: Colors.red),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1, color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 1, color: Colors.black),
                                            borderRadius:
                                                BorderRadius.circular(10)))),
                              )),
                        ),
                        //BOTAO DE PESQUISA
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(
                              left: 5.0, top: 0.0, bottom: 0.0, right: 5.0),
                          width: 100.0,
                          height: 100.0,
                          child: ElevatedButton(
                            onPressed: () {
                              if (chaveFormulario.currentState!.validate()) {
                                //verificando conexao com a internet
                                if (_connectionStatus.toString() ==
                                    "ConnectivityResult.none") {
                                  SnackBar snackBarErroConexao = SnackBar(
                                      content: Text(Textos.erroConexao));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBarErroConexao);
                                } else {
                                  setState(() {
                                    tipoTelaExibir =
                                        Contantes.telaExibirCarregamento;
                                    retornoPesquisa = [];
                                    removerItemLista = "removerItem";
                                  });
                                  chamarMetodoPesquisa();
                                }
                              }
                            },
                            child: Text(Textos.btnPesquisar),
                          ),
                        )
                      ],
                    ),
                  ],
                );
              } else if (tipoTelaExibir == Contantes.telaExibirCarregamento) {
                return SizedBox(
                    height: altura - alturaAppBar - alturaBarraStatus,
                    child: const Center(
                        child:
                            SizedBox(height: 150, child: TelaCarregamento())));
              } else if (tipoTelaExibir == Contantes.telaExibirRadioButton) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(Textos.txtSelecaoRadio),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 25,
                          height: 25,
                          child: Image.asset(
                            'assets/imagens/logo.png',
                          ),
                        ),
                        Radio(
                            value: 0,
                            groupValue: valorRadioButton,
                            onChanged: (_) {
                              mudarRadioButton(0);
                            }),
                        const Text(
                          'Modelo Geral',
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 25,
                          height: 25,
                          child: Image.asset(
                            'assets/imagens/logoGeracaoFire.png',
                          ),
                        ),
                        Radio(
                            value: 1,
                            groupValue: valorRadioButton,
                            onChanged: (_) {
                              mudarRadioButton(1);
                            }),
                        const Text(
                          'Gera????o Fire',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else if (tipoTelaExibir == Contantes.telaExibirlistagem) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: FloatingActionButton(
                          child: const Icon(
                            Icons.close_outlined,
                            size: 40,
                          ),
                          onPressed: () {
                            setState(() {
                              tipoTelaExibir = Contantes.telaExibirInicio;
                              exibirBotoesAcoes = false;
                              controllerPesquisa.text = "";
                            });
                          }),
                    ),
                    Listagem(
                      retornoPesquisa: retornoPesquisa,
                      remocaoItemLista: removerItemLista,
                      tipoModelo: tipoModelo,
                    ),
                  ],
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      )),
      bottomSheet: Visibility(
          visible: exibirBotoesAcoes,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.mode_edit_outline_outlined),
                color: Colors.amber,
                iconSize: 40,
                onPressed: () {
                  var dadosTela = {};
                  dadosTela['letra'] = retornoPesquisa;
                  dadosTela['tipoModelo'] = tipoModelo;
                  Navigator.pushReplacementNamed(context, "/editar",
                      arguments: dadosTela);
                },
              ),
              SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      chamarGerarArquivo();
                      setState(() {
                        tipoTelaExibir = Contantes.telaExibirCarregamento;
                        exibirBotoesAcoes = false;
                        removerItemLista = "";
                      });
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    child: Text(
                      Textos.btnGerarArquivo,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  )),
            ],
          )),
    );
  }
}
