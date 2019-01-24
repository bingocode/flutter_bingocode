import 'package:path_provider/path_provider.dart';

import 'dart:io';

class FileUtil {
  Future<File> getLocalBusesFile() async {
    // get the path to the document directory.
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/buses.txt');
  }

  Future<List<String>> readLocalBuses() async {
    try {
      File file = await getLocalBusesFile();
      String contents = await file.readAsString();
      return contents.split(',');
    } on FileSystemException {
      return [];
    }
  }

  Future<Null> saveBused(List<String> buses) async {
    // write the variable as a string to the file
    await (await getLocalBusesFile()).writeAsString(buses.toString());
  }

}