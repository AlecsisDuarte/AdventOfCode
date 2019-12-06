import 'dart:collection';
import 'dart:io';
import 'dart:math';

const Point ORIGIN_POINT = Point(0, 0);

class Metadata {
  bool intersects = false;
  int wireId;
  int firstWireDis = 0;
  int secondWireDis = 0;

  Metadata(this.wireId, this.firstWireDis);
}

main() async {
  var file = File("./input.txt");
  if (await file.exists()) {
    final String input = await file.readAsString();
    HashMap<Point, Metadata> steps = findAllSteps(input);
    distanceToClosestIntersection(steps);
  }
}

void distanceToClosestIntersection(HashMap<Point, Metadata> steps) {
  int minDistance = 999999999;
  int minTotalSteps = 999999999;

  steps.forEach((p, meta) {
    if (meta.intersects) {
      int distance = p.x.abs() + p.y.abs();
      if (distance < minDistance) {
        minDistance = distance;
      }
      if (meta.firstWireDis + meta.secondWireDis < minTotalSteps) {
        minTotalSteps = meta.firstWireDis + meta.secondWireDis;
      }
    }
  });
  print("Part 1 - Min Distance $minDistance");
  print("Part 2 - Min total steps $minTotalSteps");
}

HashMap<Point, Metadata>  findAllSteps(String input) {
  List<String> wires = input.split("\n");

  HashMap<Point, Metadata> steps = new HashMap();
  int wireId = 0;

  wires.forEach((w) => handleWire(wireId++, w, steps, ORIGIN_POINT));
  return steps;
}

void handleWire(int wireId, String wire, Map steps, Point start) {
  List<String> directions = wire.split(",");
  Point step;
  int totalDis = 1;

  for (String direction in directions) {
    String dir = direction[0];
    int dis = int.parse(direction.substring(1));

    switch (dir) {
      case 'U':
        for (int i = start.y + 1; i <= start.y + dis; i++) {
          step = Point(start.x, i);
          addStepWithIntersection(steps, step, wireId, totalDis++);
        }
        break;
      case 'D':
        for (int i = start.y - 1; i >= start.y - dis; i--) {
          step = Point(start.x, i);
          addStepWithIntersection(steps, step, wireId, totalDis++);
        }
        break;
      case 'R':
        for (int i = start.x + 1; i <= start.x + dis; i++) {
          step = Point(i, start.y);
          addStepWithIntersection(steps, step, wireId, totalDis++);
        }
        break;
      case 'L':
        for (int i = start.x - 1; i >= start.x - dis; i--) {
          step = Point(i, start.y);
          addStepWithIntersection(steps, step, wireId, totalDis++);
        }
        break;
    }

    start = step;
  }
}

void addStepWithIntersection(HashMap<Point, Metadata> steps, Point step, int wireId, int totalDis) {
  Metadata intersectMeta = steps[step];
  if (intersectMeta != null) {
    if (!intersectMeta.intersects && intersectMeta.wireId != wireId) {
      steps[step].intersects = true;
      steps[step].secondWireDis = totalDis;
    }
  } else {
    steps[step] = Metadata(wireId, totalDis);
  }
}
