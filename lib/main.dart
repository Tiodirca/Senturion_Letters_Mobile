import 'package:flutter/material.dart';
import 'package:senturionletters/Uteis/Textos.dart';

import 'Telas/Rotas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Textos.nomeAplicativo,
      theme: ThemeData(
        // This is the theme of your application
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      onGenerateRoute: Rotas.generateRoute,
    );
  }
}
