import 'dart:io';
import 'dart:collection';
import 'dart:async';

import '../utils/input_reader.dart';

void main() async {
  final input = InputReader.openInputFile('Day1','input.txt');
  final exists = await input.exists();

  if (!exists) {
    print('File not found');
    return;
  }

  input.readAsLines().then((lines) {
    List<int> changes = lines.map((line) => int.parse(line)).toList();
    resultingFrequency(changes)
        .then((frequency) => print("Resulting frequency: $frequency"));
    resultingFrequencyTwice(changes)
      .then((frequency) => print("Frequency reached twice: $frequency"));
  });
}

Future<int> resultingFrequency(List<int> changes) async {
  int frequency = 0;
  changes.forEach((change) {
    frequency += change;
  });
  return frequency;
}

Future<int> resultingFrequencyTwice(List<int> changes) async {
  Map hmap = Map<int, int>();
  int frequency = 0;
  int index = 0;

  while(true) {
    frequency += changes[index++];
    if (hmap.putIfAbsent(frequency, () => index) != index) {
      return frequency;
    }
    if (index == changes.length ) {
      index = 0;
    }
  }
}
