import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bingocode/SplashPage.dart';

void main() {
  // 开启布局边界
  //debugPaintSizeEnabled=true;
  // 沉浸式状态栏
  //SystemChrome.setEnabledSystemUIOverlays([]);
  // 强制竖屏
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
          primarySwatch: Colors.blue, backgroundColor: Colors.transparent),
      home: Scaffold(
        body: SplashPage(),
      ),
    );
  }
}
