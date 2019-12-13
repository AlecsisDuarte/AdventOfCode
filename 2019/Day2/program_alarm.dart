import 'intcode_computer.dart' show IntcodeComputer, Index;

const int DESIRED_OUTPUT = 19690720;

main() async {
  ComputerDay2 computer = ComputerDay2();
  List<int> intcodes = await computer.readIntcodes();

  computer.solvePartOne(intcodes);
  computer.solvePartTwo(intcodes);
}

workWithOpcodeOneAndTwo(Index index, List<int> intcodes,
    {opcode = null, fParamMode = 0, sParamMode = 0, tParamMode = 0}) {
  if (opcode == null) {
    opcode = intcodes[index.getIndex];
  }

  int left = intcodes[index.getIndex + 1];
  if (fParamMode == 0) {
    left = intcodes[left];
  }

  int right = intcodes[index.getIndex + 2];
  if (sParamMode == 0) {
    right = intcodes[right];
  }

  int res = 0;
  if (opcode == 1) {
    res = left + right;
  } else if (opcode == 2) {
    res = left * right;
  }

  int position = index.getIndex + 3;
  if (tParamMode == 0) {
    intcodes[intcodes[position]] = res;
  } else {
    intcodes[position] = res;
  }

  index.incrementIndex = 4;
}

class ComputerDay2 extends IntcodeComputer {
  @override
  opcodeOne(Index index, List<int> intcodes) =>
      workWithOpcodeOneAndTwo(index, intcodes);
  @override
  opcodeTwo(Index index, List<int> intcodes) =>
      workWithOpcodeOneAndTwo(index, intcodes);
}
