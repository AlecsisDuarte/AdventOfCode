/**
 --- Day 11: Chronal Charge ---
  You watch the Elves and their sleigh fade into the distance as they head toward the North Pole.

  Actually, you're the one fading. The falling sensation returns.

  The low fuel warning light is illuminated on your wrist-mounted device. Tapping it once causes it to project a hologram of the situation: a 300x300 grid of 
  fuel cells and their current power levels, some negative. You're not sure what negative power means in the context of time travel, but it can't be good.

  Each fuel cell has a coordinate ranging from 1 to 300 in both the X (horizontal) and Y (vertical) direction. In X,Y notation, the top-left cell is 1,1, and 
  the top-right cell is 300,1.

  The interface lets you select any 3x3 square of fuel cells. To increase your chances of getting to your destination, you decide to choose the 3x3 square with 
  the largest total power.

  The power level in a given fuel cell can be found through the following process:

  Find the fuel cell's rack ID, which is its X coordinate plus 10.
  Begin with a power level of the rack ID times the Y coordinate.
  Increase the power level by the value of the grid serial number (your puzzle input).
  Set the power level to itself multiplied by the rack ID.
  Keep only the hundreds digit of the power level (so 12345 becomes 3; numbers with no hundreds digit become 0).
  Subtract 5 from the power level.
  For example, to find the power level of the fuel cell at 3,5 in a grid with serial number 8:

  The rack ID is 3 + 10 = 13.
  The power level starts at 13 * 5 = 65.
  Adding the serial number produces 65 + 8 = 73.
  Multiplying by the rack ID produces 73 * 13 = 949.
  The hundreds digit of 949 is 9.
  Subtracting 5 produces 9 - 5 = 4.
  So, the power level of this fuel cell is 4.

  Here are some more example power levels:

  Fuel cell at  122,79, grid serial number 57: power level -5.
  Fuel cell at 217,196, grid serial number 39: power level  0.
  Fuel cell at 101,153, grid serial number 71: power level  4.
  Your goal is to find the 3x3 square which has the largest total power. The square must be entirely within the 300x300 grid. Identify this square using the X,Y 
  coordinate of its top-left fuel cell. For example:

  For grid serial number 18, the largest total 3x3 square has a top-left corner of 33,45 (with a total power of 29); these fuel cells appear in the middle of 
  this 5x5 region:

  -2  -4   4   4   4
  -4   4   4   4  -5
  4   3   3   4  -4
  1   1   2   4  -3
  -1   0   2  -5  -2
  For grid serial number 42, the largest 3x3 square's top-left is 21,61 (with a total power of 30); they are in the middle of this region:

  -3   4   2   2   2
  -4   4   3   3   4
  -5   3   3   4  -4
  4   3   3   4  -3
  3   3   3  -5  -1
  What is the X,Y coordinate of the top-left fuel cell of the 3x3 square with the largest total power?

  --- Part Two ---
  You discover a dial on the side of the device; it seems to let you select a square of any size, not just 3x3. Sizes from 1x1 to 300x300 are supported.

  Realizing this, you now must find the square of any size with the largest total power. Identify this square by including its size as a third parameter after the top-left coordinate: a 9x9 square with a top-left corner of 3,5 is identified as 3,5,9.

  For example:

  For grid serial number 18, the largest total square (with a total power of 113) is 16x16 and has a top-left corner of 90,269, so its identifier is 90,269,16.
  For grid serial number 42, the largest total square (with a total power of 119) is 12x12 and has a top-left corner of 232,251, so its identifier is 232,251,12.
  What is the X,Y,size identifier of the square with the largest total power?
 */
const int SERIAL_NUMBER = 5535;

void main() async {
  var grid = createGrid();
  grid = powerLevelCells(grid, SERIAL_NUMBER);
  var summedGrid = getSummedPowerLevelCells(grid, SERIAL_NUMBER);
  getMaxTotalPowerTopLeftCoordinate(grid).then((entry) => print(
      'Part 1: The coordinates ${entry.key.x + 1}x${entry.key.y + 1} has a total power of ${entry.value} with a side of ${entry.key.side}'));
  
  getMaxPowerInSquare(summedGrid).then((entry) => print(
      'Part 2: The square at ${entry.key.x},${entry.key.y} with a size of ${entry.key.side} have an power level of ${entry.value}'));
}

