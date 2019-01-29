import 'package:flutter/material.dart';
import 'package:flutter_bingocode/util/CommonUtil.dart';

class FavoriteIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Theme(
        data: Theme.of(context).copyWith(accentColor: Colors.white),
        child: FloatingActionButton(
            isExtended: true,
            onPressed: () {
              CommonUtil.toast("谢谢赞赏");
            },
            child: Icon(
              Icons.thumb_up,
              color: Colors.redAccent,
              size: 36,
            )));
  }
}
