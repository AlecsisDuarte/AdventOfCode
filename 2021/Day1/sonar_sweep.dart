import '../../utils/dart_utils.dart';

void main(List<String> args) async {
  String input = await readInput(2021, 1);
  solveFirstPart(input);
  solveSecondPart(input);
}

void solveFirstPart(String input) {
  List<int> depths = _parseInputToListOfDepths(input);

  int countIncreases = calculateDepthIncreases(depths);

  print(
      'Part 1: Measurements larger than the previous ones = ${countIncreases}');
}

void solveSecondPart(String input) {
  List<int> depths = _parseInputToListOfSumOfThreeDepths(input);

  int countIncreases = calculateDepthIncreases(depths);

  print(
      'Part 2: Measurements larger than the previous ones = ${countIncreases}');
}

int calculateDepthIncreases(List<int> depths) {
  int countIncreases = -1; //First depth doesn't count
  int prevDepth = 0;

  for (int depth in depths) {
    if (depth > prevDepth) {
      ++countIncreases;
    }
    prevDepth = depth;
  }
  return countIncreases;
}

List<int> _parseInputToListOfDepths(String input) {
  return input.split("\n").map((e) => int.parse(e)).toList();
}

List<int> _parseInputToListOfSumOfThreeDepths(String input) {
  List<int> depths = _parseInputToListOfDepths(input);

  // First three depths
  int sum = 0;
  for (int index = 0; index < 3; index++) {
    sum += depths[index];
  }
  List<int> jointDepths = [];
  for (int index = 3; index < depths.length; index++) {
    jointDepths.add(sum);
    sum += depths[index] - depths[index - 3];
  }
  jointDepths.add(sum);
  return jointDepths;
}
