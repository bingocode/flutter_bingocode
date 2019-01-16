import 'package:flutter/material.dart';
import 'package:flutter_bingocode/bean/StationInfo.dart';

class ShowBusPage extends StatefulWidget {
  String busLine;
  String dirId;
  String selfStationId;
  var stationInfoList = <StationInfo>[];

  ShowBusPage(
      this.busLine, this.dirId, this.selfStationId, this.stationInfoList);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ShowBusState(busLine, dirId, selfStationId, stationInfoList);
  }
}

class ShowBusState extends State<ShowBusPage> {
  String busLine;
  String dirId;
  String selfStationId;
  var stationInfoList = <StationInfo>[];

  ShowBusState(
      this.busLine, this.dirId, this.selfStationId, this.stationInfoList);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: ListView.builder(
            itemCount: stationInfoList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: GestureDetector(
                  child: _getStationTextOnLine(stationInfoList[index]),
                ),
              );
            }),
      ),
    );
  }

  Text _getStationTextOnLine(StationInfo station) {
    String data = station.name;
    if (station.hasBus) {
      data = '$data ^_^';
    }
    if (station.hasNextBus) {
      data = '$data ->_->';
    }
    return Text(data);
  }
}
