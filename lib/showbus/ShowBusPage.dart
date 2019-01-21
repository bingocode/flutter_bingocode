import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bingocode/bean/StationInfo.dart';
import 'package:flutter_bingocode/manager/BusManager.dart';

class ShowBusPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ShowBusState();
  }
}

class ShowBusState extends State<ShowBusPage> {
  static const UPDATE_TIME = 10;
  BusManager _busManager;
  Timer timer;
  UpdateCallBack<List<StationInfo>> updateStationsCallBack;

  @override
  void initState() {
    super.initState();
    updateStationsCallBack = (List<StationInfo> dirinfos) {
      setState(() {});
    };
    _busManager = BusManager();
    // 每隔10s更新界面
    timer = Timer.periodic(const Duration(seconds: UPDATE_TIME), (timer) {
      print('refreshData');
      _busManager.getOnlineBusInfo(context).then(updateStationsCallBack);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            body: ListView.separated(
                // 按需加载，适合加载长列表
                itemCount: _busManager.stationInfoList.length,
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 1,
                  );
                },
                itemBuilder: (context, index) {
                  return _getListTitle(_busManager.stationInfoList[index]);
                })));
  }

  ListTile _getListTitle(StationInfo station) {
    String data = station.name;
    TextStyle selfTextStyle = TextStyle();
    TextSpan hasNextBusSpan = TextSpan();
    TextSpan hasBusSpan = TextSpan();
    Color busIconColor;
    if (station.hasNextBus) {
      hasNextBusSpan = TextSpan(
          text: '->_->（即将到站)', style: TextStyle(color: Colors.blueAccent));
      busIconColor = Colors.blueAccent;
    }
    if (station.hasBus) {
      hasBusSpan = TextSpan(
          text: '^_^ (已到站)', style: TextStyle(color: Colors.greenAccent));
      busIconColor = Colors.greenAccent;
    }
    if (station.isSelfStop) {
      selfTextStyle = TextStyle(fontWeight: FontWeight.bold);
    }
    return ListTile(
        leading: station.isSelfStop
            ? Icon(Icons.star, color: Colors.red)
            : Icon(Icons.arrow_downward),
        trailing: busIconColor == null
            ? Icon(Icons.arrow_downward)
            : Icon(Icons.directions_bus, color: busIconColor),
        title: Text.rich(TextSpan(
            text: data,
            style: selfTextStyle,
            children: <TextSpan>[hasNextBusSpan, hasBusSpan])));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
