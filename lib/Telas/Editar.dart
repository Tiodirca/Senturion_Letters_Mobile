import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:senturionletters/Uteis/Textos.dart';

import '../Uteis/Servicos/ServicoPesquisa.dart';

class Editar extends StatefulWidget {
  final List retornoPesquisa;
  final String tipoModelo;

  const Editar(
      {Key? key, required this.retornoPesquisa, required this.tipoModelo})
      : super(key: key);

  @override
  _EditarState createState() => _EditarState(retornoPesquisa, tipoModelo);
}

class _EditarState extends State<Editar> {
  List retornoPesquisaEditar;
  String tituloLetra = "";
  String tipoModelo = "geral";
  bool exibirLogo = false;
  int valorRadioButton = 0;

  _EditarState(this.retornoPesquisaEditar, this.tipoModelo);

  recuperarTituloLetra() async {
    await ServicoPesquisa.exibirTituloLetra().then((valor) {
      setState(() {
        tituloLetra = valor;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    if (tipoModelo == "geracaoFire") {
      setState(() {
        exibirLogo = true;
        valorRadioButton = 1;
      });
    } else {
      setState(() {
        valorRadioButton = 0;
      });
    }
    recuperarTituloLetra();
  }

  void mudarRadioButton(int value) {
    //metodo para mudar o estado do radio button
    setState(() {
      valorRadioButton = value;
      switch (valorRadioButton) {
        case 0:
          setState(() {
            tipoModelo = "geral";
          });
          break;
        case 1:
          setState(() {
            tipoModelo = "geracaoFire";
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double alturaBarraStatus = MediaQuery.of(context).padding.top;
    double alturaAppBar = AppBar().preferredSize.height;
    double largura = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(Textos.tituloTelaEdicao),
        leading: IconButton(
            //setando tamanho do icone
            iconSize: 30,
            onPressed: () {
              var dadosTela = {};
              dadosTela["letra"] = [];
              dadosTela["tipoModelo"] = "geral";
              Navigator.pushReplacementNamed(context, "/telaPrincipal",
                  arguments: dadosTela);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: Wrap(
          children: [
            Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10.0),
                        child: Column(
                          children: [
                            Text(
                              Textos.txtDescricaoEditar,
                              textAlign: TextAlign.center,
                            ),
                            Text(Textos.txtDescricaoEditarAdd),
                            Text(Textos.txtDescricaoEditarExcluir),
                            Text(
                              tituloLetra,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      height: altura * 0.70 - alturaAppBar - alturaBarraStatus,
                      child: ListView.builder(
                          itemCount: retornoPesquisaEditar.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                                title: Column(
                              children: [
                                Text("N° slide abaixo: $index"),
                                Container(
                                    width: largura,
                                    padding: const EdgeInsets.only(left: 5.0,bottom: 0.0,right: 5.0,top: 5.0),
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/imagens/fundoSlides.png'),
                                            fit: BoxFit.cover)),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: largura,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Visibility(
                                                visible: exibirLogo,
                                                child: Expanded(
                                                  child: SizedBox(
                                                    width: 25,
                                                    height: 25,
                                                    child: Image.asset(
                                                      'assets/imagens/logoGeracaoFire.png',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  tituloLetra,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decorationStyle:
                                                          TextDecorationStyle
                                                              .solid,
                                                      shadows: <Shadow>[
                                                        Shadow(
                                                          offset:
                                                              Offset(1.0, 2.0),
                                                          blurRadius: 3.0,
                                                          color: Color.fromARGB(
                                                              255, 0, 0, 0),
                                                        ),
                                                      ],
                                                      color: Colors.white),
                                                ),
                                                flex: 9,
                                              ),
                                              Expanded(
                                                child: SizedBox(
                                                  width: 25,
                                                  height: 25,
                                                  child: Image.asset(
                                                    'assets/imagens/logo.png',
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),

                                        TextFormField(
                                          textAlign: TextAlign.center,
                                          initialValue:
                                              retornoPesquisaEditar[index]
                                                  .toString()
                                                  .replaceAll(
                                                      RegExp(
                                                        r'</p>',
                                                      ),
                                                      '')
                                                  .replaceAll(
                                                      RegExp(
                                                        r'<br>',
                                                      ),
                                                      '\n'),
                                          onChanged: (value) {
                                            retornoPesquisaEditar[index] =
                                                value;
                                          },
                                          maxLines: 10,
                                          minLines: 1,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            shadows: <Shadow>[
                                              Shadow(
                                                offset: Offset(1.0, 1.0),
                                                blurRadius: 10.0,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                              Shadow(
                                                offset: Offset(1.0, 1.0),
                                                blurRadius: 10.0,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                              Shadow(
                                                offset: Offset(1.0, 1.0),
                                                blurRadius: 10.0,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                              Shadow(
                                                offset: Offset(1.0, 1.0),
                                                blurRadius: 10.0,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                              ),
                                            ],
                                          ),
                                          decoration:  const InputDecoration(
                                              focusedBorder: InputBorder.none,
                                              enabledBorder: InputBorder.none,
                                        )
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                                icon: const Icon(Icons.add),
                                                color: Colors.black,
                                                iconSize: 30,
                                                onPressed: () {
                                                  retornoPesquisaEditar.insert(
                                                      index + 1, "");
                                                  var dadosTela = {};
                                                  dadosTela['letra'] =
                                                      retornoPesquisaEditar;
                                                  dadosTela['tipoModelo'] =
                                                      tipoModelo;
                                                  Navigator
                                                      .pushReplacementNamed(
                                                      context, "/editar",
                                                      arguments: dadosTela);
                                                }),
                                            IconButton(
                                                icon: const Icon(Icons.close),
                                                color: Colors.red,
                                                iconSize: 30,
                                                onPressed: () {
                                                  if (retornoPesquisaEditar
                                                      .length ==
                                                      1) {
                                                    SnackBar snackBarErro =
                                                    SnackBar(
                                                        content: Text(Textos
                                                            .erroEdicaoLetra));
                                                    ScaffoldMessenger.of(
                                                        context)
                                                        .showSnackBar(
                                                        snackBarErro);
                                                  } else {
                                                    retornoPesquisaEditar
                                                        .removeAt(index);
                                                    var dadosTela = {};
                                                    dadosTela['letra'] =
                                                        retornoPesquisaEditar;
                                                    dadosTela['tipoModelo'] =
                                                        tipoModelo;
                                                    Navigator
                                                        .pushReplacementNamed(
                                                        context, "/editar",
                                                        arguments:
                                                        dadosTela);
                                                  }
                                                }),
                                          ],
                                        )
                                      ],
                                    ))
                              ],
                            ));
                          }),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 10.0),
                      child: Text(Textos.txtSelecaoRadioEditar,
                          textAlign: TextAlign.center),
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
                          'Geração Fire',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                        icon: const Icon(Icons.done_outline),
                        color: Colors.black,
                        iconSize: 30,
                        onPressed: () {
                          var dadosTela = {};
                          dadosTela["letra"] = retornoPesquisaEditar;
                          dadosTela["tipoModelo"] = tipoModelo;
                          //verificando se todos os index da lista nao estao vazios
                          var slideVazio = [...retornoPesquisaEditar]
                              .every((el) => el.toString().isNotEmpty);
                          if (slideVazio) {
                            //caso nenhum index tiver vazio trocar de tela caso contrario mostrar erro
                            Navigator.pushReplacementNamed(
                                context, "/telaPrincipal",
                                arguments: dadosTela);
                          } else {
                            SnackBar snackBarErro = SnackBar(
                                content: Text(Textos.erroEdicaoSlideVazio));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBarErro);
                          }
                        }),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
