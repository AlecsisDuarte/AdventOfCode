import '../../utils/dart_utils.dart';

class Transmission {
  Transmission({this.sorted, this.pool});
  List<int> sorted;
  Map<int, int> pool;

  @override
  String toString() {
    return "{\n\tsorted: $sorted,\n\tpool: $pool\n}";
  }
}

const preambleLength = 25;

void main(List<String> args) async {
  String input = await readInput(2020, 9);
  Transmission transmission = getTransmission(input);
  solvePartOneAndTwo(transmission);
}

Transmission getTransmission(String input) {
  Transmission transmission = new Transmission(sorted: List(), pool: Map());
  int index = 0;
  input.split("\n").forEach((element) {
    int val = int.parse(element);
    transmission.pool[val] = index++;
    transmission.sorted.add(val);
  });
  return transmission;
}

void solvePartOneAndTwo(Transmission transmission) {
  int invalidNumber = firstInvalidNumber(transmission);
  print(
      "Part 1: First number that does not have the correct property = $invalidNumber");
  int encryptionWeakness = findEncryptionWeakness(invalidNumber, transmission);
  print("Part 2: Encryption weakness = $encryptionWeakness");
}

int firstInvalidNumber(Transmission transmission) {
  int index = preambleLength;
  for (; index < transmission.sorted.length; index++) {
    int value = transmission.sorted[index];
    if (!hasValidPair(value, index, transmission)) {
      return value;
    }
  }
  return null;
}

bool hasValidPair(int value, int valPos, Transmission transmission) {
  int preambleMin = valPos - preambleLength;
  int preambleMax = valPos - 1;
  for (int index = preambleMax; index >= preambleMin; index--) {
    int fPart = transmission.sorted[index];
    int remaining = value - fPart;
    if (remaining != fPart && transmission.pool.containsKey(remaining)) {
      int remainingIndex = transmission.pool[remaining];
      if (remainingIndex >= preambleMin && remainingIndex <= preambleMax) {
        return true;
      }
    }
  }
  return false;
}

int findEncryptionWeakness(int invalidNumber, Transmission transmission) {
  int minIndex = 0;
  int maxIndex = 1;
  int sum = transmission.sorted[minIndex];
  for (; maxIndex < transmission.sorted.length;) {
    while (sum > invalidNumber) {
      sum -= transmission.sorted[minIndex++];
    }
    if (sum == invalidNumber) {
      List<int> range = transmission.sorted.sublist(minIndex, maxIndex);
      range.sort();
      return range.first + range.last;
    }
    while (sum < invalidNumber) {
      sum += transmission.sorted[maxIndex++];
    }
  }
  return null;
}
