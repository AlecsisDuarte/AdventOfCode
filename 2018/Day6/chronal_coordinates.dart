import 'dart:collection';
import 'dart:io';
import 'dart:math';

import '../utils/input_reader.dart';

final int GRID_OVERFLOW = 10;
final int MAX_DISTANCE = 10000;

void main() async {
  File input = InputReader.openInputFile('Day6', 'input.txt');
  if (!await input.exists()) {
    print('Input file not found');
    return;
  }

  input.readAsLines().then((lines) {
    final List<Point> points = getPoints(lines);
    
    final List<List<String>> mainGrid = getGrid(points);
    drawAreas(points, mainGrid).then((newGrid) {
      getLargestArea(mainGrid).then((max) {
        print('Max Area: $max');
        // printGrid(newGrid);
      });
    });

    final List<List<String>> secondGrid = getGrid(points);
    drawWithinMaxDistance(points, secondGrid).then((newGrid) {
      getCenterRegion(newGrid).then((area) => print('Area whithin max distance: $area'));
      // printGrid(newGrid);
    });
  });
}

/** Stores the coordinates information */
class Point {
  int x;
  int y;
  String letter;
  Point(this.x, this.y, {this.letter = null});
}

/** Stores which point is nearest to the origin*/
class ClosestPoint {
  Point origin;
  Point closest;
  bool nearEdge;
  ClosestPoint(this.origin, this.closest);
}

/** Stores the sum of distances using as reference to the points */
class Distance {
  Point origin;
  int distanceSum;
  Distance(this.origin, this.distanceSum);
}

/** Stores the area the point has and whether is finite or not */
class Area {
  String char;
  int area;
  bool infinite;
  Area(this.char, this.area, this.infinite);
}

/** Draws all the points areas on the grid*/
Future<List<List<String>>> drawAreas(
    List<Point> points, List<List<String>> grid) async {
  List<Future<ClosestPoint>> futureClosests = List<Future<ClosestPoint>>();
  final int xLength = grid.length;
  final int yLength = grid.first.length;

  for (int y = 0; y < yLength; y++) {
    for (int x = 0; x < xLength; x++) {
      final Point origin = Point(x, y);
      futureClosests.add(whoIsCloser(origin, points));
    }
  }

  Future.wait(futureClosests).then((closests) {
    closests.forEach((nearest) {
      if (nearest.closest != null) {
        int x = nearest.origin.x;
        int y = nearest.origin.y;
        grid[x][y] = nearest.closest.letter;
      }
    });
  });
  return grid;
}

/** Draws all the areas of the points */
Future<List<List<String>>> drawWithinMaxDistance(List<Point> points, List<List<String>> grid) async {
  List<Future<Distance>> futureDistances = List<Future<Distance>>();
  final int xLength = grid.length;
  final int yLength = grid.first.length;

  for (int y = 0; y < yLength; y++) {
    for (int x = 0; x < xLength; x++) {
      final Point origin = Point(x, y);
      futureDistances.add(whithinDistance(origin, points));
    }
  }

  Future.wait(futureDistances).then((distances) {
    distances.forEach((distance) {
      if (distance != null && distance.distanceSum < MAX_DISTANCE) {
        int x = distance.origin.x;
        int y = distance.origin.y;
        grid[x][y] = '#';
      }
    });
  });
  return grid;
}

/** Returns the largest finite area */
Future<int> getLargestArea(List<List<String>> grid) async {
  List<Area> areas = List();

  final int xLength = grid.length;
  final int yLength = grid.first.length;

  final int limitX = xLength - 1;
  final int limitY = yLength - 1;

  for (int y = 0; y < yLength; y++) {
    for (int x = 0; x < xLength; x++) {
      String letter = grid[x][y];
      if (letter != '.') {
        if (isNearEdge(Point(x, y), limitX, limitY)) {
          var area =
              areas.firstWhere((a) => a.char == letter, orElse: () => null);
          if (area == null) {
            areas.add(Area(letter, 1, true));
          } else {
            ++area.area;
            area.infinite = true;
          }
        } else {
          var area =
              areas.firstWhere((a) => a.char == letter, orElse: () => null);
          if (area == null) {
            areas.add(Area(letter, 1, false));
          } else {
            ++area.area;
          }
        }
      }
    }
  }
  // areas.forEach((a) => print('${a.char} - Area: ${a.area}, Infinite: ${a.infinite? 'true' : 'false'}'));
  return areas
      .reduce((maxArea, area) => maxArea = maxArea.infinite
          ? area
          : !area.infinite && maxArea.area < area.area ? area : maxArea)
      .area;
}

