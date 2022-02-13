import 'package:flutter/material.dart';
import 'package:senturionletters/Uteis/Textos.dart';

class TelaCarregamento extends StatefulWidget {
  const TelaCarregamento({Key? key}) : super(key: key);

  @override
  _TelaCarregamentoState createState() => _TelaCarregamentoState();
}

class _TelaCarregamentoState extends State<TelaCarregamento> {
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        elevation: 1000,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:  [
              Text(
               Textos.txtCarregar,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.black),
                strokeWidth: 3.0,
              )
            ],
          ),
        ));
  }
}
