import 'dart:collection';

import '../../utils/dart_utils.dart';

void main(List<String> args) async {
  String input = await readInput(2020, 6);
  solvePartOneAndTwo(input);
}

void solvePartOneAndTwo(String input) {
  List<String> groups = input.split("\n\n");
  sumAllGroupsYeses(groups);
  sumAllEveryoneAnsweredYesInGroups(groups);
}

void sumAllGroupsYeses(List<String> groups) {
  int totalYeses = 0;
  groups.forEach((group) => totalYeses += countYesAnswersInGroup(group));
  print("Part 1: Sum of YES answers = " + totalYeses.toString());
}

int countYesAnswersInGroup(String group) {
  HashSet<String> yeses = new HashSet();
  group.split(new RegExp(r"(\n|)+")).forEach((yeses.add));
  return yeses.length;
}

void sumAllEveryoneAnsweredYesInGroups(List<String> groups) {
  int total = 0;
  groups.forEach((group) => total += countEveryoneAnsweredYes(group));
  print("Part 2: Sum of all YES questions per group = " + total.toString());
}

int countEveryoneAnsweredYes(String group) {
  Map<String, int> yesesPerQuestion = new Map();
  int totalPersons = group.split("\n").length;
  group.split(new RegExp(r"(\n|)+")).forEach((question) {
    yesesPerQuestion.update(question, (value) => value + 1,
        ifAbsent: () => yesesPerQuestion[question] = 1);
  });
  int allYeses = 0;
  for (MapEntry question in yesesPerQuestion.entries) {
    if (question.value == totalPersons) allYeses++;
  }
  return allYeses;
}