List<List<int>> createGrid() {
  return List.generate(300, (_) => List.filled(300, 0));
}

List<List<int>> powerLevelCells(List<List<int>> grid, final int serialNumber) {
  final int maxY = grid.length;
  final int maxX = grid.first.length;
  for (int y = 0; y < maxY; y++) {
    for (int x = 0; x < maxX; x++) {
      final int rackId = x + 11; //10 plus the position
      int powerLevel = rackId * (y + 1);
      powerLevel += serialNumber;
      powerLevel *= rackId;
      grid[y][x] = (powerLevel / 100).truncate() % 10;
    }
  }
  return grid;
}

List<List<int>> getSummedPowerLevelCells(
    List<List<int>> originalGrid, final int serialNumber) {
  List<List<int>> grid =
      List.from(originalGrid.map<List<int>>((l) => List.from(l)));
  final int maxY = grid.length;
  final int maxX = grid.first.length;
  for (int y = 0; y < maxY; y++) {
    for (int x = 0; x < maxX; x++) {
      final int rackId = x + 11; //10 plus the position
      int powerLevel = rackId * (y + 1);
      powerLevel += serialNumber;
      powerLevel *= rackId;
      grid[y][x] = ((powerLevel / 100).truncate() % 10) - 5;
      if (y - 1 >= 0) grid[y][x] += grid[y - 1][x];
      if (x - 1 >= 0) grid[y][x] += grid[y][x - 1];
      if (x - 1 >= 0 && y - 1 >= 0) grid[y][x] -= grid[y - 1][x - 1];
    }
  }
  return grid;
}

Future<MapEntry<Point, int>> getSquareTotalPower(
    List<List<int>> grid, Point point) async {
  final int toX = point.x + point.side;
  final int toY = point.y + point.side;
  int totalPower = 0;

  for (int tmpY = point.y; tmpY < toY; tmpY++) {
    for (int tmpX = point.x; tmpX < toX; tmpX++) {
      totalPower += grid[tmpY][tmpX];
    }
  }

  return MapEntry(point, totalPower);
}

Future<MapEntry<Point, int>> getMaxTotalPowerTopLeftCoordinate(
    List<List<int>> grid) async {
  List<Future<MapEntry<Point, int>>> futureTotalPowers =
      List<Future<MapEntry<Point, int>>>();
  final int maxY = grid.length - 3;
  final int maxX = grid.first.length - 3;

  for (int y = 0; y < maxY; y++) {
    for (int x = 0; x < maxX; x++) {
      var p = Point(x, y, side: 3);
      futureTotalPowers.add(getSquareTotalPower(grid, p));
    }
  }
  return await Future.wait(futureTotalPowers).then((totalPowers) {
    int maxPower = 0;
    Point p = totalPowers.first.key;
    for (MapEntry<Point, int> entry in totalPowers) {
      if (entry.value > maxPower) {
        maxPower = entry.value;
        p = entry.key;
      }
    }
    return MapEntry<Point, int>(p, maxPower);
  });
}

Future<MapEntry<Point, int>> getMaxPowerInSquare(List<List<int>> grid) async {
  int maxLength = grid.length;
  Point p = null;
  int maxArea = 0;

  for (int s = 1; s < maxLength; s++) {
    for (int y = s; y < maxLength; y++) {
      for (int x = s; x < maxLength; x++) {
        int total =
            grid[y][x] + grid[y - s][x - s] - grid[y - s][x] - grid[y][x - s];
        if (total > maxArea) {
          maxArea = total;
          //We remove the length to get upperleft position
          //and add 2 because we should've start from 1,1 instead of 0,0 and
          //a size 2 would mean to start from just one cell back
          p = Point(x + 2 - s, y + 2 - s, side: s);
        }
      }
    }
  }

  return MapEntry(p, maxArea);
}

class Point {
  int x, y;
  int side;
  Point(this.x, this.y, {this.side = 3});
}
