import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bingocode/bean/DirInfo.dart';
import 'package:flutter_bingocode/bean/StationInfo.dart';
import 'package:flutter_bingocode/resources/strings.dart';
import 'package:flutter_bingocode/util/CommonUtil.dart';
import 'package:flutter_bingocode/util/ConstantUtil.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

typedef UpdateCallBack<T> = Function(T data);

class BusManager {
  // 工厂模式
  factory BusManager() => _getInstance();

  static BusManager get instance => _getInstance();
  static BusManager _instance;
  final Utf8Decoder decoder = new Utf8Decoder();
  var busLineList = <String>[];
  var dirInfoList = <DirInfo>[];
  var stationInfoList = <StationInfo>[];
  String busLine;
  String busDirId;
  String busSelfStopId;
  DirInfo busDir;
  StationInfo busSelfStop;

  BusManager._internal() {
    // 初始化
  }

  static BusManager _getInstance() {
    if (_instance == null) {
      _instance = new BusManager._internal();
    }
    return _instance;
  }

  Future<Map<String, String>> getSavedBusLine() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      KeyConstant.keyBusLine: prefs.getString(KeyConstant.keyBusLine),
      KeyConstant.keyBusDir: prefs.getString(KeyConstant.keyBusDir),
      KeyConstant.keyBusStation: prefs.getString(KeyConstant.keyBusStation)
    };
  }

  saveBusLine(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (busLine == null) {
      CommonUtil.toast(StringRes.choose_bus_hint);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(StringRes.saveBusLine),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _getSaveDialogItems(),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(StringRes.concel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(StringRes.confirm),
                  onPressed: () {
                    prefs.setString(KeyConstant.keyBusLine, busLine);
                    prefs.setString(KeyConstant.keyBusDir,
                        busDir == null ? null : busDir.directionId);
                    prefs.setString(KeyConstant.keyBusStation,
                        busSelfStop == null ? null : busSelfStop.index);
                    CommonUtil.toast(StringRes.save_successed);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  List<Text> _getSaveDialogItems() {
    var items = <Text>[];
    items.add(Text(StringRes.chooseBus + ': $busLine'));
    if (busDir != null) {
      items.add(Text(StringRes.chooseDir + '：${busDir.direction}'));
    }
    if (busSelfStop != null) {
      items.add(Text(StringRes.chooseStation + '：${busSelfStop.name}'));
    }
    return items;
  }

  // 获取所有公交线
  Future<List<String>> getBusList() async {
    if (busLineList.isNotEmpty) {
      return busLineList;
    }
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
    return busLineList;
  }

//  根据选择的公交线获取两个方向信息
  Future<List<DirInfo>> getDirList() async {
    busDir = null;
    busSelfStop = null;
    stationInfoList.clear();
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
    return dirInfoList;
  }

  // 根据所选线路和方向获取所有站点信息
  Future<List<StationInfo>> getStationList() async {
    busSelfStop = null;
    stationInfoList.clear();
    var busStationUrl =
        '${UrlConstant.getStationUrl}&selBLine=$busLine&selBDir=${busDir.directionId}';
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
    return stationInfoList;
  }

  // 获取实时公交信息
  Future<List<StationInfo>> getOnlineBusInfo(final BuildContext context) async {
    var busOnlineUrl =
        '${UrlConstant.getBusOnLineUrl}&selBLine=$busLine&selBDir=${busDir.directionId}&busDir&selBStop=${busSelfStop.index}';
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
    _clearTags();
    for (StationInfo station in stationInfoList) {
      if (station.index == busSelfStop.index) {
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
    return stationInfoList;
  }

  void _clearTags() {
    for (StationInfo station in stationInfoList) {
      station.isSelfStop = false;
      station.hasNextBus = false;
      station.hasBus = false;
    }
  }
}
