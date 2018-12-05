/**
  --- Day 5: Alchemical Reduction ---
  You've managed to sneak in to the prototype suit manufacturing lab. The Elves are making decent progress, but are still struggling with the suit's size reduction capabilities.

  While the very latest in 1518 alchemical technology might have solved their problem eventually, you can do better. You scan the chemical composition of the suit's material and discover that it is formed by extremely long polymers (one of which is available as your puzzle input).

  The polymer is formed by smaller units which, when triggered, react with each other such that two adjacent units of the same type and opposite polarity are destroyed. Units' types are represented by letters; units' polarity is represented by capitalization. For instance, r and R are units with the same type but opposite polarity, whereas r and s are entirely different types and do not react.

  For example:

  In aA, a and A react, leaving nothing behind.
  In abBA, bB destroys itself, leaving aA. As above, this then destroys itself, leaving nothing.
  In abAB, no two adjacent units are of the same type, and so nothing happens.
  In aabAAB, even though aa and AA are of the same type, their polarities match, and so nothing happens.
  Now, consider a larger example, dabAcCaCBAcCcaDA:

  dabAcCaCBAcCcaDA  The first 'cC' is removed.
  dabAaCBAcCcaDA    This creates 'Aa', which is removed.
  dabCBAcCcaDA      Either 'cC' or 'Cc' are removed (the result is the same).
  dabCBAcaDA        No further actions can be taken.
  After all possible reactions, the resulting polymer contains 10 units.

  How many units remain after fully reacting the polymer you scanned?

  --- Part Two ---
  Time to improve the polymer.

  One of the unit types is causing problems; it's preventing the polymer from collapsing as much as it should. Your goal is to figure out which unit type is causing the most problems, remove all instances of it (regardless of polarity), fully react the remaining polymer, and measure its length.

  For example, again using the polymer dabAcCaCBAcCcaDA from above:

  Removing all A/a units produces dbcCCBcCcD. Fully reacting this polymer produces dbCBcD, which has length 6.
  Removing all B/b units produces daAcCaCAcCcaDA. Fully reacting this polymer produces daCAcaDA, which has length 8.
  Removing all C/c units produces dabAaBAaDA. Fully reacting this polymer produces daDA, which has length 4.
  Removing all D/d units produces abAcCaCBAcCcaA. Fully reacting this polymer produces abCBAc, which has length 6.
  In this example, removing all C/c units was best, producing the answer 4.

  What is the length of the shortest polymer you can produce by removing all units of exactly one type and fully reacting the result?
 */

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