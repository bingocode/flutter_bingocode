import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bingocode/bean/DirInfo.dart';
import 'package:flutter_bingocode/bean/StationInfo.dart';
import 'package:flutter_bingocode/manager/BusManager.dart';
import 'package:flutter_bingocode/resources/strings.dart';
import 'package:flutter_bingocode/resources/styles.dart';
import 'package:flutter_bingocode/showbus/ShowBusPage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChooseBusPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChooseBusState();
  }
}

class ChooseBusState extends State<ChooseBusPage> {
  final Utf8Decoder decoder = new Utf8Decoder();
  BusManager _busManager;
  UpdateCallBack<List<String>> updateBusesCallBack;
  UpdateCallBack<List<DirInfo>> updateDirCallBack;
  UpdateCallBack<List<StationInfo>> updateStationsCallBack;
  UpdateCallBack<List<StationInfo>> queryStationsCallBack;

  @override
  void initState() {
    super.initState();
    updateBusesCallBack = (List<String> buses) {
      setState(() {});
    };
    updateDirCallBack = (List<DirInfo> dirinfos) {
      setState(() {});
    };
    updateStationsCallBack = (List<StationInfo> dirinfos) {
      setState(() {});
    };
    queryStationsCallBack = (List<StationInfo> dirinfos) {
      print("query onLine busInfo");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ShowBusPage()));
    };
    _busManager = BusManager();
    _busManager.getSavedBusLine().then((String saveBusLine) {
      _busManager.busLine = saveBusLine;
      if (_busManager.busLine != null) {
        _busManager.getDirList().then(updateDirCallBack);
      }
      _busManager.getBusList().then(updateBusesCallBack);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/choose_bus_bg.jpg'),
              fit: BoxFit.fitHeight)),
      child: Center(
          child: new Column(
        mainAxisAlignment: MainAxisAlignment.center, // 主轴方向居中
        crossAxisAlignment: CrossAxisAlignment.center, // 辅轴方向居中
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: GestureDetector(
                onTap: () {
                  _busManager.saveBusLine();
                },
                child: Text(StringRes.saveBusLine,
                    style: StyleRes.saveBusButtonTextStyle),
              )),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: MaterialButton(
              color: Colors.blueAccent,
              child: _busManager.busLine == null
                  ? Text(StringRes.chooseBus,
                      style: StyleRes.chooseBusButtonTextStyle)
                  : Text(_busManager.busLine,
                      style: StyleRes.chooseBusButtonTextStyle),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: Text(StringRes.chooseBus),
                        children: _getBusLineWidgets(context),
                      );
                    });
              },
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: MaterialButton(
                color: Colors.blueAccent,
                child: _busManager.busDir == null
                    ? Text(StringRes.chooseDir,
                        style: StyleRes.chooseBusButtonTextStyle)
                    : Text(_busManager.busDir.direction,
                        style: StyleRes.chooseBusButtonTextStyle),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: Text(StringRes.chooseDir),
                          children: _getBusDirWidgets(context),
                        );
                      });
                },
              )),
          Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: MaterialButton(
                color: Colors.blueAccent,
                child: _busManager.busSelfStop == null
                    ? Text(StringRes.chooseStation,
                        style: StyleRes.chooseBusButtonTextStyle)
                    : Text(_busManager.busSelfStop.name,
                        style: StyleRes.chooseBusButtonTextStyle),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: Text(StringRes.chooseStation),
                          children: _getBusStationWidgets(context),
                        );
                      });
                },
              )),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: MaterialButton(
                color: Colors.greenAccent,
                child: Text(StringRes.queryBus,
                    style: StyleRes.chooseBusButtonTextStyle),
                onPressed: () {
                  if (_busManager.busLine != null &&
                      _busManager.busDir != null &&
                      _busManager.busSelfStop != null) {
                    _busManager
                        .getOnlineBusInfo(context)
                        .then(queryStationsCallBack);
                  } else {
                    String msg = StringRes.choose_bus_hint;
                    if (_busManager.busDir == null) {
                      msg = StringRes.choose_dir_hint;
                    } else if (_busManager.busSelfStop == null) {
                      msg = StringRes.choose_selfStop_hint;
                    }
                    Fluttertoast.showToast(
                        msg: msg,
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white);
                  }
                }),
          )
        ],
      )),
    );
  }

  List<SimpleDialogOption> _getBusLineWidgets(BuildContext context) {
    var busLineWeights = <SimpleDialogOption>[];
    for (String bus in _busManager.busLineList) {
      busLineWeights.add(SimpleDialogOption(
        child: Text(bus),
        onPressed: () {
          Navigator.of(context).pop();
          print('choose$bus');
          if (bus != _busManager.busLine) {
            _busManager.busDir = null;
            _busManager.busSelfStop = null;
            _busManager.busLine = bus;
            _busManager.stationInfoList.clear();
            _busManager.getDirList().then(updateDirCallBack);
          }
        },
      ));
    }
    return busLineWeights;
  }

  List<SimpleDialogOption> _getBusDirWidgets(BuildContext context) {
    var busLineWeights = <SimpleDialogOption>[];
    for (DirInfo dir in _busManager.dirInfoList) {
      busLineWeights.add(SimpleDialogOption(
        child: Text(dir.direction),
        onPressed: () {
          Navigator.of(context).pop();
          print('choose${dir.direction}');
          _busManager.busSelfStop = null;
          _busManager.busDir = dir;
          _busManager.getStationList().then(updateStationsCallBack);
        },
      ));
    }
    return busLineWeights;
  }

  List<SimpleDialogOption> _getBusStationWidgets(BuildContext context) {
    var busLineWeights = <SimpleDialogOption>[];
    for (StationInfo station in _busManager.stationInfoList) {
      busLineWeights.add(SimpleDialogOption(
        child: Text(station.name),
        onPressed: () {
          Navigator.of(context).pop();
          print('choose${station.name}');
          setState(() {
            _busManager.busSelfStop = station;
          });
        },
      ));
    }
    return busLineWeights;
  }
}
