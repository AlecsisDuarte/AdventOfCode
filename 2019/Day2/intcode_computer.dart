import '../../utils/dart_utils.dart' show readInput;

abstract class IntcodeComputer {
  final int DESIRED_OUTPUT = 19690720;
  final int DEFAULT_OPCODE_JUMP = 4;

  Future<List<int>> readIntcodes({year = 2019, day = 2}) async {
    String input = await readInput(year, day);
    return _getIntcodes(input);
  }
  

  void opcodeOne(Index index, List<int> intcodes) => DEFAULT_OPCODE_JUMP;

  void opcodeTwo(Index index, List<int> intcodes) => DEFAULT_OPCODE_JUMP;

  void opcodeThree(Index index, List<int> intcodes) => DEFAULT_OPCODE_JUMP;

  void opcodeFour(Index index, List<int> intcodes) => DEFAULT_OPCODE_JUMP;
  void opcodeFive(Index index, List<int> intcodes) => DEFAULT_OPCODE_JUMP;
  void opcodeSix(Index index, List<int> intcodes) => DEFAULT_OPCODE_JUMP;
  void opcodeSeven(Index index, List<int> intcodes) => DEFAULT_OPCODE_JUMP;
  void opcodeEight(Index index, List<int> intcodes) => DEFAULT_OPCODE_JUMP;

  void opcodeImmediateMode(Index index, List<int> intcodes) => DEFAULT_OPCODE_JUMP;

  void solvePartOne(List<int> intcodes) {
    List<int> tmp = copy(intcodes);
    changeNounAndVerbPart(tmp);
    workWithIntcodes(tmp);
    print("Part 1 - Result is ${tmp[0]}");
  }

  void solvePartTwo(List<int> intcodes) {
    List<int> tmp = [0];

    int noun = -1, verb = 99;

    do {
      if (tmp[0] < DESIRED_OUTPUT) {
        noun++;
      } else {
        verb--;
      }
      tmp = copy(intcodes);
      changeNounAndVerbPart(tmp, noun: noun, verb: verb);
      workWithIntcodes(tmp);
    } while (tmp[0] != DESIRED_OUTPUT);

    print("Part 2 - 100 * [Noun $noun] + [verb $verb] = ${100 * noun + verb}");
  }

  List<int> _getIntcodes(String input) =>
      input.split(",").map((intcode) => int.parse(intcode)).toList();

  List<int> copy(List<int> list) => List.from(list, growable: false);

  void changeNounAndVerbPart(List<int> intcodes, {noun = 12, verb = 2}) {
    intcodes[1] = noun;
    intcodes[2] = verb;
  }

  void workWithIntcodes(List<int> intcodes) {
    Index index = Index();
    for (; index.getIndex < intcodes.length;) {
      int opcode = intcodes[index.getIndex];
      switch (opcode) {
        case 1:
          opcodeOne(index, intcodes);
          break;
        case 2:
          opcodeTwo(index, intcodes);
          break;
        case 3:
          opcodeThree(index, intcodes);
          break;
        case 4:
          opcodeFour(index, intcodes);
          break;
        case 5:
          opcodeFive(index, intcodes);
          break;
        case 6:
          opcodeSix(index, intcodes);
          break;
        case 7:
          opcodeSeven(index, intcodes);
          break;
        case 8:
          opcodeEight(index, intcodes);
          break;
        case 99:
          return;
        default:
        opcodeImmediateMode(index, intcodes);
          break;
      }
    }
  }
}


class Index {
  int index;

  Index({this.index = 0});
  
  void set setIndex(int index) => this.index = index;
  void set incrementIndex(int increment) => this.index += increment;

  int get getIndex => index;
}