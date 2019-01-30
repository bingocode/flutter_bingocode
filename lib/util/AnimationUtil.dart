import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
class TransitionAnimation extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;
  TransitionAnimation({this.child, this.animation});

  Widget build(BuildContext context) {
    return new Center(
      child: new AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget child) {
            return new Container(
                height: animation.value, width: animation.value, child: child);
          },
          child: child),
    );
  }

}