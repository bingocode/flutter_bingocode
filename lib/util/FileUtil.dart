import 'package:path_provider/path_provider.dart';

import 'dart:io';

class FileUtil {
  static Future<File> getLocalBusesFile() async {
    // get the path to the document directory.
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/buses.txt');
  }

  static Future<List<String>> readLocalBuses() async {
    try {
      File file = await getLocalBusesFile();
      String contents = await file.readAsString();
      return contents.substring(1, contents.length-1).split(', ');
    } on FileSystemException {
      print('file error');
      return [];
    }
  }

  static Future<Null> saveBused(List<String> buses) async {
    // write the variable as a string to the file
    try {
      File file = await getLocalBusesFile();
      if(file.existsSync()) {
        file.deleteSync();
      }
      file.writeAsString(buses.toString());
    } on FileSystemException {
      print("file error");
    }
  }


}