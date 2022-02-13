import 'package:flutter/material.dart';
import 'dart:async';

import 'package:senturionletters/Telas/Carregamentos/TelaCarregamento.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      var dadosTela = {};
      dadosTela["letra"] = [];
      dadosTela["tipoModelo"] = "geral";
      Navigator.pushReplacementNamed(context, "/telaPrincipal", arguments: dadosTela);
    });
  }

  @override
  Widget build(BuildContext context) {
    double alturaTela = MediaQuery.of(context).size.height;
    double larguraTela = MediaQuery.of(context).size.width;
    //definindo que a variavel vai receber o retorno do metodo
    return Scaffold(
        //container geral da tela
        body: Container(
            width: larguraTela,
            height: alturaTela,
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 0.0),
            child: Column(
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: Image.asset(
                    'assets/imagens/logoAplicativo.png',
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                const TelaCarregamento(),
              ],
            )));
  }
}
