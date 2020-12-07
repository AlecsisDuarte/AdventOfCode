import 'dart:collection';

import '../../utils/dart_utils.dart';

Map<String, Queue<String>> bagsContainingSelf;
Map<String, Map<String, int>> containedBags;

RegExp bagsRegex = new RegExp(r"(?<quantity>\d*)\ *(?<color>\w+\ \w+) bag");

const String startPointBag = "shiny gold";
const String quantityGroupName = "quantity";
const String colorGroupName = "color";
const String noContentKeyword = "no other";

void main(List<String> args) async {
  String input = await readInput(2020, 7);
  createMapping(input);
  print("Part 1: Bags colors containing at least one shiny gold bag = " +
      countBagsContainingSearchedBag().toString());
  print("Part 2: Individuals bags required inside shiny gold bag = " +
      countContainingBagsInSearchedBag().toString());
}

void createMapping(String input) {
  bagsContainingSelf = new Map();
  containedBags = new Map();

  for (String rule in input.split("\n")) {
    List<RegExpMatch> matches =
        bagsRegex.allMatches(rule).toList(growable: false);
    String parentColor = matches[0].namedGroup(colorGroupName);
    containedBags[parentColor] = new Map();
    for (int index = 1; index < matches.length; index++) {
      String color = matches[index].namedGroup(colorGroupName);
      if (color == noContentKeyword) break;
      int quantity = int.parse(matches[index].namedGroup(quantityGroupName));
      containedBags[parentColor][color] = quantity;
      if (bagsContainingSelf.containsKey(color)) {
        bagsContainingSelf[color].add(parentColor);
      } else {
        bagsContainingSelf[color] = Queue.from([parentColor]);
      }
    }
  }
}

int countBagsContainingSearchedBag() {
  Queue<String> containingBags = bagsContainingSelf[startPointBag];
  Set<String> processedBags = new Set();
  int count = 0;
  do {
    String bag = containingBags.removeFirst();
    if (bagsContainingSelf.containsKey(bag)) {
      containingBags.addAll(bagsContainingSelf[bag]);
    }
    if (!processedBags.contains(bag)) {
      count++;
    }
    processedBags.add(bag);
  } while (containingBags.isNotEmpty);
  return count;
}

int countContainingBagsInSearchedBag() {
  return countContainingBags(containedBags[startPointBag]) - 1;
}

int countContainingBags(Map<String, int> insideBags) {
  int total = 1;
  for (MapEntry<String, int> bag in insideBags.entries) {
    total += bag.value * countContainingBags(containedBags[bag.key]);
  }
  return total;
}
