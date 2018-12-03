import 'dart:io';

class InputReader {
  static File openInputFile(String day, String fileName) {
    String path = Directory.current.path;
    if (!path.endsWith(day)) {
      path += "/2018/$day";
    }
    return File(path + "/" + fileName);
  }
}