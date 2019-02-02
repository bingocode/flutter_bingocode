import 'package:flutter/material.dart';

class FadeRoute extends PageRouteBuilder{
  final Widget widget;
  FadeRoute(this.widget)
      :super(
      transitionDuration:const Duration(seconds:1),
      pageBuilder:(
          BuildContext context,
          Animation<double> animation1,
          Animation<double> animation2){
        return widget;
      },
      transitionsBuilder:(
          BuildContext context,
          Animation<double> animation1,
          Animation<double> animation2,
          Widget child){
        return FadeTransition(
          opacity: Tween(begin:0.0,end :1.0).animate(CurvedAnimation(
              parent:animation1,
              curve:Curves.fastOutSlowIn
          )),
          child: child,
        );
      }
  );
}


class SlideRoute extends PageRouteBuilder{
  final Widget widget;
  final int direction;
  static const int LEFT = 0;
  static const int RIGHT = 1;
  static const int UP = 2;
  static const int DOWN = 3;
  SlideRoute(this.widget, this.direction)
      :super(
      transitionDuration:const Duration(seconds:1),
      pageBuilder:(
          BuildContext context,
          Animation<double> animation1,
          Animation<double> animation2){
        return widget;
      },
      transitionsBuilder:(
          BuildContext context,
          Animation<double> animation1,
          Animation<double> animation2,
          Widget child){
        return SlideTransition(
          position: _getTween(direction)
              .animate(CurvedAnimation(
              parent: animation1,
              curve: Curves.fastOutSlowIn
          )),
          child: child,
        );
      }
  );

  static Tween<Offset> _getTween(int dir) {
    switch (dir) {
      case RIGHT:
        return Tween<Offset>(
            begin: Offset(-1.0, 0.0),
            end:Offset(0.0, 0.0)
        );
      case UP:
        return Tween<Offset>(
            begin: Offset(0.0, 1.0),
            end:Offset(0.0, 0.0)
        );
      case DOWN:
        return Tween<Offset>(
            begin: Offset(0.0, -1.0),
            end:Offset(0.0, 0.0)
        );
      default:
        return Tween<Offset>(
            begin: Offset(1.0, 0.0),
            end:Offset(0.0, 0.0)
        );
    }
  }
}

