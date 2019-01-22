import 'package:flutter/material.dart';
import 'package:flutter_bingocode/choosebus/ChooseBusPage.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bingocode/savebus/SaveBusIcon.dart';
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
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: ChooseBusPage(),
        floatingActionButton: SaveBusIcon()
      ),
    );
  }
}

