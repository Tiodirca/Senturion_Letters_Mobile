import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:senturionletters/Uteis/Servicos/ServicoPesquisa.dart';
import 'package:url_launcher/url_launcher.dart';

class ServicoGerarArquivo {
  static Future<dynamic> gerarArquivo(
      //future para fazer a conexao e gerar o arquivo
      String letra,
      String titulo,
      String tipoModelo) async {
    var linkGerarArquivo = Uri.parse("http://192.168.1.5:35408");
    try {
      final response = await http.post(linkGerarArquivo,
          body: {'textos': letra, 'titulo': titulo, 'modelo': tipoModelo});
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

  static abrirNavegador() async {
    //metodo para abrir o navegador do celular no url passada
    ServicoPesquisa.tituloLetra;
    var titulo = ServicoPesquisa.tituloLetra;
    var url = "http://192.168.1.5:35408/baixarArquivo/$titulo";
    if (await canLaunch(url)) {
      await launch(url);
      Timer(const Duration(seconds: 10), () async {
        //excluirArquivoDoBackEnd(titulo);
      });
    } else {
      throw 'Could not launch $url';
    }
  }

  static excluirArquivoDoBackEnd(titulo) async {
    // metodo para excluir o arquivo criado na pasta do back end que cria o arquivo de slides
    var linkExcluirArquivo = Uri.parse("http://192.168.1.5:35408/excluirArquivo");
    try {
      await http.post(linkExcluirArquivo, body: {'arquivo': titulo});
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
