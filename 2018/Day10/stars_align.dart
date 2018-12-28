import 'dart:convert';
import 'dart:io';
import 'dart:math';

import '../utils/input_reader.dart';

/**
 --- Day 10: The Stars Align ---
  It's no use; your navigation system simply isn't capable of providing walking directions in 
  the arctic circle, and certainly not in 1018.

  The Elves suggest an alternative. In times like these, North Pole rescue operations will 
  arrange points of light in the sky to guide missing Elves back to base. Unfortunately, the 
  message is easy to miss: the points move slowly enough that it takes hours to align them, 
  but have so much momentum that they only stay aligned for a second. If you blink at the 
  wrong time, it might be hours before another message appears.

  You can see these points of light floating in the distance, and record their position in the 
  sky and their velocity, the relative change in position per second (your puzzle input). 
  The coordinates are all given from your perspective; given enough time, those positions and 
  velocities will move the points into a cohesive message!

  Rather than wait, you decide to fast-forward the process and calculate what the points will 
  eventually spell.

  For example, suppose you note the following points:

  position=< 9,  1> velocity=< 0,  2>
  position=< 7,  0> velocity=<-1,  0>
  position=< 3, -2> velocity=<-1,  1>
  position=< 6, 10> velocity=<-2, -1>
  position=< 2, -4> velocity=< 2,  2>
  position=<-6, 10> velocity=< 2, -2>
  position=< 1,  8> velocity=< 1, -1>
  position=< 1,  7> velocity=< 1,  0>
  position=<-3, 11> velocity=< 1, -2>
  position=< 7,  6> velocity=<-1, -1>
  position=<-2,  3> velocity=< 1,  0>
  position=<-4,  3> velocity=< 2,  0>
  position=<10, -3> velocity=<-1,  1>
  position=< 5, 11> velocity=< 1, -2>
  position=< 4,  7> velocity=< 0, -1>
  position=< 8, -2> velocity=< 0,  1>
  position=<15,  0> velocity=<-2,  0>
  position=< 1,  6> velocity=< 1,  0>
  position=< 8,  9> velocity=< 0, -1>
  position=< 3,  3> velocity=<-1,  1>
  position=< 0,  5> velocity=< 0, -1>
  position=<-2,  2> velocity=< 2,  0>
  position=< 5, -2> velocity=< 1,  2>
  position=< 1,  4> velocity=< 2,  1>
  position=<-2,  7> velocity=< 2, -2>
  position=< 3,  6> velocity=<-1, -1>
  position=< 5,  0> velocity=< 1,  0>
  position=<-6,  0> velocity=< 2,  0>
  position=< 5,  9> velocity=< 1, -2>
  position=<14,  7> velocity=<-2,  0>
  position=<-3,  6> velocity=< 2, -1>
  Each line represents one point. Positions are given as <X, Y> pairs: X represents how far left 
  (negative) or right (positive) the point appears, while Y represents how far up (negative) or 
  down (positive) the point appears.

  At 0 seconds, each point has the position given. Each second, each point's velocity is added to 
  its position. So, a point with velocity <1, -2> is moving to the right, but is moving upward 
  twice as quickly. If this point's initial position were <3, 9>, after 3 seconds, its position 
  would become <6, 3>.

  Over time, the points listed above would move like this:

  Initially:
  ........#.............
  ................#.....
  .........#.#..#.......
  ......................
  #..........#.#.......#
  ...............#......
  ....#.................
  ..#.#....#............
  .......#..............
  ......#...............
  ...#...#.#...#........
  ....#..#..#.........#.
  .......#..............
  ...........#..#.......
  #...........#.........
  ...#.......#..........

  After 1 second:
  ......................
  ......................
  ..........#....#......
  ........#.....#.......
  ..#.........#......#..
  ......................
  ......#...............
  ....##.........#......
  ......#.#.............
  .....##.##..#.........
  ........#.#...........
  ........#...#.....#...
  ..#...........#.......
  ....#.....#.#.........
  ......................
  ......................

  After 2 seconds:
  ......................
  ......................
  ......................
  ..............#.......
  ....#..#...####..#....
  ......................
  ........#....#........
  ......#.#.............
  .......#...#..........
  .......#..#..#.#......
  ....#....#.#..........
  .....#...#...##.#.....
  ........#.............
  ......................
  ......................
  ......................

  After 3 seconds:
  ......................
  ......................
  ......................
  ......................
  ......#...#..###......
  ......#...#...#.......
  ......#...#...#.......
  ......#####...#.......
  ......#...#...#.......
  ......#...#...#.......
  ......#...#...#.......
  ......#...#..###......
  ......................
  ......................
  ......................
  ......................

  After 4 seconds:
  ......................
  ......................
  ......................
  ............#.........
  ........##...#.#......
  ......#.....#..#......
  .....#..##.##.#.......
  .......##.#....#......
  ...........#....#.....
  ..............#.......
  ....#......#...#......
  .....#.....##.........
  ...............#......
  ...............#......
  ......................
  ......................
  After 3 seconds, the message appeared briefly: HI. Of course, your message will be much 
  longer and will take many more seconds to appear.

  What message will eventually appear in the sky?


  --- Part Two ---
  Good thing you didn't have to wait, because that would have taken a long time - much longer than the 3 seconds in the example above.

  Impressed by your sub-hour communication capabilities, the Elves are curious: exactly how many seconds would they have needed to wait for that message to appear?
 */

