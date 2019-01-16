import 'package:flutter/material.dart';
import 'package:flutter_bingocode/choosebus/ChooseBusPage.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: ChooseBusPage(),
      ),
    );
  }
}

