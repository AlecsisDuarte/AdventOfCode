import 'dart:convert';
import 'dart:io' show Platform, File;
import 'package:path/path.dart' show join, dirname, normalize;

const String DEFAULT_FILE_NAME = "input.txt";

Future<String> readInput(
  int year,
  int day, {
  fileName = DEFAULT_FILE_NAME,
}) async {
  return _retrieveInputFile(year, day, fileName).readAsStringSync();
}

Future<void> actionOnInputLines(
  int year,
  int day,
  Function(String line) lineAction,
  Function() completeAction, {
  fileName = DEFAULT_FILE_NAME,
}) async {
  _retrieveInputFile(year, day, fileName)
      .openRead()
      .transform(utf8.decoder)
      .transform(new LineSplitter())
      .forEach(lineAction)
      .whenComplete(completeAction);
}

Future<List<String>> readInputLines(
  int year,
  int day, {
  fileName = DEFAULT_FILE_NAME,
}) async {
  return _retrieveInputFile(year, day, fileName).readAsLines();
}

File _retrieveInputFile(int year, int day, fileName) {
  String filePath = normalize(join(
    dirname(Platform.script.toString()),
    '../../',
    year.toString(),
    "Day$day",
    fileName,
  ));

  return File(filePath.substring(5));
}
