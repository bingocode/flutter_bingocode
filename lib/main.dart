import 'package:flutter/material.dart';
import 'package:flutter_bingocode/choosebus/ChooseBusPage.dart';
import 'package:flutter/rendering.dart';
void main() {
  //debugPaintSizeEnabled=true;
  runApp(new MyApp());
}

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
        floatingActionButton: new Theme(data: Theme.of(context).copyWith(
          accentColor: Colors.redAccent
        ), child: FloatingActionButton(onPressed: null, child: Icon(Icons.grade))),
      ),
    );
  }
}

