class StationInfo {
  String name;
  String index;
  // 当前站有公交
  var hasBus = false;
  // 有公交正在驶往该站
  var hasNextBus = false;
  StationInfo(this.name, this.index);

}
