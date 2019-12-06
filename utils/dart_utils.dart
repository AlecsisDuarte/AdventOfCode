import 'dart:io' show Platform, File;
import 'package:path/path.dart' show join, dirname, normalize;

Future<String> readInput(int year, int day, {fileName = "input.txt"}) async {
  String filePath = normalize(join(dirname(Platform.script.toString()), '../../',
      year.toString(), "Day$day", fileName));

  File inputFile = File(filePath.substring(5));
  return inputFile.readAsStringSync();
}