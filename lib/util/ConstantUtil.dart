
class UrlConstant {
  static const baseUrl = 'http://www.bjbus.com/home/ajax_rtbus_data.php';
  static const BingoUrl= 'http://39.107.71.82:8080';

  static const getBusesUrl = 'http://www.bjbus.com/home/index.php';
  static const getDirUrl = '$baseUrl?act=getLineDir';
  static const getStationUrl = '$baseUrl?act=getDirStation';
  static const getBusOnLineUrl = '$baseUrl?act=busTime';
  static const commentUrl = '$BingoUrl/comment?comment=';
}

class KeyConstant {
  static const keyBusLine = "busLine";
  static const keyBusDir = "busDir";
  static const keyBusStation = "busStation";
}