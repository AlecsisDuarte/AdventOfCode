import '../../utils/dart_utils.dart';

RegExp passwordPolicyExp =
    new RegExp(r"(?<min>\d+)\-(?<max>\d+) (?<char>\S)\: (?<input>.*)");

const minGroupName = "min";
const maxGroupName = "max";
const charGroupName = "char";
const inputGroupName = "input";

class Password {
  Password(this.input, this.policy);
  String input;
  Policy policy;

  bool correctPosition() {
    bool correct = false;
    int aIndex = policy.min - 1;
    if (input[aIndex] == policy.char) {
      correct = true;
    }

    int bIndex = policy.max - 1;
    if (input[bIndex] == policy.char) {
      return !correct;
    }
    return correct;
  }
}

class Policy {
  Policy(this.min, this.max, this.char);
  String char;
  int min;
  int max;

  bool withinLimit(int instances) {
    return min <= instances && instances <= max;
  }
}

void main(List<String> args) async {
  String input = await readInput(2020, 2);
  print("Part 1: Valid passwords = " + countValidPasswords(input).toString());
  print("Part 2: Valid possition passwords = " +
      countValidPositionPasswords(input).toString());
}

int countValidPasswords(String input) {
  int validPasswords = 0;
  for (String line in input.split("\n")) {
    Password password = parseInputLine(line);
    if (validPassword(password)) {
      validPasswords++;
    }
  }
  return validPasswords;
}

int countValidPositionPasswords(String input) {
  int validPositions = 0;
  for (String line in input.split("\n")) {
    Password password = parseInputLine(line);
    if (password.correctPosition()) {
      validPositions++;
    }
  }
  return validPositions;
}

bool validPassword(Password password) {
  Map<String, int> reps = new Map();
  password.input.split("").forEach((char) {
    reps.update(char, (value) => value + 1, ifAbsent: () => reps[char] = 1);
  });

  if (reps.containsKey(password.policy.char)) {
    int instances = reps[password.policy.char];
    return password.policy.withinLimit(instances);
  }
  return false;
}

Password parseInputLine(String inputLine) {
  RegExpMatch expMatch = passwordPolicyExp.firstMatch(inputLine);
  int min = int.parse(expMatch.namedGroup(minGroupName));
  int max = int.parse(expMatch.namedGroup(maxGroupName));
  String char = expMatch.namedGroup(charGroupName);
  String input = expMatch.namedGroup(inputGroupName);
  return Password(input, Policy(min, max, char));
}
