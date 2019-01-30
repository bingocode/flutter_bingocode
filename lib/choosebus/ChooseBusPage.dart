import 'dart:convert';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bingocode/bean/DirInfo.dart';
import 'package:flutter_bingocode/bean/StationInfo.dart';
import 'package:flutter_bingocode/choosebus/SearchBusPage.dart';
import 'package:flutter_bingocode/manager/BusManager.dart';
import 'package:flutter_bingocode/myinfo/MyInfoIcon.dart';
import 'package:flutter_bingocode/resources/strings.dart';
import 'package:flutter_bingocode/resources/styles.dart';
import 'package:flutter_bingocode/route/CustomRoute.dart';
import 'package:flutter_bingocode/savebus/SaveBusIcon.dart';
import 'package:flutter_bingocode/showbus/ShowBusPage.dart';
import 'package:flutter_bingocode/util/CommonUtil.dart';
import 'package:flutter_bingocode/util/ConstantUtil.dart';
import 'package:nima/nima_actor.dart';

class ChooseBusPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChooseBusState();
  }
}

class ChooseBusState extends State<ChooseBusPage> {
  static const STEP_COUNT = 3;
  static const STEP_CHOOSE_BUS = 0;
  static const STEP_CHOOSE_DIR = 1;
  static const STEP_CHOOSE_STATION = 2;
  final Utf8Decoder decoder = new Utf8Decoder();
  BusManager _busManager;
  UpdateCallBack<List<String>> updateBusesCallBack;
  UpdateCallBack<List<DirInfo>> updateDirCallBack;
  UpdateCallBack<List<StationInfo>> updateStationsCallBack;
  UpdateCallBack<List<StationInfo>> queryStationsCallBack;
  int currentStep = STEP_CHOOSE_BUS;
  bool hasDirSaved = true;
  bool hasStationSaved = true;

