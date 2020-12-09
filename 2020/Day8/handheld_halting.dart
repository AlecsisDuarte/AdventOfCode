import 'dart:collection';

import '../../utils/dart_utils.dart';

enum Instruction { acc, jmp, nop }
List<CodeLine> program;
Queue<int> nopAndJmpPos;

class CodeLine {
  CodeLine(this.instruction, this.arg);
  Instruction instruction;
  int arg;
}

void main(List<String> args) async {
  String input = await readInput(2020, 8);
  program = readProgram(input);
  solveProgramOneAndTwo(program, nopAndJmpPos);
}

CodeLine parseLine(String line) {
  List<String> parts = line.split(" ");
  Instruction instruction = null;
  switch (parts[0]) {
    case "acc":
      instruction = Instruction.acc;
      break;
    case "jmp":
      instruction = Instruction.jmp;
      break;
    case "nop":
      instruction = Instruction.nop;
      break;
  }
  return CodeLine(instruction, int.parse(parts[1]));
}

List<CodeLine> readProgram(String input) {
  List<String> lines = input.split("\n");
  nopAndJmpPos = new Queue();
  program = new List(lines.length);
  for (int index = 0; index < lines.length; index++) {
    program[index] = parseLine(lines[index]);
    if (program[index].instruction == Instruction.jmp ||
        program[index].instruction == Instruction.nop) {
      nopAndJmpPos.add(index);
    }
  }
  return program;
}

void solveProgramOneAndTwo(List<CodeLine> program, Queue<int> nopAndJmpPos) {
  print("Part 1: Accumulator value with max 1 interactions = " +
      executeProgramWithOneInteraction(program).toString());
  print("Part 2: Accumulator of valid program = " +
      executeProgramWithoutDoubleInteractions(program, nopAndJmpPos)
          .toString());
}

int executeProgramWithOneInteraction(List<CodeLine> program) {
  int accumulator = 0;
  Set<int> posProcessed = new Set();
  for (int pos = 0; pos < program.length; pos++) {
    CodeLine codeLine = program[pos];
    if (posProcessed.contains(pos)) {
      break;
    }
    posProcessed.add(pos);
    switch (codeLine.instruction) {
      case Instruction.acc:
        accumulator += codeLine.arg;
        break;
      case Instruction.jmp:
        pos += codeLine.arg - 1;
        break;
      case Instruction.nop:
        break;
    }
  }
  return accumulator;
}

bool isLooplessProgram(List<CodeLine> program) {
  Set<int> posProcessed = new Set();
  for (int pos = 0; pos < program.length; pos++) {
    CodeLine codeLine = program[pos];
    if (posProcessed.contains(pos)) {
      return false;
    }
    posProcessed.add(pos);
    if (codeLine.instruction == Instruction.jmp) {
      pos += codeLine.arg - 1;
    }
  }
  return true;
}

int executeProgramWithoutDoubleInteractions(
    List<CodeLine> program, Queue<int> nopAndJmpPos) {
  do {
    int pos = nopAndJmpPos.removeLast();
    Instruction tmp = program[pos].instruction;
    if (tmp == Instruction.jmp) {
      program[pos].instruction = Instruction.nop;
    } else {
      program[pos].instruction = Instruction.jmp;
    }
    if (isLooplessProgram(program)) {
      break;
    }
    program[pos].instruction = tmp;
  } while (nopAndJmpPos.isNotEmpty);
  return executeProgramWithOneInteraction(program);
}