RegExp POINT_REGEX =
    RegExp(r"<\ *(\-?\d*),\ *(\-?\d*).*<\ *(\-?\d*),\ *(\-?\d*)>");

const int MARGIN = 0;
const int STARTING_SECONDS = 10000;
const int SECONDS = 20000;

void main() async {
  File input = InputReader.openInputFile('Day10', 'input.txt');
  if (!await input.exists()) {
    print('File not found');
    return;
  }

  input.readAsLines().then((lines) async {
    List<Point> points = getCenteredPoints(lines);
    List<Future<MapEntry<int,int>>> futureSizes = List<Future<MapEntry<int,int>>>();

    for (int second = STARTING_SECONDS; second <= SECONDS; second++) {
      futureSizes.add(getAreaSize(points, second));
    }
    
    Future.wait(futureSizes).then((entries) {
      int second = entries.first.key;
      int minArea = entries.first.value;
      for (MapEntry entry in entries) {
        if (minArea > entry.value) {
          minArea = entry.value;
          second = entry.key;
        }
      }
      movePoints(points, second);
    });
  });
}

class Position {
  int x;
  int y;
  Position(this.x, this.y);
}

class Point {
  Position position;
  Position velocity;
  Point(this.position, this.velocity);
}

/** Returns the points at current state */
List<Point> getCenteredPoints(List<String> lines) {
  int minX = 0, minY = 0;
  final List<Point> points = lines.map<Point>((line) {
    final Match match = POINT_REGEX.firstMatch(line);
    final int x = int.parse(match.group(1));
    final int y = int.parse(match.group(2));
    final int vx = int.parse(match.group(3));
    final int vy = int.parse(match.group(4));

    if (x < minX) minX = x;
    if (y < minY) minY = y;

    return Point(Position(x, y), Position(vx, vy));
  }).toList();

  int pushX = minX.abs() + MARGIN;
  int pushY = minY.abs() + MARGIN;

  for (Point p in points) {
    p.position.x += pushX;
    p.position.y += pushY;
  }
  return points;
}

/** Gets the positions of the points after the specified seconds */
void movePoints(final List<Point> originalPoints, final int seconds) async {
  int maxX = 0, maxY = 0, minX = originalPoints[0].position.x;
  for (Point p in originalPoints) {
    if (p.position.x > maxX) maxX = p.position.x;
    if (p.position.y > maxY) maxY = p.position.y;
  }
  List<List<int>> positions = List.generate(maxY + 1, (_) => List<int>());

  for (Point p in originalPoints) {
    int x = p.position.x + (p.velocity.x * seconds);
    int y = p.position.y + (p.velocity.y * seconds);
    while (x > maxX) x -= maxX;
    while (y > maxY) y -= maxY;
    while (x < 0) x += maxX;
    while (y < 0) y += maxY;

    if (x < minX) minX = x;

    positions[y].add(x);
  }

  positions.removeWhere((p) => p.length == 0);
  for (int index = 0; index < positions.length; index++) {
    positions[index] = positions[index].map((p) => p -= minX).toList();
  }
  maxX -= minX * 2;

  await printPositions(positions, maxX + 1, seconds: seconds);
}

/** Returns the area created by the area of the points */
Future<MapEntry<int,int>> getAreaSize(
    final List<Point> originalPoints, final int seconds) async {
  int maxX = 0, maxY = 0, minX = originalPoints[0].position.x;
  for (Point p in originalPoints) {
    if (p.position.x > maxX) maxX = p.position.x;
    if (p.position.y > maxY) maxY = p.position.y;
  }
  List<List<int>> positions = List.generate(maxY + 1, (_) => List<int>());

  for (Point p in originalPoints) {
    int x = p.position.x + (p.velocity.x * seconds);
    int y = p.position.y + (p.velocity.y * seconds);
    while (x > maxX) x -= maxX;
    while (y > maxY) y -= maxY;
    while (x < 0) x += maxX;
    while (y < 0) y += maxY;

    if (x < minX) minX = x;

    positions[y].add(x);
  }

  positions.removeWhere((p) => p.length == 0);
  for (int index = 0; index < positions.length; index++) {
    positions[index] = positions[index].map((p) => p -= minX).toList();
  }
  return MapEntry<int,int>(seconds, positions.length * (maxX - minX));
}

/** Shows the points in a 2d array */
void printPositions(final List<List<int>> positions, final int maxX,
    {final int seconds = null}) async {
  if (seconds != null) {
    print('At $seconds second(s): ');
  }
  List<String> line = List.filled(maxX, '.');
  for (int y = 0; y < positions.length; y++) {
    if (positions[y].length > 0) {
      line.fillRange(0, maxX, '.');
      for (int x in positions[y]) {
        line[x] = '#';
      }
      print(line.join());
    }
  }
}