  @override
  void initState() {
    super.initState();
    _busManager = BusManager();
    updateBusesCallBack = (List<String> buses) {
      showSearch(context: context, delegate: searchBarDelegate(buses))
          .then((String bus) {
        setState(() {
          if (bus != null && bus != _busManager.busLine) {
            _busManager.busLine = bus;
          }
        });
      });
    };
    updateDirCallBack = (List<DirInfo> dirinfos) {
      setState(() {
        currentStep = STEP_CHOOSE_DIR;
        if (hasDirSaved) {
          for (DirInfo info in dirinfos) {
            if (info.directionId == _busManager.busDirId) {
              _busManager.busDir = info;
              if (hasStationSaved) {
                _busManager.getStationList().then(updateStationsCallBack);
              }
            }
          }
        }
        hasDirSaved = false;
      });
    };
    updateStationsCallBack = (List<StationInfo> staionInfos) {
      setState(() {
        currentStep = STEP_CHOOSE_STATION;
        if (hasStationSaved) {
          for (StationInfo info in staionInfos) {
            if (info.index == _busManager.busSelfStopId) {
              _busManager.busSelfStop = info;
            }
          }
        }
        hasStationSaved = false;
      });
    };

    queryStationsCallBack = (List<StationInfo> dirinfos) {
      print("query onLine busInfo");
      Navigator.push(context, FadeRoute(ShowBusPage()));
    };
    _busManager.getSavedBusLine().then((Map<String, String> savedMap) {
      setState(() {
        _busManager.busLine = savedMap[KeyConstant.keyBusLine];
        _busManager.busDirId = savedMap[KeyConstant.keyBusDir];
        _busManager.busSelfStopId = savedMap[KeyConstant.keyBusStation];
        hasDirSaved = _busManager.busDirId != null;
        hasStationSaved = _busManager.busSelfStopId != null;
        if (hasDirSaved) {
          _busManager.getDirList().then(updateDirCallBack);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: Colors.transparent,
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: Stack(
            children: <Widget>[
              buildContainer(context),
              Container(
                alignment: Alignment.bottomLeft,
                margin: EdgeInsets.fromLTRB(16, 0, 0, 16),
                child: MyInfoIcon(),
              )
            ],
          ),
          floatingActionButton: SaveBusIcon(),
        ));
  }

  Container buildContainer(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/choose_buses_bg.jpg'),
                fit: BoxFit.fitHeight)),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              child: new FlareActor("assets/awesomeLoading.flr",
                  alignment: Alignment.center,
                  fit: BoxFit.scaleDown,
                  animation: "play"),
            ),
            Container(
              width: 100,
              height: 100,
              child: currentStep >= STEP_CHOOSE_DIR
                  ? NimaActor('assets/runLoading.nima',
                      fit: BoxFit.scaleDown, animation: 'Run')
                  : NimaActor('assets/runLoading.nima', fit: BoxFit.scaleDown),
            ),
            (hasDirSaved || hasStationSaved)
                ? Container()
                : Stepper(
                    currentStep: this.currentStep,
                    steps: [
                      new Step(
                          // Title of the Step
                          title: new Text(
                              _busManager.busLine == null
                                  ? StringRes.chooseBus
                                  : StringRes.chooseBus +
                                      ': ${_busManager.busLine}',
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: StyleRes.chooseBusButtonTextStyle),
                          content: _getChooseBusItem(),
                          isActive: currentStep >= STEP_CHOOSE_BUS),
                      new Step(
                          title: new Text(
                              _busManager.busDir == null
                                  ? StringRes.chooseDir
                                  : StringRes.chooseDir +
                                      ': ${_busManager.busDir.direction}',
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: StyleRes.chooseBusButtonTextStyle),
                          content: _getChooseDirItem(),
                          // You can change the style of the step icon i.e number, editing, etc.
                          isActive: currentStep >= STEP_CHOOSE_DIR),
                      new Step(
                          title: new Text(
                              _busManager.busSelfStop == null
                                  ? StringRes.chooseStation
                                  : StringRes.chooseStation +
                                      ': ${_busManager.busSelfStop.name}',
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: StyleRes.chooseBusButtonTextStyle),
                          content: _getChooseStationItem(),
                          isActive: currentStep >= STEP_CHOOSE_STATION),
                    ],
                    controlsBuilder: (BuildContext context,
                        {VoidCallback onStepContinue,
                        VoidCallback onStepCancel}) {
                      return Row(
                        children: <Widget>[
                          FlatButton(
                            onPressed: onStepContinue,
                            child: Text(
                                currentStep < STEP_CHOOSE_STATION
                                    ? StringRes.next_step
                                    : StringRes.queryBus,
                                style: StyleRes.saveBusButtonTextStyle),
                          ),
                          FlatButton(
                            onPressed: onStepCancel,
                            child: Text(StringRes.concel,
                                style: StyleRes.chooseBusButtonTextStyle),
                          ),
                        ],
                      );
                    },
                    type: StepperType.vertical,
                    onStepCancel: () {
                      setState(() {
                        switch (currentStep) {
                          case STEP_CHOOSE_BUS:
                            _busManager.busLine = null;
                            currentStep = 0;
                            break;
                          case STEP_CHOOSE_DIR:
                            _busManager.dirInfoList.clear();
                            _busManager.busDir = null;
                            currentStep = currentStep - 1;
                            break;
                          case STEP_CHOOSE_STATION:
                            _busManager.stationInfoList.clear();
                            _busManager.busSelfStop = null;
                            currentStep = currentStep - 1;
                            break;
                        }
                      });
                      print("onStepCancel : " + currentStep.toString());
                    },
                    onStepContinue: () {
                      String msg;
                      if (_busManager.busLine == null) {
                        msg = StringRes.choose_bus_hint;
                      } else if (_busManager.busDir == null) {
                        msg = StringRes.choose_dir_hint;
                      } else if (_busManager.busSelfStop == null) {
                        msg = StringRes.choose_selfStop_hint;
                      }
                      switch (currentStep) {
                        case STEP_CHOOSE_BUS:
                          if (_busManager.busLine != null) {
                            //todo 加载进度
                            setState(() {
                              _busManager.getDirList().then(updateDirCallBack);
                            });
                          } else {
                            CommonUtil.toast(msg);
                          }
                          break;
                        case STEP_CHOOSE_DIR:
                          if (_busManager.busDir != null) {
                            //todo 加载进度
                            setState(() {
                              _busManager
                                  .getStationList()
                                  .then(updateStationsCallBack);
                            });
                          } else {
                            CommonUtil.toast(msg);
                          }
                          break;
                        case STEP_CHOOSE_STATION:
                          if (msg == null) {
                            //todo 加载进度
                            setState(() {
                              _busManager
                                  .getOnlineBusInfo(context)
                                  .then(queryStationsCallBack);
                            });
                          } else {
                            CommonUtil.toast(msg);
                          }
                          break;
                      }
                      print("onStepContinue : " + currentStep.toString());
                    },
                  ),
          ],
        )));
  }

  Widget _getChooseBusItem() {
    return MaterialButton(
      color: Colors.blueAccent,
      child: _busManager.busLine == null
          ? Text(StringRes.chooseBus, style: StyleRes.chooseBusButtonTextStyle)
          : Text(_busManager.busLine, style: StyleRes.chooseBusButtonTextStyle),
      onPressed: () {
        setState(() {
          _busManager.getBusList().then(updateBusesCallBack);
        });
      },
    );
  }

  Widget _getChooseDirItem() {
    return MaterialButton(
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
        });
  }

  Widget _getChooseStationItem() {
    return MaterialButton(
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
        });
  }

  List<SimpleDialogOption> _getBusDirWidgets(BuildContext context) {
    var busLineWeights = <SimpleDialogOption>[];
    for (DirInfo dir in _busManager.dirInfoList) {
      busLineWeights.add(SimpleDialogOption(
        child: Text(dir.direction),
        onPressed: () {
          Navigator.of(context).pop();
          print('chooseDir${dir.direction}');
          setState(() {
            _busManager.busDir = dir;
          });
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
          print('chooseStation${station.name}');
          setState(() {
            _busManager.busSelfStop = station;
          });
        },
      ));
    }
    return busLineWeights;
  }
}
