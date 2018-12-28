import 'dart:io';

import '../utils/input_reader.dart';

RegExp numberRegex = RegExp(r'(\d+),? (\d+),? (\d+),? (\d+)');

void main() async {
  File partOne = InputReader.openInputFile('Day16', 'partOne.txt');
  partOne.readAsLines()
  .then((lines) async {
    List<Change> changes = await getChanges(lines);
    bool isBool = true;
  });
}

class Change {
  List<int> registersBefore;
  List<int> registersAfter;
  Instruction instruction;
  Change(this.registersBefore, this.instruction, this.registersAfter);
}

class Instruction {
  int opcode, a, b, c;
  Instruction(this.opcode, this.a, this.b, this.c);
}

/** Casts all the lines into the actual changes */
Future<List<Change>> getChanges(final List<String> lines) async {
  List<Future<Change>> futureChanges = List<Future<Change>>();
  for (int index = 0; index < lines.length; index += 4) {
    futureChanges.add(getChange(lines.getRange(index, index + 3).toList()));
  }
  return await Future.wait(futureChanges);
}

/** Casts the 3 lines that make a Change(Before, After and Instruction) */
Future<Change> getChange(final Iterable<String> threeLines) async {
  List<Future<List<int>>> changeLists = List<Future<List<int>>>(3);
  changeLists[0] = getNumbers(threeLines.elementAt(0));
  changeLists[1] = getNumbers(threeLines.elementAt(1));
  changeLists[2] = getNumbers(threeLines.elementAt(2));
  
  return await Future.wait(changeLists).then((lists) {
    var inst = lists[1];
    Instruction instruction = Instruction(inst[0], inst[1], inst[2], inst[3]);
    return Change(lists[0], instruction,lists[2]);
  });
}

/** Casts the numbers in the string into a list of numbers */
Future<List<int>> getNumbers(final String line) async {
  Match numbersMatch = numberRegex.firstMatch(line);
  return [
    int.parse(numbersMatch.group(1)),
    int.parse(numbersMatch.group(2)),
    int.parse(numbersMatch.group(3)),
    int.parse(numbersMatch.group(4)),
  ];
}

//OPCODES
Future<List<int>> addr(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c) {
    return null;
  }
  after[c] = a + b;
  return after;
}

Future<List<int>> addi(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c || after.length <= b) {
    return null;
  }
  after[c] = a + after[b];
  return after;
}

Future<List<int>> mulr(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c) {
    return null;
  }
  after[c] = a * b;
  return after;
}

Future<List<int>> muli(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c || after.length <= b) {
    return null;
  }
  after[c] = a * after[b];
  return after;
}

Future<List<int>> banr(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c) {
    return null;
  }
  after[c] = a & b;
  return after;
}

Future<List<int>> bani(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c || after.length <= b) {
    return null;
  }
  after[c] = a & after[b];
  return after;
}

Future<List<int>> borr(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c) {
    return null;
  }
  after[c] = a | b;
  return after;
}

Future<List<int>> bori(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c || after.length <= b) {
    return null;
  }
  after[c] = a | after[b];
  return after;
}

Future<List<int>> setr(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c) {
    return null;
  }
  after[c] = a;
  return after;
}

Future<List<int>> seti(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c || after.length <= a) {
    return null;
  }
  after[c] = a | after[a];
  return after;
}

Future<List<int>> gtir(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c || after.length <= a) {
    return null;
  }
  after[c] = after[a] > b ? 1 : 0;
  return after;
}

Future<List<int>> gtri(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c || after.length <= a) {
    return null;
  }
  after[c] = a > after[b] ? 1 : 0;
  return after;
}

Future<List<int>> gtrr(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c || after.length <= a) {
    return null;
  }
  after[c] = a > b ? 1 : 0;
  return after;
}