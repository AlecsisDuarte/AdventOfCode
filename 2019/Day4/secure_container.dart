const int FROM = 387638;
const int TO = 919123;

main() {
  bruteTotalPass();
}

void bruteTotalPass() {
  int totalPass = 0, totalPassTwo = 0;

  for (int pass = FROM; pass <= TO; pass++) {
    if (validPass(pass)) {
      totalPass++;
    }
    if (validPassPartTwo(pass)) {
      totalPassTwo++;
    }
  }
  print("Part 1 - Total Pass $totalPass");
  print("Part 2 - Total Pass $totalPassTwo");
}

bool validPass(int pass) {
  bool hasRepeated = false;

  int prev = pass % 10;
  pass ~/= 10;

  while (pass > 0) {
    int curr = pass % 10;
    pass ~/= 10;

    if (curr > prev) {
      return false;
    } else if (curr == prev) {
      hasRepeated = true;
    }
    prev = curr;
  }

  return hasRepeated;
}

bool validPassPartTwo(int pass) {
  List<int> reps = List.filled(10, 0, growable: false);

  int prev = pass % 10;
  reps[prev]++;
  pass ~/= 10;

  while (pass > 0) {
    int curr = pass % 10;
    pass ~/= 10;

    if (curr > prev) {
      return false;
    }
    reps[curr]++;
    prev = curr;
  }

  return checkIfHasAPair(reps);
}

bool checkIfHasAPair(List<int> reps) {
  return reps.firstWhere((r) => r == 2, orElse: () => -1) >= 0;
}
