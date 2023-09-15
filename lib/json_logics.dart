import 'dart:io';

import 'package:path_provider/path_provider.dart';

var initialJson = '[{"name":"Sam Colder","phone":"1234567890"},{"name":"Peter McKinney","phone":"0987654321"},{"name":"Katie Newton","phone":"555-555-5555"}]';

void initializeJSON() async {
  final Directory? jsonDir = await getDownloadsDirectory();
  String checkPath = '${jsonDir?.path}/contacts.json';
  if (File(checkPath).existsSync()) {
    // writeJSON(checkPath);
  } else {
    writeJSON(checkPath);
  }
}

void writeJSON(String checkPath) {
  File file = File(checkPath);
  file.writeAsString(initialJson);
}
