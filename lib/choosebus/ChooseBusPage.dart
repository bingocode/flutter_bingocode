import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bingocode/bean/DirInfo.dart';
import 'package:flutter_bingocode/bean/StationInfo.dart';
import 'package:flutter_bingocode/resources/strings.dart';
import 'package:flutter_bingocode/resources/styles.dart';
import 'package:flutter_bingocode/showbus/ShowBusPage.dart';
import 'package:flutter_bingocode/util/ConstantUtil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChooseBusPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChooseBusState();
  }
}

class ChooseBusState extends State<ChooseBusPage> {
  final Utf8Decoder decoder = new Utf8Decoder();
  var busLineList = <String>[];
  var dirInfoList = <DirInfo>[];
  var stationInfoList = <StationInfo>[];
  String busLine;
  DirInfo busDir;
  StationInfo busSelfStop;

  @override
  void initState() {
    super.initState();
    _getSavedBusLine().then((String saveBusLine) {
      busLine = saveBusLine;
      if (busLine != null) {
        _getDirList(busLine);
      }
      _getBusList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/choose_bus_bg.jpg'), fit: BoxFit.fitHeight)),
      child: Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center, // 主轴方向居中
            crossAxisAlignment: CrossAxisAlignment.center, // 辅轴方向居中
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      _saveBusLine(busLine);
                    },
                    child: Text(StringRes.saveBusLine,
                        style: StyleRes.saveBusButtonTextStyle),
                  )),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: MaterialButton(
                  color: Colors.blueAccent,
                  child: busLine == null
                      ? Text(StringRes.chooseBus,
                      style: StyleRes.chooseBusButtonTextStyle)
                      : Text(busLine, style: StyleRes.chooseBusButtonTextStyle),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            title: Text(StringRes.chooseBus),
                            children: _getBusLineWeights(context),
                          );
                        });
                  },
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: MaterialButton(
                    color: Colors.blueAccent,
                    child: busDir == null
                        ? Text(StringRes.chooseDir,
                        style: StyleRes.chooseBusButtonTextStyle)
                        : Text(busDir.direction,
                        style: StyleRes.chooseBusButtonTextStyle),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              title: Text(StringRes.chooseDir),
                              children: _getBusDirWeights(context),
                            );
                          });
                    },
                  )),
              Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: MaterialButton(
                    color: Colors.blueAccent,
                    child: busSelfStop == null
                        ? Text(StringRes.chooseStation,
                        style: StyleRes.chooseBusButtonTextStyle)
                        : Text(busSelfStop.name,
                        style: StyleRes.chooseBusButtonTextStyle),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SimpleDialog(
                              title: Text(StringRes.chooseStation),
                              children: _getBusStationWeights(context),
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
                      if (busLine != null &&
                          busDir != null &&
                          busSelfStop != null) {
                        _getOnlineBusInfo(
                            busLine, busDir.directionId, busSelfStop.index);
                      } else {
                        String msg = StringRes.choose_bus_hint;
                        if (busDir == null) {
                          msg = StringRes.choose_dir_hint;
                        } else if (busSelfStop == null) {
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

  _saveBusLine(String busLine) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(KeyConstant.keyBusLine, busLine);
    Fluttertoast.showToast(
        msg: StringRes.save_successed,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white);
  }

  Future<String> _getSavedBusLine() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(KeyConstant.keyBusLine);
  }

  List<SimpleDialogOption> _getBusLineWeights(BuildContext context) {
    var busLineWeights = <SimpleDialogOption>[];
    for (String bus in busLineList) {
      busLineWeights.add(SimpleDialogOption(
        child: Text(bus),
        onPressed: () {
          Navigator.of(context).pop();
          print('choose$bus');
          if (bus != busLine) {
            busDir = null;
            busSelfStop = null;
            busLine = bus;
            stationInfoList.clear();
            _getDirList(busLine);
            setState(() {});
          }
        },
      ));
    }
    return busLineWeights;
  }

  List<SimpleDialogOption> _getBusDirWeights(BuildContext context) {
    var busLineWeights = <SimpleDialogOption>[];
    for (DirInfo dir in dirInfoList) {
      busLineWeights.add(SimpleDialogOption(
        child: Text(dir.direction),
        onPressed: () {
          Navigator.of(context).pop();
          print('choose${dir.direction}');
          busSelfStop = null;
          setState(() {
            busDir = dir;
            _getStationList(busLine, busDir.directionId);
          });
        },
      ));
    }
    return busLineWeights;
  }

  List<SimpleDialogOption> _getBusStationWeights(BuildContext context) {
    var busLineWeights = <SimpleDialogOption>[];
    for (StationInfo station in stationInfoList) {
      busLineWeights.add(SimpleDialogOption(
        child: Text(station.name),
        onPressed: () {
          Navigator.of(context).pop();
          print('choose${station.name}');
          setState(() {
            busSelfStop = station;
          });
        },
      ));
    }
    return busLineWeights;
  }

  // 获取所有公交线
  void _getBusList() async {
    busLineList.clear();
    var responseAllBus = await http.get(UrlConstant.getBusesUrl);
    var data = decoder.convert(responseAllBus.bodyBytes);
    if (responseAllBus.statusCode == 200) {
      dom.Document document = parse(data);
      List<dom.Element> aEliments =
          document.getElementsByTagName("dd").where((dom.Element e) {
        return e.attributes["id"] == 'selBLine';
      }).toList();
      print('all busLine:');
      for (dom.Element e in aEliments) {
        for (dom.Element child in e.children) {
          print(child.text);
          busLineList.add(child.text);
        }
      }
    } else {
      print('fetch buses list error ${responseAllBus.statusCode.toString()}');
    }
    setState(() {});
  }

//  根据选择的公交线获取两个方向信息
  void _getDirList(String busLine) async {
    dirInfoList.clear();
    var busDirUrl = '${UrlConstant.getDirUrl}&selBLine=$busLine';
    var responseBusDir = await http.get(busDirUrl);
    var data = decoder.convert(responseBusDir.bodyBytes);
    if (responseBusDir.statusCode == 200) {
      dom.Document document = parse(data);
      List<dom.Element> aEliments = document.getElementsByTagName("a");
      for (dom.Element e in aEliments) {
        print(e.text);
        print(e.attributes["data-uuid"]);
        dirInfoList.add(DirInfo(e.text, e.attributes["data-uuid"]));
      }
    } else {
      print('request busdir error ${responseBusDir.statusCode.toString()}');
    }
    setState(() {});
  }

  // 根据所选线路和方向获取所有站点信息
  void _getStationList(String busLine, String busDir) async {
    stationInfoList.clear();
    var busStationUrl =
        '${UrlConstant.getStationUrl}&selBLine=$busLine&selBDir=$busDir';
    var responseBusStation = await http.get(busStationUrl);
    var data = decoder.convert(responseBusStation.bodyBytes);
    if (responseBusStation.statusCode == 200) {
      dom.Document document = parse(data);
      List<dom.Element> aEliments = document.getElementsByTagName("a");
      for (dom.Element e in aEliments) {
        print(e.text);
        print(e.attributes["data-seq"]);
        stationInfoList.add(StationInfo(e.text, e.attributes["data-seq"]));
      }
    } else {
      print(
          'request busStationLists error ${responseBusStation.statusCode.toString()}');
    }
    setState(() {});
  }

  // 获取实时公交信息
  void _getOnlineBusInfo(
      String busLine, String busDir, String busSelfStop) async {
    var busOnlineUrl =
        '${UrlConstant.getBusOnLineUrl}&selBLine=$busLine&selBDir=$busDir&selBStop=$busSelfStop';
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
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ShowBusPage(busLine, busDir, busSelfStop, stationInfoList)));
  }

  void clearTags() {
    for (StationInfo station in stationInfoList) {
      station.isSelfStop = false;
      station.hasNextBus = false;
      station.hasBus = false;
    }
  }
}