/** Counts all the region that is below maximum distance */
Future<int> getCenterRegion(List<List<String>> grid) async {
  int regionSum = 0;

  final int xLength = grid.length;
  final int yLength = grid.first.length;

  for (int y = 0; y < yLength; y++) {
    for (int x = 0; x < xLength; x++) {
      String char = grid[x][y];
      if (char == '#') ++regionSum;
    }
  }
  return regionSum;
}

/** Returns the closest Point or null if they have the same distance */
Future<ClosestPoint> whoIsCloser(Point origin, List<Point> points) async {
  Queue closest = Queue<Point>();
  int minDistance = 0;

  for (Point p in points) {
    int minX = min(origin.x, p.x);
    int maxX = max(origin.x, p.x);
    int minY = min(origin.y, p.y);
    int maxY = max(origin.y, p.y);

    int distance = (maxX - minX + maxY - minY);

    if (distance == 0) {
      closest.clear();
      closest.add(p);
      break;
    } else if (closest.length == 0) {
      closest.add(p);
      minDistance = distance;
    } else if (distance < minDistance) {
      closest.clear();
      closest.add(p);
      minDistance = distance;
    } else if (distance == minDistance) {
      closest.add(p);
    }
  }
  return ClosestPoint(origin, closest.length > 1 ? null : closest.first);
}

/** Returns the Distance when this is below maximum distance */
Future<Distance> whithinDistance(Point origin, List<Point> points) async {
  var distance = Distance(origin, 0);
  
  for (Point p in points) {
    int minX = min(origin.x, p.x);
    int maxX = max(origin.x, p.x);
    int minY = min(origin.y, p.y);
    int maxY = max(origin.y, p.y);

    int dstnc = (maxX - minX + maxY - minY);
    distance.distanceSum += dstnc;
    if (distance.distanceSum >= MAX_DISTANCE) return null;
  }
  return distance;
}

/** Creates a grid to store al areas */
List<List<String>> getGrid(List<Point> points) {
  final fPoint = points.first;
  int maxX = fPoint.x;
  int maxY = fPoint.y;
  points.forEach((p) {
    if (maxX < p.x) maxX = p.x;
    if (maxY < p.y) maxY = p.y;
  });

  maxX += GRID_OVERFLOW + 1;
  maxY += GRID_OVERFLOW + 1;

  return List.generate(maxX, (_) => List.filled(maxY, '.'));
}

/** Casts the lines to points */
List<Point> getPoints(List<String> lines) {
  int charCode = 64; //We start at the @ character
  int padding = (GRID_OVERFLOW / 2).round();
  return lines.map((line) {
    List<String> points = line.split(', ');
    int x = int.parse(points[0]);
    int y = int.parse(points[1]);
    if (++charCode == 91) charCode = 97;

    return Point(x + padding, y + padding,
        letter: String.fromCharCode(charCode));
  }).toList();
}

/** Prints the specified grid */
void printGrid(List<List<String>> grid) {
  final int xLength = grid.length;
  final int yLength = grid.first.length;

  print('Starting grid printing...');
  for (int y = 0; y < yLength; y++) {
    String line = '';
    for (int x = 0; x < xLength; x++) {
      line += grid[x][y];
    }
    print(line);
  }
  print('There you go');
}

/** It validates wheter is near the edge or not */
bool isNearEdge(Point p, int maxX, int maxY) {
  return (p.x == 0 || p.y == 0 || p.x == maxX || p.y == maxY);
}
