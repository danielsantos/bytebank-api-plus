import 'package:flutter/material.dart';

import 'screens/dashboard.dart';

void main() {
  runApp(BytebankApp());
  //save(Contact(0, 'teste', 1234)); // sqflite
  // web-api //findAll().then((transcations) => print('All Transaction: $transcations'));
  // web-api //save(Transaction(235.0, Contact(0, 'Siclano', 2345))).then((transaction) => print(transaction));
}

class BytebankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.green[900],
            accentColor: Colors.blueAccent[700],
            buttonTheme: ButtonThemeData(
              buttonColor: Colors.blueAccent[700],
              textTheme: ButtonTextTheme.primary,
            )),
        home: Dashboard());
  }
}
