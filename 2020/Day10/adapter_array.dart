import 'dart:collection';

import '../../utils/dart_utils.dart';

void main(List<String> args) async {
  String input = await readInput(2020, 10);
  await solvePartOneAndTwo(input);
}

void solvePartOneAndTwo(String input) async {
  List<int> adapters = getAdaptersArray(input);
  int joltsMultiplicationResult =
      oneJoltAndThreeJoltDifferenceMultiplication(adapters);
  print(
      "Part 1: 1-jolt and 3-jolt differences multiplication = $joltsMultiplicationResult");
  print(
      "Total permutations = " + calculateAllPermutations(adapters).toString());
  // int totalDifferentArrays = calculateAllDifferentAdaptersArray(adapters);
  // print(
  //     "Part 2: Different adaptars array arrangements = $totalDifferentArrays");
}

List<int> getAdaptersArray(String input) {
  List<int> adapters = List.of([0]);
  for (String adapter in input.split("\n")) {
    adapters.add(int.parse(adapter));
  }
  adapters.sort();
  adapters.add(adapters.last + 3);
  return adapters;
}

int oneJoltAndThreeJoltDifferenceMultiplication(List<int> adapters) {
  Map<int, int> adaptersDifferences = getAdaptersDifferences(adapters);
  return adaptersDifferences[1] * adaptersDifferences[3];
}

Map<int, int> getAdaptersDifferences(List<int> adapters) {
  Map<int, int> adaptersDifferences = Map();
  int prevJolt = 0;
  for (int index = 1; index < adapters.length; index++) {
    int diff = adapters[index] - prevJolt;
    adaptersDifferences.update(diff, (value) => ++value, ifAbsent: () => 1);
    prevJolt = adapters[index];
  }
  return adaptersDifferences;
}

int calculateAllDifferentAdaptersArray(List<int> adapters, {int index}) {
  int total = 1;
  if (index == null) index = adapters.length - 2;
  for (; index > 0; index--) {
    int prev = adapters[index - 1];
    int next = adapters[index + 1];
    if (next - prev <= 3) {
      List<int> tmp = List.from(adapters);
      tmp.removeAt(index);
      total += calculateAllDifferentAdaptersArray(tmp, index: index - 1);
    }
  }
  return total;
  // if (futureTotals.isEmpty) {
  //   return 1;
  // }
  // List<int> totals = await Future.wait(futureTotals);
  // return totals.reduce((value, element) => value += element) + 1;
}

int calculateAllPermutations(List<int> adapters) {
  print(adapters);
  int countRemovabledAdapters = 2;
  for (int index = 1; index < adapters.length - 1; index++) {
    int prev = adapters[index - 1];
    int nextIndex = index + 1;
    int next = adapters[nextIndex];
    int count = 0;
    while (next - prev <= 3) {
      count++;
      next = adapters[++nextIndex];
    }
    print(count);
    if (count > 0) {
      countRemovabledAdapters *= count;
    }
  }
  print(countRemovabledAdapters);
  return (factorial(adapters.length) /
          factorial(adapters.length - countRemovabledAdapters))
      .ceil();
}

int factorial(int n) => n <= 1 ? 1 : n * factorial(n - 1);
