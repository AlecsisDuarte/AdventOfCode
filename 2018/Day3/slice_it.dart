import 'dart:collection';
import 'dart:io';
import 'dart:math';

import '../utils/input_reader.dart';

void main() async {
  File input = InputReader.openInputFile('Day3', 'input.txt');
  if (!await input.exists()) {
    print('Input file not found');
    return;
  }
  input.readAsLines().then((lines) {
    List<Rectangle> claims = getRectangles(lines);
    getOverlappingInformation(claims).then((response) {
      print('Square inches overlaped: ${response.overlappedPoints}');
      print('Not overlapped claim: ${response.notOverlappedClaim}');
    });
  });
}

final RegExp pointsRegex = RegExp(r"(\d+) @ (\d+),(\d+): (\d+)x(\d+)");

class Point {
  final int x;
  final int y;

  String toString() => "${x},${y}";

  Point(this.x, this.y);
}

class Rectangle {
  int id;
  final Point upLeft;
  final Point downRight;

  String toString() => "$id - (${upLeft.toString()})(${downRight.toString()})";

  Rectangle(this.id, this.upLeft, this.downRight);
}

class Response {
  int overlappedPoints;
  int notOverlappedClaim;
  Response({this.notOverlappedClaim, this.overlappedPoints});
}

/** Returns the ammont of square inches overlapped and the claim that never overlaps */
Future<Response> getOverlappingInformation(List<Rectangle> claims) async {
  HashMap<String, int> overlaps = HashMap();
  HashMap<int, int> claimNotOverlapped = HashMap();

  for (int index = 0; index < claims.length; index++) {
    final Rectangle rectA = claims[index];

    for (int nextClaim = index + 1; nextClaim < claims.length; nextClaim++) {
      final Rectangle rectB = claims[nextClaim];

      final Rectangle overlap = getOverlapedRectangle(rectA, rectB);

      if (overlap != null) {
        List<Point> overlapPoints = rectangleToPoints(overlap);

        overlapPoints.forEach((point) => overlaps
            .update(point.toString(), (value) => ++value, ifAbsent: () => 1));
      } else {
        claimNotOverlapped.update(rectA.id, (times) => ++times,
            ifAbsent: () => 1);
        claimNotOverlapped.update(rectB.id, (times) => ++times,
            ifAbsent: () => 1);
      }
    }
  }

  Response response = Response(overlappedPoints: overlaps.keys.length);

  int maxNotOverlap = claimNotOverlapped.values
      .reduce((max, val) => max = val > max ? val : max);
      
  claimNotOverlapped.forEach((claim, times) {
    if (times == maxNotOverlap) {
      response.notOverlappedClaim = claim;
      return;
    }
  });

  return response;
}

/** Casts the string list to a list of rectangles */
List<Rectangle> getRectangles(List<String> claims) {
  List<Rectangle> rectangles = List(claims.length);

  claims.forEach((claim) {
    final Match match = pointsRegex.firstMatch(claim);
    final Rectangle rectangle = getRectangle(match);

    rectangles[rectangle.id - 1] = rectangle;
  });

  return rectangles;
}

/** Returns the rectangle with the information/groups of the match */
Rectangle getRectangle(Match claimMatch) {
  int id = int.parse(claimMatch.group(1));

  int x = int.parse(claimMatch.group(2)) + 1;
  int y = int.parse(claimMatch.group(3)) + 1;

  int width = int.parse(claimMatch.group(4)) - 1;
  int height = int.parse(claimMatch.group(5)) - 1;

  Point upperLeftPoint = Point(x, y);
  Point downRightPoint = Point(x + width, y + height);

  return Rectangle(id, upperLeftPoint, downRightPoint);
}

/** Gets the resulting rectangle of the overlapping rectangles if any */
Rectangle getOverlapedRectangle(Rectangle rectA, Rectangle rectB) {
  if (!rectanglesOverlap(rectA, rectB)) {
    return null;
  }
  int x = max(rectA.upLeft.x, rectB.upLeft.x);
  int y = max(rectA.upLeft.y, rectB.upLeft.y);
  Point upLeft = Point(x, y);

  int x2 = min(rectA.downRight.x, rectB.downRight.x);
  int y2 = min(rectA.downRight.y, rectB.downRight.y);
  Point downRight = Point(x2, y2);

  return Rectangle(null, upLeft, downRight);
}

/** Validates whether there is or not overlapping */
bool rectanglesOverlap(Rectangle a, Rectangle b) {
  Point ulA = a.upLeft;
  Point drA = a.downRight;
  Point ulB = b.upLeft;
  Point drB = b.downRight;

  return !(drA.x < ulB.x || drA.y < ulB.y || ulA.x > drB.x || ulA.y > drB.y);
}

/** Returns all the points that conforms the rectangle */
List<Point> rectangleToPoints(Rectangle rectangle) {
  List<Point> points = List();
  for (int x = rectangle.upLeft.x; x <= rectangle.downRight.x; x++) {
    for (int y = rectangle.upLeft.y; y <= rectangle.downRight.y; y++) {
      points.add(Point(x, y));
    }
  }
  return points;
}
