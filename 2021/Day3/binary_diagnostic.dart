import '../../utils/dart_utils.dart';

void main(List<String> args) {
  solvePartOne();
  solvePartTwo();
}

void solvePartOne() {
  List<int> oneDigits = null;

  actionOnInputLines(2021, 3, (line) {
    if (oneDigits == null) {
      oneDigits = List.filled(line.length, 0);
    }

    for (int index = 0; index < line.length; index++) {
      oneDigits[index] += line[index] == '0' ? -1 : 1;
    }
  }, () {
    int gammaRate = 0;
    int epsilonRate = 0;

    int val = 1;
    for (int index = oneDigits.length - 1; index >= 0; index--) {
      if (oneDigits[index] >= 0) {
        gammaRate += val;
      } else {
        epsilonRate += val;
      }
      val *= 2;
    }

    print(
        'Part 1: Power consumption of submarine = ${gammaRate * epsilonRate}');
  });
}

void solvePartTwo() async {
  List<String> input = await readInputLines(2021, 3);
  String oxygenGeneratorRate = calculateRating(input, 0, true);
  String scrubberGeneratorRate = calculateRating(input, 0, false);

  int oxygenRate = 0;
  int scrubberRate = 0;

  int val = 1;
  for (int index = oxygenGeneratorRate.length - 1; index >= 0; index--) {
    if (oxygenGeneratorRate[index] == '1') {
      oxygenRate += val;
    }
    if (scrubberGeneratorRate[index] == '1') {
      scrubberRate += val;
    }
    val *= 2;
  }

  print('Part 2: Life support rating = ${oxygenRate * scrubberRate}');
}

String calculateRating(
    List<String> reports, int index, bool isOxygenGenerator) {
  int oneDigits = 0;
  Map<int, List<String>> binaryMap = {0: [], 1: []};
  for (String report in reports) {
    if (report[index] == '0') {
      oneDigits -= 1;
      binaryMap[0].add(report);
    } else {
      oneDigits += 1;
      binaryMap[1].add(report);
    }
  }

  int digit = oneDigits >= 0 ? 1 : 0;
  if (!isOxygenGenerator) {
    digit = digit == 1 ? 0 : 1;
  }

  if (binaryMap[digit].length == 1) {
    return binaryMap[digit].first;
  }
  List<String> children = binaryMap[digit];
  binaryMap = null;
  return calculateRating(children, index + 1, isOxygenGenerator);
}
