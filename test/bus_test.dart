import 'dart:convert';

import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

//http://www.bjbus.com/home/ajax_rtbus_data.php?act=getLineDir&selBLine=140
//http://www.bjbus.com/home/ajax_rtbus_data.php?act=getDirStation&selBLine=140&selBDir=4817620473575672470
//http://www.bjbus.com/home/ajax_rtbus_data.php?act=busTime&selBLine=10&selBDir=5582831127904445311&selBStop=3
const baseUrl = 'http://www.bjbus.com/home/ajax_rtbus_data.php';

const getBusesUrl = 'http://www.bjbus.com/home/index.php';
const getDirUrl = '$baseUrl?act=getLineDir';
const getStationUrl = '$baseUrl?act=getDirStation';
const getBusOLineUrl = '$baseUrl?act=busTime';
var busLine = '963';
var busDir;
var busSelfStop = '5';
var buses = <String>[];

class BusStation {
  int index;
  String name;
}

main() async {
  // 拉取所有的公交路线
  var responseAllBus = await http.get(getBusesUrl);
  Utf8Decoder decoder = new Utf8Decoder();
  var data = decoder.convert(responseAllBus.bodyBytes);
  if (responseAllBus.statusCode == 200) {
    dom.Document document = parse(data);
    List<dom.Element> aEliments =
        document.getElementsByTagName("dd").where((dom.Element e) {
      return e.attributes["id"] == 'selBLine';
    }).toList();
    for (dom.Element e in aEliments) {
      for (dom.Element child in e.children) {
        print(child.text);
        buses.add(child.text);
      }
    }
  } else {
    print('fetch buses list error ${responseAllBus.statusCode.toString()}');
  }

  //获取交通路线，直接默认963
  var busDirUrl = '$getDirUrl&selBLine=$busLine';
  var responseBusDir = await http.get(busDirUrl);
  data = decoder.convert(responseBusDir.bodyBytes);
  if (responseBusDir.statusCode == 200) {
    dom.Document document = parse(data);
    List<dom.Element> aEliments = document.getElementsByTagName("a");
    for (dom.Element e in aEliments) {
      print(e.text);
      print(e.attributes["data-uuid"]);
      busDir = e.attributes["data-uuid"];
    }
  } else {
    print('request busdir error ${responseBusDir.statusCode.toString()}');
  }

  // 选择路线和方向获取公交的所有站点
  var busStationUrl = '$getStationUrl&selBLine=$busLine&selBDir=$busDir';
  var responseBusStation = await http.get(busStationUrl);
  data = decoder.convert(responseBusStation.bodyBytes);
  if (responseBusStation.statusCode == 200) {
    dom.Document document = parse(data);
    List<dom.Element> aEliments = document.getElementsByTagName("a");
    for (dom.Element e in aEliments) {
      print(e.text);
      print(e.attributes["data-seq"]);
    }
  }

  // 根据路线，方向，所在站点 获取实时公交情况
  var busOnlineUrl =
      '$getBusOLineUrl&selBLine=$busLine&selBDir=$busDir&selBStop=$busSelfStop';
  var responseBusOnline = await http.get(busOnlineUrl);
  data = decoder.convert(responseBusOnline.bodyBytes);
  var buscList = <int>[]; //途中车辆
  var bussList = <int>[]; // 到站车辆
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
          parentId = parentId.substring(0, parentId.length - 1);
          buscList.add(int.parse(parentId));
        } else if (classValue == 'buss') {
          // 到站车辆
          dom.Element parent = e.parent;
          bussList.add(int.parse(parent.attributes['id']));
        }
      }
    }
    print("途中车辆buscList");
    for (int index in buscList) {
      print(index);
    }
    print("到站车辆bussList");
    for (int index in bussList) {
      print(index);
    }
  }
}
