import '../../utils/dart_utils.dart';

const maxRows = 128;
const maxColumns = 8;

void main(List<String> args) async {
  String input = await readInput(2020, 5);
  solvePartOneAndTwo(input);
}

void solvePartOneAndTwo(String input) {
  List<String> boardingPasses = input.replaceAll("R", "A").split("\n");
  boardingPasses.sort();
  print("Part 1: Highest seat ID = " +
      getHighestSeatID(boardingPasses).toString());
  print("Part 2: Your seat ID = " + findYourSeat(boardingPasses).toString());
}

int getHighestSeatID(List<String> sortedBoardingPasses) {
  return getSeatID(sortedBoardingPasses.first);
}

int findYourSeat(List<String> sortedBoardingPasses) {
  int prevSeatId = getSeatID(sortedBoardingPasses.first);
  for (int index = 1; index < sortedBoardingPasses.length; index++) {
    int currSeatId = getSeatID(sortedBoardingPasses[index]);
    if (prevSeatId - 2 == currSeatId) {
      return prevSeatId - 1;
    }
    prevSeatId = currSeatId;
  }
  return null;
}

int getSeatID(String boardingPass) {
  String rowPartitions = boardingPass.substring(0, 7);
  String columnPartitions = boardingPass.substring(7, boardingPass.length);
  int row = remainingRowOrColumn(maxRows, rowPartitions);
  int column = remainingRowOrColumn(maxColumns, columnPartitions);
  return (row * 8) + column;
}

int remainingRowOrColumn(int max, String partitions) {
  int low = 0;
  int high = max - 1;
  int remaining = 0;
  for (int index = 0; index < partitions.length; index++) {
    String partition = partitions[index];
    double result = ((low + high) / 2);
    switch (partition) {
      case "F":
      case "L":
        high = result.floor();
        remaining = high;
        break;
      case "B":
      case "A":
      case "R":
        low = result.ceil();
        remaining = low;
        break;
    }
  }
  return remaining;
}
