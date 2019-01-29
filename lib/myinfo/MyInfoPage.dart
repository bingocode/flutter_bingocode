import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bingocode/myinfo/FavoriteIcon.dart';
import 'package:flutter_bingocode/resources/strings.dart';
import 'package:flutter_bingocode/resources/styles.dart';
import 'package:flutter_bingocode/util/CommonUtil.dart';
import 'package:url_launcher/url_launcher.dart';

class MyInfoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MyInfoState();
  }
}

class MyInfoState extends State<MyInfoPage> {
  var seprateItems = <Widget>[];
  var mainItems = <Widget>[];

  @override
  void initState() {
    super.initState();
    _initSeprateItems();
    _initMainItems();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.white70,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          body: ListView.separated(
            itemCount: mainItems.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return index >= seprateItems.length
                  ? Divider()
                  : seprateItems[index];
            },
            itemBuilder: (context, index) {
              return mainItems[index];
            },
          ),
          floatingActionButton: Hero(
            tag: 'hero_favorite',
            child: FavoriteIcon(),
            transitionOnUserGestures: true,
          )),
    );
  }

  _initSeprateItems() {
    seprateItems.add(_buildSeprateItem(StringRes.project_introduce));
    seprateItems.add(_buildSeprateItem(StringRes.project_address));
    seprateItems.add(_buildSeprateItem(StringRes.version_info));
    seprateItems.add(_buildSeprateItem(StringRes.comment));

  }

  Widget _buildSeprateItem(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Text(title, style: StyleRes.seprate_text),
    );
  }

  Widget _buildMainItem(Widget content) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      child: Card(
          color: Colors.white,
          elevation: 8,
          child: Padding(padding: const EdgeInsets.all(15.0), child: content)),
    );
  }

  _initMainItems() {
    var m0 = Container(
      height: 200,
      alignment: Alignment.topCenter,
      child: FlareActor(
        "assets/SpaceDemo.flr",
        alignment: Alignment.topCenter,
        fit: BoxFit.fitWidth,
        animation: "loading",
      ),
    );

    var m1 = _buildMainItem(
        Text.rich(TextSpan(text: StringRes.my_infos, children: <TextSpan>[
      TextSpan(
        text: StringRes.beijin_bus,
        style: StyleRes.LinkTextStyle,
        recognizer: new TapGestureRecognizer()
          ..onTap = () {
            //增加一个点击事件
            print('open ${StringRes.beijin_bus_addr}');
            launch(StringRes.beijin_bus_addr);
          },
      )
    ])));

    var m2 = _buildMainItem(Text.rich(TextSpan(
        text: StringRes.project_github,
        style: StyleRes.LinkTextStyle,
        recognizer: new TapGestureRecognizer()
          ..onTap = () {
            //增加一个点击事件
            print('open ${StringRes.project_github_address}');
            launch(StringRes.project_github_address);
          },
        children: <TextSpan>[
          TextSpan(
            text: StringRes.project_juejing,
            style: StyleRes.LinkTextStyle,
            recognizer: new TapGestureRecognizer()
              ..onTap = () {
                //增加一个点击事件
                print('open ${StringRes.project_juejing_address}');
                launch(StringRes.project_juejing_address);
              },
          )
        ])));
    var m3 = _buildMainItem(Text(StringRes.version));

    var m4 = _buildMainItem(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TextField(
                maxLines: 5,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ))),
        ),
        InkWell(
          onTap: () {
            CommonUtil.toast("提交成功");
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(8,3,8,3),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(color: Colors.blueAccent, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: Text(StringRes.submit, style: StyleRes.saveBusButtonTextStyle)),
        ),
      ],
    ));

    mainItems.add(m0);
    mainItems.add(m1);
    mainItems.add(m2);
    mainItems.add(m3);
    mainItems.add(m4);
  }
}
