import '../Day2/program_alarm.dart' show ComputerDay2, workWithOpcodeOneAndTwo;
import '../Day2/intcode_computer.dart';
import 'dart:io';

main() async {
  ComputerDay3 computer = ComputerDay3();
  List<int> intcodes = await computer.readIntcodes(day: 5);
  computer.workWithIntcodes(intcodes);
}

class ComputerDay3 extends ComputerDay2 {
  @override
  opcodeThree(Index index, List<int> intcodes) {
    int position = intcodes[index.getIndex + 1];
    int input = int.parse(stdin.readLineSync());
    intcodes[position] = input;
    index.incrementIndex = 2;
  }

  @override
  opcodeFour(Index index, List<int> intcodes, {paramMode = 0}) {
    int position = intcodes[index.getIndex + 1];
    print("Opcode 4: ${paramMode == 0 ? intcodes[position] : position}");
    index.incrementIndex = 2;
  }

  @override
  opcodeFive(Index index, List<int> intcodes,
      {fParamMode = 0, sParamMode = 0}) {
    int fParam = intcodes[index.getIndex + 1];
    if (fParamMode == 0) {
      fParam = intcodes[fParam];
    }

    if (fParam != 0) {
      index.setIndex = intcodes[index.getIndex + 2];
      if (sParamMode == 0) {
        index.setIndex = intcodes[index.getIndex];
      }
      return;
    }

    index.incrementIndex = 3;
  }

  @override
  void opcodeSix(Index index, List<int> intcodes,
      {fParamMode = 0, sParamMode = 0}) {
    int fParam = intcodes[index.getIndex + 1];
    if (fParamMode == 0) {
      fParam = intcodes[fParam];
    }

    if (fParam == 0) {
      index.setIndex = intcodes[index.getIndex + 2];
      if (sParamMode == 0) {
        index.setIndex = intcodes[index.getIndex];
      }
      return;
    }

    index.incrementIndex = 3;
  }

  @override
  void opcodeSeven(Index index, List<int> intcodes,
      {fParamMode = 0, sParamMode = 0, tParamMode = 0}) {
    int fParam = intcodes[index.getIndex + 1];
    if (fParamMode == 0) {
      fParam = intcodes[fParam];
    }

    int sParam = intcodes[index.getIndex + 2];
    if (sParamMode == 0) {
      sParam = intcodes[sParam];
    }

    int val = fParam < sParam ? 1 : 0;
    int tParam = intcodes[index.getIndex + 3];
    if (tParamMode == 0) {
      intcodes[tParam] = val;
    } else {
      intcodes[index.getIndex + 3] = val;
    }
    index.incrementIndex = 4;
  }

  @override
  void opcodeEight(Index index, List<int> intcodes,
      {fParamMode = 0, sParamMode = 0, tParamMode = 0}) {
    int fParam = intcodes[index.getIndex + 1];
    if (fParamMode == 0) {
      fParam = intcodes[fParam];
    }

    int sParam = intcodes[index.getIndex + 2];
    if (sParamMode == 0) {
      sParam = intcodes[sParam];
    }

    int val = fParam == sParam ? 1 : 0;
    int tParam = intcodes[index.getIndex + 3];
    if (tParamMode == 0) {
      intcodes[tParam] = val;
    } else {
      intcodes[index.getIndex + 3] = val;
    }
    index.incrementIndex = 4;
  }

  @override
  opcodeImmediateMode(Index index, List<int> intcodes) {
    int abcde = intcodes[index.getIndex];
    int opcode = abcde % 100;

    abcde ~/= 100;
    int fParamMode = abcde % 10;

    abcde ~/= 10;
    int sParamMode = abcde % 10;

    abcde ~/= 10;
    int tParamMode = abcde % 100;

    switch (opcode) {
      case 1:
      case 2:
        workWithOpcodeOneAndTwo(
          index,
          intcodes,
          opcode: opcode,
          fParamMode: fParamMode,
          sParamMode: sParamMode,
          tParamMode: tParamMode,
        );
        break;
      case 3:
        opcodeThree(index, intcodes);
        break;
      case 4:
        opcodeFour(index, intcodes, paramMode: fParamMode);
        break;
      case 5:
        opcodeFive(index, intcodes,
            fParamMode: fParamMode, sParamMode: sParamMode);
        break;
      case 6:
        opcodeSix(index, intcodes,
            fParamMode: fParamMode, sParamMode: sParamMode);
        break;
      case 7:
        opcodeSeven(index, intcodes,
            fParamMode: fParamMode,
            sParamMode: sParamMode,
            tParamMode: tParamMode);
        break;
      case 8:
        opcodeEight(index, intcodes,
            fParamMode: fParamMode,
            sParamMode: sParamMode,
            tParamMode: tParamMode);
    }
  }
}
