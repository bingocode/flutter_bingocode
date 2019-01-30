import 'package:flutter/material.dart';
import 'package:flutter_bingocode/choosebus/ChooseBusPage.dart';
import 'package:flutter_bingocode/route/CustomRoute.dart';
import 'package:flutter_bingocode/util/AnimationUtil.dart';
class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SplashPageState();
  }

}

class SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin{
  AnimationController animationController;
  Animation animation;


  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    animation = Tween(begin: 0.0, end: 100.0).animate(animationController);
    animationController.forward(); //启动动画
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //Navigator.push(context, FadeRoute(ChooseBusPage()));
        //Navigator.of(context).pushReplacementNamed('/MainPage');
        Navigator.pushReplacement(context, SlideRoute(ChooseBusPage(), SlideRoute.DOWN));
      } else if (status == AnimationStatus.dismissed) {
        Navigator.pushReplacement(context, SlideRoute(ChooseBusPage(), SlideRoute.DOWN));
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Center(
        child: TransitionAnimation(child: Image.asset(('assets/ic_launcher.png')), animation: animation),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }


}