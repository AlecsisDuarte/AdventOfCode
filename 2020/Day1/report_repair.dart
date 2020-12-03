import '../../utils/dart_utils.dart';

final int desiredNumber = 2020;

Map<int, int> repetitions;
List<int> numbers;

void main(List<String> args) async {
  String input = await readInput(2020, 1);
  countRepetitions(input);
  int partOneResult = multiplicationOfTwoEntriesThatResultIn2020();
  int partTwoResult = multiplicationOfThreeEntriesThatResultIn2020();
  print("Part 1: Result = " + partOneResult.toString());
  print("Part 2: Result = " + partTwoResult.toString());
}

void countRepetitions(String input) {
  List<String> nums = input.split("\n");
  repetitions = new Map();
  numbers = new List(nums.length);
  for (int index = 0; index < nums.length; index++) {
    int number = int.parse(nums[index]);
    numbers[index] = number;
    repetitions.update(number, (value) => value + 1,
        ifAbsent: () => repetitions[number] = 1);
  }
}

int multiplicationOfTwoEntriesThatResultIn2020() {
  for (MapEntry<int, int> rep in repetitions.entries) {
    int currNumber = rep.key;
    if (currNumber * 2 == desiredNumber && rep.value == 2) {
      return currNumber * currNumber;
    }
    int neededNumber = desiredNumber - currNumber;
    if (repetitions.containsKey(neededNumber)) {
      return currNumber * neededNumber;
    }
  }
  return 0;
}

int multiplicationOfThreeEntriesThatResultIn2020() {
  numbers.sort((a, b) => b.compareTo(a)); //DESC

  for (int fIndex = 0; fIndex < numbers.length - 1; fIndex++) {
    int firstNumber = numbers[fIndex];
    for (int sIndex = fIndex + 1; sIndex < numbers.length; sIndex++) {
      int secondNumber = numbers[sIndex];
      if (firstNumber + secondNumber < desiredNumber) {
        int searchedNumber = desiredNumber - (firstNumber + secondNumber);
        if (repetitions.containsKey(searchedNumber)) {
          return firstNumber * secondNumber * searchedNumber;
        }
      }
    }
  }
  return 0;
}
