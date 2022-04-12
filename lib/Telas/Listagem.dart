import 'package:flutter/material.dart';
import 'package:senturionletters/Uteis/Constantes.dart';
import '../Uteis/Servicos/ServicoPesquisa.dart';
import '../Uteis/Textos.dart';

class Listagem extends StatefulWidget {
  final List retornoPesquisa;
  final String remocaoItemLista;
  final String tipoModelo;

  const Listagem(
      {Key? key,
      required this.retornoPesquisa,
      required this.remocaoItemLista,
      required this.tipoModelo})
      : super(key: key);

  @override
  _ListagemState createState() =>
      _ListagemState(retornoPesquisa, remocaoItemLista, tipoModelo);
}

class _ListagemState extends State<Listagem> {
  List retornoPesquisa;
  String tituloLetra = "";
  String removerItem = "";
  String tipoModelo = "geral";
  bool exibirLogo = false;

  _ListagemState(this.retornoPesquisa, this.removerItem, this.tipoModelo);

  recuperarConfiguracoesLetra() async {
    //metodo para recuperar informacoes sobre a letra e o modelo dos slides
    await ServicoPesquisa.exibirTituloLetra().then((valor) {
      setState(() {
        tituloLetra = valor;
        if (tipoModelo == Contantes.tipoRadioGeracao) {
          setState(() {
            exibirLogo = true;
          });
        } else {
          setState(() {
            exibirLogo = false;
          });
        }
      });
    });
    //removendo o primeiro index da lista pois nao e necessario ser exibido
    //o primeiro index contem <div href...
    if (removerItem.contains("removerItem")) retornoPesquisa.removeAt(0);
  }

  @override
  void initState() {
    super.initState();
    recuperarConfiguracoesLetra();
  }

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double alturaBarraStatus = MediaQuery.of(context).padding.top;
    double alturaAppBar = AppBar().preferredSize.height;
    double largura = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(Textos.txtNomeMusica),
              Text(
                tituloLetra,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ],
          ),
          SizedBox(
            height: altura * 0.7 - alturaAppBar - alturaBarraStatus,
            child: ListView.builder(
                itemCount: retornoPesquisa.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Container(
                          width: largura,
                          padding: const EdgeInsets.all(5),
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
                                  mainAxisAlignment: MainAxisAlignment.end,
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
                                            fontWeight: FontWeight.bold,
                                            decorationStyle:
                                                TextDecorationStyle.solid,
                                            shadows: <Shadow>[
                                              Shadow(
                                                offset: Offset(1.0, 2.0),
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
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                  retornoPesquisa[index]
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
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    shadows: <Shadow>[
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 10.0,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 10.0,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 10.0,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      Shadow(
                                        offset: Offset(1.0, 1.0),
                                        blurRadius: 10.0,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                      ),
                                    ],
                                  )),
                            ],
                          )));
                }),
          )
        ],
      ),
    );
  }
}
