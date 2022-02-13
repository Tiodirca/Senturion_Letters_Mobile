import 'package:flutter/material.dart';
import 'package:senturionletters/Telas/Editar.dart';
import 'package:senturionletters/Telas/Carregamentos/SplashScreen.dart';
import 'package:senturionletters/Telas/TelaPrincipal.dart';

class Rotas {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Recebe os parâmetros na chamada do Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/telaPrincipal':
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => TelaPrincipal(
              retornoPesquisa: args["letra"],tipoModelo: args["tipoModelo"],
            ),
          );
        } else {
          return erroRota(settings);
        }
      case '/editar':
        if (args is Map) {
          return MaterialPageRoute(
            builder: (_) => Editar(
              retornoPesquisa: args["letra"],tipoModelo: args["tipoModelo"],
            ),
          );
        } else
          return erroRota(settings);
    }

    // Se o argumento não é do tipo correto, retorna erro
    return erroRota(settings);
  }

  //metodo para exibir mensagem de erro
  static Route<dynamic> erroRota(RouteSettings settings) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("Tela não encontrada!"),
        ),
        body: Container(
          color: Colors.white,
          child: const Center(
            child: Text("Tela não encontrada."),
          ),
        ),
      );
    });
  }
}
