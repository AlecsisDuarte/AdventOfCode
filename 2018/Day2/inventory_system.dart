import 'dart:io';

import '../utils/input_reader.dart';

void main() async {
  File inputFile = InputReader.openInputFile('Day2', 'input.txt');
  bool fileExists = await inputFile.exists();
  if (!fileExists) {
    print('Input file not found');
    return;
  }

  inputFile.readAsLines().then((lines) {
    // getChecksum(lines).then((checksum) => print('Checksum: $checksum'));

    commonLetters(lines)
        .then((commonLetters) => print('Common Letters: $commonLetters'));
  });
}

Future<int> getChecksum(List<String> ids) async {
  List<int> repeatedAppearences = List.filled(16, 0);

  ids.forEach((id) {
    Map<int, int> appearences = appearencesInId(id);
    appearences.keys.forEach((key) {
      ++repeatedAppearences[key];
    });
  });

  int checksum = repeatedAppearences
      .where((value) => value > 1)
      .reduce((result, value) => result *= value);
  return checksum;
}

/** Gets the box ID's with common letters */
Future<String> commonLetters(List<String> ids) async {
  List<String> leftOvers = List();
  for (int index = 0; index < ids.length; index++) {
    String compareResult = null;
    String letters = ids[index];
    for (int boxIndex = 0; boxIndex < leftOvers.length; boxIndex++) {
      compareResult = comparisonResult(letters, leftOvers[boxIndex]);
      if (compareResult != null) {
        return compareResult;
      }

    }
    leftOvers.add(letters);

  }
}

/** Returns the counter of sets of repetitions */
Map<int, int> appearencesInId(String id) {
  Map<int, int> repeatedLetters = getRepeatedLetters(id);

  Map<int, int> appearences = Map();
  for (int index = 2; index <= 16; index++) {
    if (repeatedLetters.containsValue(index)) {
      appearences.putIfAbsent(index, () => 1);
    }
  }

  return appearences;
}

/** Returns common letters if the difference is of 1 character */
String comparisonResult(String reference, String subject) {
  if (reference.length != subject.length) {
    return null;
  }

  String commonLetters = "";
  int differencesCounter = 0;
  for (int index = 0; index < reference.length; index++) {
    if (reference.codeUnitAt(index) != subject.codeUnitAt(index)) {
      ++differencesCounter;
    } else {
      commonLetters += reference.substring(index, index + 1);
    }
    if (differencesCounter > 1) {
      return null;
    }
  }
  return commonLetters;
}


/** Returns all the letters and how many times they repeated */
Map<int, int> getRepeatedLetters(String id) {
  Map<int, int> repeatedLetters = Map();
  for (int index = 0; index < id.length; index++) {
    int code = id.codeUnitAt(index);
    repeatedLetters.update(code, (val) => ++val, ifAbsent: () => 1);
  }
  return repeatedLetters;
}
