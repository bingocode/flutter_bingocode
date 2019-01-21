class BusManager {
  // 工厂模式
  factory BusManager() =>_getInstance();
  static BusManager get instance => _getInstance();
  static BusManager _instance;

  BusManager._internal() {
    // 初始化
  }
  static BusManager _getInstance() {
    if (_instance == null) {
      _instance = new BusManager._internal();
    }
    return _instance;
  }
}
