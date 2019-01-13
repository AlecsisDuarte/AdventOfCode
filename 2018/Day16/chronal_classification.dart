import 'dart:io';

import '../utils/input_reader.dart';

RegExp numberRegex = RegExp(r'(\d+),? (\d+),? (\d+),? (\d+)');

void main() async {
  File partOne = InputReader.openInputFile('Day16', 'partOne.txt');
  partOne.readAsLines()
  .then((lines) async {
    List<Change> changes = await getChanges(lines);
    greaterThenThreeOpcodes(changes).then((qty) {
      print("Part 1: There were ${qty} samples that behave like three or more opcodes");
    });
    getOpcodes(changes).then((opcodes) => print("Part 2: The opcodes"));
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

Future<int> greaterThenThreeOpcodes(List<Change> changes) async {
  List<Future<int>> futurePosibles = List<Future<int>>();
  for (Change change in changes) {
    futurePosibles.add(countPosibleOpcodes(change));
  }
  return (await Future.wait(futurePosibles)).where((p) => p > 2).length;
}

Future<List<int>> getOpcodes(List<Change> changes) async {
  List<int> opcodePosition = List.filled(16, null);
  Map<int, List<int>> posibleOpcodes = Map<int, List<int>>();
  for (Change change in changes) {
    List<int> positions = await getOpcodePositions(change);
    posibleOpcodes.update(
      change.instruction.opcode, 
      (cds) {
        cds.addAll(positions);
        return cds;
      }, 
      ifAbsent: () => positions
    );
  }
  return opcodePosition;
}

Future<int> countPosibleOpcodes(Change change) async {
  List<int> before = change.registersBefore;
  List<int> after = change.registersAfter;
  Instruction instr = change.instruction;
  List<Future<List<int>>> futureRegisters = List<Future<List<int>>>();
  for (Function opcode in OPCODES) {
    futureRegisters.add(opcode(before, instr.a, instr.b, instr.c) as Future<List<int>>);
  }
  
  int count = await Future.wait(futureRegisters).then((registers) async {
    List<Future<bool>> futureResponse = List<Future<bool>>();
    for(List<int> register in registers) {
        futureResponse.add(equalLists<int>(after, register));
      // if (register != null) {
      // }
    }
    var responses = (await Future.wait(futureResponse));
    return responses.where((r) => r == true).length;
  });
  return count;
}

Future<List<int>> getOpcodePositions(Change change) async {
  List<int> before = change.registersBefore;
  List<int> after = change.registersAfter;
  Instruction instr = change.instruction;
  List<Future<List<int>>> futureRegisters = List<Future<List<int>>>();
  for (Function opcode in OPCODES) {
    futureRegisters.add(opcode(before, instr.a, instr.b, instr.c) as Future<List<int>>);
  }
  
  return await Future.wait(futureRegisters).then((registers) async {
    List<Future<bool>> futureResponse = List<Future<bool>>();
    for(List<int> register in registers) {
        futureResponse.add(equalLists<int>(after, register));
    }
    
    return (await Future.wait(futureResponse).then((responses) {
        List<int> indexes = List<int>();
        for (int index = 0; index < responses.length; index++) {
          if (responses[index]) indexes.add(index);
        }
        return indexes;
      }));
  });
}

Future<bool> equalLists<T>(Iterable<T> a, Iterable<T> b) async {
  int index = 0;
  if (a == null || b == null) return false;
  return a.every((value) => b.elementAt(index++) == value);
}

List<Function> OPCODES = [addr, addi, mulr, muli, banr, bani, borr, bori, setr, seti, gtir, gtri, gtrr, eqir, eqri, eqrr];

//OPCODES
Future<List<int>> addr(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c || after.length <= a || after.length <= b) {
    return null;
  }
  after[c] = after[a] + after[b];
  return after;
}

Future<List<int>> addi(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c || after.length <= a) {
    return null;
  }
  after[c] = after[a] + b;
  return after;
}

Future<List<int>> mulr(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c || after.length <= a || after.length <= b) {
    return null;
  }
  after[c] = after[a] * after[b];
  return after;
}

Future<List<int>> muli(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c || after.length <= a) {
    return null;
  }
  after[c] = after[a] * b;
  return after;
}

Future<List<int>> banr(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c || after.length <= a || after.length <= b) {
    return null;
  }
  after[c] = after[a] & after[b];
  return after;
}

Future<List<int>> bani(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c || after.length <= a) {
    return null;
  }
  after[c] = after[a] & b;
  return after;
}

Future<List<int>> borr(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c || after.length <= a || after.length <= b) {
    return null;
  }
  after[c] = after[a] | after[b];
  return after;
}

Future<List<int>> bori(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c || after.length <= a) {
    return null;
  }
  after[c] = after[a] | b;
  return after;
}

Future<List<int>> setr(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c || after.length <= a) {
    return null;
  }
  after[c] = after[a];
  return after;
}

Future<List<int>> seti(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c) {
    return null;
  }
  after[c] = a;
  return after;
}

Future<List<int>> gtir(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c || after.length <= b) {
    return null;
  }
  after[c] = a > after[b] ? 1 : 0;
  return after;
}

Future<List<int>> gtri(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c || after.length <= a) {
    return null;
  }
  after[c] = after[a] > b ? 1 : 0;
  return after;
}

Future<List<int>> gtrr(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c || after.length <= a || after.length <= b) {
    return null;
  }
  after[c] = after[a] > after[b] ? 1 : 0;
  return after;
}

Future<List<int>> eqir(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c || after.length <= b) {
    return null;
  }
  after[c] = a == after[b] ? 1 : 0;
  return after;
}

Future<List<int>> eqri(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c || after.length <= a) {
    return null;
  }
  after[c] = after[a] == b ? 1 : 0;
  return after;
}

Future<List<int>> eqrr(List<int> before, int a, int b, int c) async {
  List<int> after = List<int>.from(before);
  if (after.length <= c || after.length <= a || after.length <= b) {
    return null;
  }
  after[c] = after[a] == after[b] ? 1 : 0;
  return after;
}