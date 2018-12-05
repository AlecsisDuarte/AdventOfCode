/**
 --- Day 3: No Matter How You Slice It ---
  The Elves managed to locate the chimney-squeeze prototype fabric for Santa's suit (thanks to someone who 
  helpfully wrote its box IDs on the wall of the warehouse in the middle of the night). Unfortunately, 
  anomalies are still affecting them - nobody can even agree on how to cut the fabric.

  The whole piece of fabric they're working on is a very large square - at least 1000 inches on each side.

  Each Elf has made a claim about which area of fabric would be ideal for Santa's suit. All claims have an 
  ID and consist of a single rectangle with edges parallel to the edges of the fabric. Each claim's rectangle 
  is defined as follows:

  The number of inches between the left edge of the fabric and the left edge of the rectangle.
  The number of inches between the top edge of the fabric and the top edge of the rectangle.
  The width of the rectangle in inches.
  The height of the rectangle in inches.
  A claim like #123 @ 3,2: 5x4 means that claim ID 123 specifies a rectangle 3 inches from the left edge, 
  2 inches from the top edge, 5 inches wide, and 4 inches tall. Visually, it claims the square inches of 
  fabric represented by # (and ignores the square inches of fabric represented by .) in the diagram below:

  ...........
  ...........
  ...#####...
  ...#####...
  ...#####...
  ...#####...
  ...........
  ...........
  ...........
  The problem is that many of the claims overlap, causing two or more claims to cover part of the same areas. 
  For example, consider the following claims:

  #1 @ 1,3: 4x4
  #2 @ 3,1: 4x4
  #3 @ 5,5: 2x2
  Visually, these claim the following areas:

  ........
  ...2222.
  ...2222.
  .11XX22.
  .11XX22.
  .111133.
  .111133.
  ........
  The four square inches marked with X are claimed by both 1 and 2. (Claim 3, while adjacent to the others, 
  does not overlap either of them.)

  If the Elves all proceed with their own plans, none of them will have enough fabric. How many square inches 
  of fabric are within two or more claims?


  --- Part Two ---
  Amidst the chaos, you notice that exactly one claim doesn't overlap by even a single square inch of fabric 
  with any other claim. If you can somehow draw attention to it, maybe the Elves will be able to make 
  Santa's suit after all!

  For example, in the claims above, only claim 3 is intact after all claims are made.

  What is the ID of the only claim that doesn't overlap?
 */


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
