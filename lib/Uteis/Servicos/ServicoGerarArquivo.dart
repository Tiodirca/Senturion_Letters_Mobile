import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:url_launcher/url_launcher.dart';

class ServicoGerarArquivo {
  static String endereco = "http://192.168.1.6:5000";

  static Future<dynamic> gerarArquivo(
      //future para fazer a conexao e gerar o arquivo
      String letra,
      String titulo,
      String tipoModelo) async {
    var linkGerarArquivo = Uri.parse(endereco + "/gerar");
    // envelopando acoes dentro de um try e passando parametros via post para o link
    try {
      final response = await http.post(linkGerarArquivo, body: {
        'textos': letra,
        'titulo': titulo,
        'modelo': tipoModelo
      }).timeout(const Duration(seconds: 20));
      var retornoResposta = parse(response.body);
      if (retornoResposta.outerHtml.contains("sucesso")) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static abrirNavegador(titulo) async {
    //metodo para abrir o navegador do celular no url passada
    var url = endereco + "/baixarArquivo/$titulo";
    if (await canLaunch(url)) {
      await launch(url).timeout(const Duration(seconds: 20));
      Timer(const Duration(seconds: 10), () async {
        excluirArquivoDoBackEnd(titulo);
      });
    } else {
      throw 'Could not launch $url';
    }
  }

  static excluirArquivoDoBackEnd(titulo) async {
    // metodo para excluir o arquivo criado na pasta do back end que cria o arquivo de slides
    var linkExcluirArquivo = Uri.parse(endereco + "/excluirArquivo");
    try {
      await http.post(linkExcluirArquivo,
          body: {'arquivo': titulo}).timeout(const Duration(seconds: 20));
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
