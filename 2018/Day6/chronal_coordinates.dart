import 'dart:collection';
import 'dart:io';
import 'dart:math';

import '../utils/input_reader.dart';

final int gridOverflow = 0;

void main() async {
  File input = InputReader.openInputFile('Day6', 'input.txt');
  if (!await input.exists()) {
    print('Input file not found');
    return;
  }

  input.readAsLines().then((lines) {
    final List<Point> points = getPoints(lines);
    final List<List<String>> grid = getGrid(points);
    drawAreas(points, grid).then((newGrid) {
      // printGrid(newGrid);
      getLargestArea(grid).then((max) => print('Max Area: $max'));
    });
  });
}

class Point {
  int x;
  int y;
  String letter;
  Point(this.x, this.y, {this.letter = null});
}

class ClosestPoint {
  Point origin;
  Point closest;
  bool nearEdge;
  ClosestPoint(this.origin, this.closest);
}

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

Future<int> getLargestArea(List<List<String>> grid) async {
  List<Area> areas = List();

  final int xLength = grid.length;
  final int yLength = grid.first.length;

  final int limitX = xLength - 1;
  final int limitY = yLength - 1;

  for(int y = 0; y < yLength; y++) {
   for(int x = 0 ; x < xLength; x++)  {
     String letter = grid[x][y];
     if (letter != '.') {
       if(isNearEdge(Point(x,y), limitX, limitY)) {
         var area = areas.firstWhere((a) => a.char == letter, orElse: () => null);
         if (area == null) {
           areas.add(Area(letter, 1, true));
         } else {
           ++area.area;
           area.infinite = true;
         }
       } else {
         var area = areas.firstWhere((a) => a.char == letter, orElse: () => null);
         if (area == null) {
           areas.add(Area(letter, 1, false));
         } else {
           ++area.area;
         }
       }
     }
   }
  }

  return areas.reduce((maxArea, area) => maxArea = maxArea.area < area.area && !area.infinite? area : maxArea).area;
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

List<List<String>> getGrid(List<Point> points) {
  final fPoint = points.first;
  int maxX = fPoint.x;
  int maxY = fPoint.y;
  points.forEach((p) {
    if (maxX < p.x) maxX = p.x;
    if (maxY < p.y) maxY = p.y;
  });

  maxX += gridOverflow + 1;
  maxY += gridOverflow + 1;

  return List.generate(maxX, (_) => List.filled(maxY, '.'));
}

List<Point> getPoints(List<String> lines) {
  int charCode = 64; //We start at the @ character
  return lines.map((line) {
    List<String> points = line.split(', ');
    int x = int.parse(points[0]);
    int y = int.parse(points[1]);
    if (++charCode == 91) charCode = 97;

    return Point(x, y, letter: String.fromCharCode(charCode));
  }).toList();
}

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

bool isNearEdge(Point p, int maxX, int maxY) {
  return (p.x == 0 || p.y == 0 || p.x == maxX || p.y == maxY);
}
