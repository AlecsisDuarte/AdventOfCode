import '../../utils/dart_utils.dart';

void main(List<String> args) {
  solvePartOne();
  solvePartTwo();
}

Future<void> solvePartOne() {
  int depth = 0;
  int distance = 0;

  return actionOnInputLines(
    2021,
    2,
    (line) {
      List<String> lineParts = line.split(" ");
      String action = lineParts[0];
      int value = int.parse(lineParts[1]);

      if (action.startsWith("f")) {
        distance += value;
      } else {
        depth += action.startsWith("u") ? -value : value;
      }
    },
    () => print('Part 1: Distance * Depth = ${distance * depth}'),
  );
}

Future<void> solvePartTwo() {
  int depth = 0;
  int distance = 0;
  int aim = 0;

  return actionOnInputLines(
    2021,
    2,
    (line) {
      List<String> lineParts = line.split(" ");
      String action = lineParts[0];
      int value = int.parse(lineParts[1]);

      if (action.startsWith("f")) {
        distance += value;
        depth += value * aim;
      } else {
        aim += action.startsWith("u") ? -value : value;
      }
    },
    () => print('Part 1: Distance * Depth = ${distance * depth}'),
  );
}
