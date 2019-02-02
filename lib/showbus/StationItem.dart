import 'package:flutter/material.dart';
import 'package:flutter_bingocode/bean/StationInfo.dart';
abstract class BaseStationItem {
  static const STATE_NO_BUS = 0;
  static const STATE_COMING_BUS = 1;
  static const STATE_ARRIVED_BUS = 2;
  StationInfo station;
  ListTile getWidget();

  _initState() {
    if(station.hasBus) {
      return STATE_ARRIVED_BUS;
    } else if (station.hasNextBus) {
      return STATE_COMING_BUS;
    } else {
      return STATE_NO_BUS;
    }
  }

  AnimatedOpacity buildIcon() {
    var state = _initState();
    switch (state) {
     case STATE_ARRIVED_BUS:
     return AnimatedOpacity(
       child: Icon(Icons.airport_shuttle, color: Colors.greenAccent),
       duration: const Duration(seconds: 2),
       opacity: 1.0,
    );
      case STATE_COMING_BUS:
        return AnimatedOpacity(
          child: Icon(Icons.directions_bus, color: Colors.blueAccent),
          duration: const Duration(seconds: 2),
          opacity: 1.0,
        );
      case STATE_NO_BUS:
        return AnimatedOpacity(
          child: Icon(Icons.arrow_downward, color: Colors.white),
          duration: const Duration(seconds: 2),
          opacity: 1,
        );
    }
  }
}

// 非目标站

class NormalStation extends BaseStationItem{

  NormalStation(StationInfo station) {
    this.station = station;
  }

  @override
  ListTile getWidget() {
    return ListTile(
      title: Text(station.name, style: TextStyle(color: Colors.white)),
        trailing: buildIcon());
  }

}


// 目标站

class TargetStation extends BaseStationItem{

  TargetStation(StationInfo station) {
    this.station = station;
  }

  @override
  ListTile getWidget() {
    return ListTile(
        title: Text(station.name, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        trailing: buildIcon());
  }

}


