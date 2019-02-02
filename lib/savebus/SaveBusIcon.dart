import 'package:flutter/material.dart';
import 'package:flutter_bingocode/manager/BusManager.dart';
import 'package:flutter_bingocode/util/ConstantUtil.dart';

class SaveBusIcon extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SaveBusIconState();
  }
}

class SaveBusIconState extends State<SaveBusIcon> {
  BusManager _busManager;
  bool hasSaved = false;

  @override
  void initState() {
    super.initState();
    _busManager = BusManager();
    _busManager.getSavedBusLine().then((Map<String, String> savedMap) {
      if (savedMap[KeyConstant.keyBusLine] != null) {
        hasSaved = true;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Theme(
        data: Theme.of(context)
            .copyWith(accentColor: hasSaved ? Colors.white : Colors.redAccent),
        child: FloatingActionButton(
            isExtended: true,
            onPressed: () {
              _busManager.saveBusLine(context);
            },
            child: Icon(
              Icons.grade,
              color: hasSaved ? Colors.redAccent : Colors.white,
              size: 36,
            )));
  }
}
