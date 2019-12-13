import '../../utils/dart_utils.dart';
import 'dart:math' show ;

main() async {
  String input = await readInput(2019, 9);
}

int MAP_HEIGHT = 0;
int MAP_WIDTH = 0;

class Point {
  int x;
  int y;

  bool passed = false;
  bool inSight = true;
  bool isAsteroid = false;

  Point(int x, int y, {this.isAsteroid, this.inSight, this.passed});

  @override
  String toString() => isAsteroid ? "#" : ".";

  bool _pointIsUpFromMe(Point p) => this.y > p.y;
  bool _pointIsLeftFromMe(Point p) => this.x > p.x;

  int getYIncrement(Point p) => _pointIsUpFromMe(p) ? -1 : 1;
  int getXIncrement(Point p) => _pointIsLeftFromMe(p) ? -1 : 1;

  int getXDifference(Point p) => this.x - p.x;
  int getYDifference(Point p) => this.y - p.y;

  bool isInDiagonal(Point p) => (this.x - p.x).abs() == (this.y - p.y).abs();

  void removeFromSight() {
    if (this.isAsteroid && this.inSight) {
      this.inSight = false;
    }
  }

  Point clone() =>
      Point(this.x, this.y, isAsteroid: this.isAsteroid, inSight: this.inSight);
}

int calculateInSightAsteroids(Point base, List<List<Point>> map) {
  
}

void markOutOfSight(Point base, Point asteroid, List<List<Point>> map) {
  if (base.x == asteroid.x)
    markOutOfSightOnY(base, asteroid, map);
  else if (base.y == asteroid.y) markOutOfSightOnX(base, asteroid, map);
  else if (base.isInDiagonal(asteroid)) markOutOfSightOnDiagonally(base, asteroid, map);
  else markOutOfSightOnPattern(base, asteroid, map);
}

void markOutOfSightOnY(Point base, Point asteroid, List<List<Point>> map) {
  int inc = base.getYIncrement(asteroid);
  for (int y = asteroid.y + inc; y >= 0 && y < MAP_HEIGHT; y += inc) {
    map[y][asteroid.x].removeFromSight();
  }
}

void markOutOfSightOnX(Point base, Point asteroid, List<List<Point>> map) {
  int inc = base.getXIncrement(asteroid);
  for (int x = asteroid.x + inc; x >= 0 && x < MAP_WIDTH; x += inc) {
    map[asteroid.y][x].removeFromSight();
  }
}

void markOutOfSightOnDiagonally(
    Point base, Point asteroid, List<List<Point>> map) {
  int incY = base.getYIncrement(asteroid);
  int incX = base.getXIncrement(asteroid);

  for (int x = asteroid.x + incX, y = asteroid.y + incY;
      x >= 0 && y >= 0 && x < MAP_WIDTH && y < MAP_HEIGHT;
      x += incX, y += incY) {
    map[y][x].removeFromSight();
  }
}

void markOutOfSightOnPattern(
    Point base, Point asteroid, List<List<Point>> map) {
  int xDiff = base.getXDifference(asteroid);
  int yDiff = base.getXDifference(asteroid);

  for (int x = asteroid.x + xDiff, y = asteroid.y + yDiff;
      x >= 0 && y >= 0 && x < MAP_WIDTH && y < MAP_HEIGHT;
      x += xDiff, y += yDiff) {
    map[y][x].removeFromSight();
  }
}
