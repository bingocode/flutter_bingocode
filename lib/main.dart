import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bingocode/SplashPage.dart';
import 'package:flutter_bingocode/choosebus/ChooseBusPage.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bingocode/route/CustomRoute.dart';
import 'package:flutter_bingocode/savebus/SaveBusIcon.dart';
void main() {
  // 开启布局边界
  //debugPaintSizeEnabled=true;
  // 强制竖屏
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
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
        backgroundColor: Colors.transparent
      ),
      home: Scaffold(
        body: SplashPage(),
      ),
    );
  }
}

