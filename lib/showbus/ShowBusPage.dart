import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bingocode/bean/StationInfo.dart';
import 'package:flutter_bingocode/manager/BusManager.dart';
import 'package:flutter_bingocode/resources/strings.dart';

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
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/show_bus_bg.jpg'),
                      fit: BoxFit.fitHeight)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(StringRes.coming_bus, style: TextStyle(color: Colors.white)),
                        Icon(Icons.directions_bus, color: Colors.blueAccent),
                        Text(StringRes.arrived_bus, style: TextStyle(color: Colors.white)),
                        Icon(Icons.directions_bus, color: Colors.greenAccent),
                      ],
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                        // 按需加载，适合加载长列表
                        itemCount: _busManager.stationInfoList.length,
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 1,
                            indent: 15,
                          );
                        },
                        itemBuilder: (context, index) {
                          return _getListTitle(_busManager.stationInfoList[index]);
                        }),
                  ),
                ],
              ),
            )));
  }

  ListTile _getListTitle(StationInfo station) {
    String data = station.name;
    TextStyle selfTextStyle = TextStyle(color: Colors.white);
    TextSpan hasNextBusSpan = TextSpan();
    TextSpan hasBusSpan = TextSpan();
    Color busIconColor;
    if (station.hasNextBus) {
      hasNextBusSpan = TextSpan(
          text: StringRes.coming_bus, style: TextStyle(color: Colors.blueAccent));
      busIconColor = Colors.blueAccent;
    }
    if (station.hasBus) {
      hasBusSpan = TextSpan(
          text: StringRes.arrived_bus, style: TextStyle(color: Colors.greenAccent));
      busIconColor = Colors.greenAccent;
    }
    if (station.isSelfStop) {
      selfTextStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
    }
    return ListTile(
        trailing: busIconColor == null
            ? Icon(Icons.arrow_downward, color: Colors.white,)
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
