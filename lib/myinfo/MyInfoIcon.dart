import 'package:flutter/material.dart';
import 'package:flutter_bingocode/myinfo/MyInfoPage.dart';
import 'package:flutter_bingocode/route/CustomRoute.dart';
class MyInfoIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new InkWell(
        onTap: () {
          Navigator.push(
              context, SlideRoute(MyInfoPage(), SlideRoute.RIGHT));
        },
        child: Hero(
          tag: 'hero_favorite',
          child: Icon(
            Icons.thumb_up,
            color: Colors.redAccent,
            size: 36,
          ),
          transitionOnUserGestures: true,
        ));
  }
}
