import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bingocode/bean/StationInfo.dart';
import 'package:flutter_bingocode/util/ConstantUtil.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

class ShowBusPage extends StatefulWidget {
  String busLine;
  String dirId;
  String selfStationId;
  var stationInfoList = <StationInfo>[];

  ShowBusPage(
      this.busLine, this.dirId, this.selfStationId, this.stationInfoList);

  @override
  State<StatefulWidget> createState() {
    return ShowBusState(busLine, dirId, selfStationId, stationInfoList);
  }

}

class ShowBusState extends State<ShowBusPage> {
  final Utf8Decoder decoder = new Utf8Decoder();
  String busLine;
  String dirId;
  String selfStationId;
  var stationInfoList = <StationInfo>[];
  Timer timer;

  ShowBusState(
      this.busLine, this.dirId, this.selfStationId, this.stationInfoList);

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 10),(timer) {
      print('refreshData');
      _getOnlineBusInfo(busLine, dirId, selfStationId);
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
    TextStyle selfTextStyle = TextStyle();
    TextSpan hasNextBusSpan = TextSpan();
    TextSpan hasBusSpan = TextSpan();
    if (station.hasNextBus) {
      hasNextBusSpan = TextSpan(text: '->_->（即将到站)',style: TextStyle(color: Colors.blueAccent));
    }
    if (station.hasBus) {
      hasBusSpan = TextSpan(text: '^_^ (已到站)',style: TextStyle(color: Colors.greenAccent));
    }
    if (station.isSelfStop) {
      selfTextStyle = TextStyle(fontWeight:FontWeight.bold);
    }
    return Text.rich(TextSpan(
      text: data,
      style: selfTextStyle,
      children: <TextSpan>[
        hasNextBusSpan,
        hasBusSpan
      ]
    ));
  }

  void _getOnlineBusInfo(
      String busLine, String busDir, String busSelfStop) async {
    var busOnlineUrl = '${UrlConstant
        .getBusOnLineUrl}&selBLine=$busLine&selBDir=$busDir&selBStop=$busSelfStop';
    var responseBusOnline = await http.get(busOnlineUrl);
    var data = decoder.convert(responseBusOnline.bodyBytes);
    var buscList = <String>[]; //途中车辆
    var bussList = <String>[]; // 到站车辆
    if (responseBusOnline.statusCode == 200) {
      Map<String, dynamic> dataMap = json.decode(data);
      String htmlStr = dataMap['html'];
      dom.Document document = parse(htmlStr);
      var aEliments = document.getElementsByTagName("i");
      for (dom.Element e in aEliments) {
        var classValue = e.attributes['class'];
        if (classValue != null) {
          if (classValue == 'busc') {
            //途中车辆
            dom.Element parent = e.parent;
            String parentId = parent.attributes['id'];
            buscList.add(parentId.substring(0, parentId.length - 1));
          } else if (classValue == 'buss') {
            // 到站车辆
            dom.Element parent = e.parent;
            bussList.add((parent.attributes['id']));
          }
        }
      }
    } else {
      print(
          'request busOnline error ${responseBusOnline.statusCode.toString()}');
    }
    clearTags();
    for (StationInfo station in stationInfoList) {
      if (station.index == busSelfStop) {
        station.isSelfStop = true;
      }
      if (buscList.length > 0) {
        for (String index in buscList) {
          if (index == station.index) {
            station.hasNextBus = true;
            break;
          }
        }
      }

      if (bussList.length > 0) {
        for (String index in bussList) {
          if (index == station.index) {
            station.hasBus = true;
            break;
          }
        }
      }
    }
    setState(() {
    });
  }

  void clearTags() {
    for (StationInfo station in stationInfoList) {
      station.isSelfStop = false;
      station.hasNextBus = false;
      station.hasBus = false;
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }


}
