import 'package:flutter/material.dart';
import 'package:minhas_anotacoes/home.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.teal,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.lightGreen,
        foregroundColor: Colors.white
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white
      )
    ),
  ));
}
