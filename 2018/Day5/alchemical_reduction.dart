import 'dart:collection';
import 'dart:io';
import 'dart:core';

import '../utils/input_reader.dart';

void main() async {
  final File inputFile = InputReader.openInputFile('Day5', 'input.txt');

  if (!await inputFile.exists()) {
    print('Input file not found');
    return;
  }

  inputFile.readAsLines().then((polymers) => polymers.forEach((polymer) {
        fullyReactedPolymer(polymer).then(
            (units) => print('Resulting Units: $units'));
        lengthOfShortesPolymer(polymer)
          .then((units) => print('Shortest Unit: $units'));
      }));
}

Future<int> fullyReactedPolymer(String polymer) async {
  Queue units = Queue<int>();

  polymer.split('').forEach((unit_char) {
    int unit = unit_char.codeUnitAt(0);
    if (units.length > 0 && canReact(unit, units.last)) {
      units.removeLast();
    } else {
      units.add(unit);
    }
  });

  bool reaction = false;
  do {
    for (int index = units.length - 1; index > 0; index--) {
      int unit = units.removeLast();
      int prevUnit = units.removeLast();
      if (canReact(unit, prevUnit)) {
        --index;
        reaction = true;
      } else {
        units.add(prevUnit);
        units.add(unit);
      }
    }
  } while(reaction);

  return units.length;
}

/** Starts all posible polymer iterations and waits until it finish and grabs the shortest */
Future<int> lengthOfShortesPolymer(String polymer) async {
  List<Future<int>> futureReacts = List<Future<int>>();
  for (int charCode = 65; charCode < 91; charCode++) {
    String upperChar = String.fromCharCode(charCode);
    String lowerChar = String.fromCharCode(charCode + 32);

    final RegExp letterRegex = getRegex(upperChar, lowerChar);

    String strippedPolymer = polymer.replaceAll(letterRegex, '');

    futureReacts.add(fullyReactedPolymer(strippedPolymer));
  }

  var lengths = await Future.wait(futureReacts)
  .catchError(() => print('Error while getting shortest length'));

  return lengths.reduce((min, cur) => min = min < cur? min : cur);;
}

/** Validates whether both units can react with each other */
bool canReact(int left, int right) {
  return (left - right).abs() == 32;
}

/** Returns the regular expresion containing both characters */
RegExp getRegex(String upper, String lower) {
  final String pattern = "($upper|$lower)*";
  return RegExp(pattern);
}