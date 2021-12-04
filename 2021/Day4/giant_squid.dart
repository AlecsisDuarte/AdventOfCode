import '../../utils/dart_utils.dart';

const int BOARD_SIZE = 5;
final RegExp whiteSpaceRegex = new RegExp(r"\s+");

void main(List<String> args) {
  solvePartOneAndTwo();
}

void solvePartOneAndTwo() async {
  List<String> input = await readInputLines(2021, 04);
  List<int> numbers = input[0].split(',').map((e) => int.parse(e)).toList();

  int minNumbersDrawn = numbers.length;
  int maxNumbersDrawn = 0;
  int minDrawnScore = 0;
  int maxDrawnScore = 0;

  int lineIndex = 2;
  while (lineIndex < input.length) {
    Board board = new Board();
    for (int y = 0; y < BOARD_SIZE; y++) {
      int x = 0;
      input[lineIndex++]
          .trimLeft()
          .split(whiteSpaceRegex)
          .map((e) => int.parse(e))
          .forEach((num) => board.add(num, x++, y));
    }
    lineIndex++;

    for (int index = 0; index < numbers.length; index++) {
      if (!board.mark(numbers[index])) {
        continue;
      }
      if (index < minNumbersDrawn) {
        minNumbersDrawn = index;
        minDrawnScore = numbers[index] * board.unmarkedSum;
      }

      if (index > maxNumbersDrawn) {
        maxNumbersDrawn = index;
        maxDrawnScore = numbers[index] * board.unmarkedSum;
      }
      break;
    }
  }

  print('Part 1: First board winning score = ${minDrawnScore}');
  print('Part 2: Last board winning score = ${maxDrawnScore}');
}

class Board {
  Map<int, Pos> numbers;
  List<List<bool>> marked;
  int unmarkedSum;
  int markedCount;

  Board() {
    numbers = {};
    marked = List.generate(BOARD_SIZE, (_) => List.filled(BOARD_SIZE, false));
    unmarkedSum = 0;
    markedCount = 0;
  }

  void add(int number, int x, int y) {
    numbers[number] = Pos(x, y);
    unmarkedSum += number;
  }

  bool mark(int number) {
    if (!numbers.containsKey(number)) {
      return false;
    }

    Pos pos = numbers[number];
    unmarkedSum -= number;
    marked[pos.x][pos.y] = true;
    ++markedCount;
    if (markedCount < 5) {
      return false;
    }

    return wonVertically(pos.x) || wonHorizontally(pos.y);
  }

  bool wonVertically(int x) {
    for (int y = 0; y < BOARD_SIZE; y++) {
      if (!marked[x][y]) {
        return false;
      }
    }
    return true;
  }

  bool wonHorizontally(int y) {
    for (int x = 0; x < BOARD_SIZE; x++) {
      if (!marked[x][y]) {
        return false;
      }
    }
    return true;
  }
}

class Pos {
  int x;
  int y;

  Pos(this.x, this.y);
}
