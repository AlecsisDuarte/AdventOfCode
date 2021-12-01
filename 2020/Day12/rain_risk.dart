import 'package:angles/angles.dart';

import '../../utils/dart_utils.dart';

const int EAST_DIRECTION = 0; //Will use EAST as 0 degrees

class Ship {
  Ship(this.position, {this.direction = EAST_DIRECTION});
  int direction;
  Point position;
  Point waypoint = Point(x: 10, y: 1);

  void turn(int degrees) {
    direction += degrees;
    while (direction >= 360) direction -= 360;
    while (direction <= 0) direction += 360;
  }

  void setWaypointPosition(int x, int y) {
    waypoint.x = x;
    waypoint.y = y;
  }

  int get distanceToWaypoint =>
      (position.x - waypoint.x).abs() + (position.y - waypoint.y).abs();

  int get manhattanDistance => this.position.x.abs() + this.position.y.abs();

  @override
  String toString() {
    return '{position: $position, manhattanDistance: ${this.manhattanDistance}, waypoint: $waypoint}';
  }
}

class Point {
  Point({this.x = 0, this.y = 0});
  int x, y;

  @override
  String toString() {
    return "{x: $x, y: $y}";
  }
}

enum Action { N, S, E, W, L, R, F }

class Instruction {
  Instruction(this.action, this.value);
  Action action;
  int value;
}

void main(List<String> args) async {
  String input = await readInput(2020, 12);
  solvePartOneAndTwo(input);
}

void solvePartOneAndTwo(String input) {
  List<Instruction> instructions = inputToInstructions(input);
  Ship ship = new Ship(Point());
  moveShip(ship, instructions);
  print('Part 1: Manhattan distance = ${ship.manhattanDistance}');
  Ship shipWithWaypoint = new Ship(Point());
  moveShipRelativeToWaypoint(shipWithWaypoint, instructions);
  print('Part 2: Manhattan distance = ${shipWithWaypoint.manhattanDistance}');
}

List<Instruction> inputToInstructions(String input) {
  List<Instruction> instructions = List();
  for (String line in input.split("\n")) {
    Action action;
    switch (line[0]) {
      case "N":
        action = Action.N;
        break;
      case "S":
        action = Action.S;
        break;
      case "E":
        action = Action.E;
        break;
      case "W":
        action = Action.W;
        break;
      case "L":
        action = Action.L;
        break;
      case "R":
        action = Action.R;
        break;
      case "F":
        action = Action.F;
        break;
    }
    instructions.add(Instruction(action, int.parse(line.substring(1))));
  }
  return instructions;
}

void moveShip(Ship ship, List<Instruction> instructions) {
  for (Instruction instruction in instructions) {
    switch (instruction.action) {
      case Action.N:
        ship.position.y += instruction.value;
        break;
      case Action.S:
        ship.position.y -= instruction.value;
        break;
      case Action.E:
        ship.position.x += instruction.value;
        break;
      case Action.W:
        ship.position.x -= instruction.value;
        break;
      case Action.L:
        ship.turn(-instruction.value);
        break;
      case Action.R:
        ship.turn(instruction.value);
        break;
      case Action.F:
        Angle angle = Angle.fromDegrees(ship.direction.toDouble());
        ship.position.x += (instruction.value * angle.cos).round();
        ship.position.y -= (instruction.value * angle.sin).round();
        break;
    }
  }
}

void moveShipRelativeToWaypoint(Ship ship, List<Instruction> instructions) {
  // print(ship);
  for (Instruction instruction in instructions) {
    switch (instruction.action) {
      case Action.N:
        ship.waypoint.y += instruction.value;
        break;
      case Action.S:
        ship.waypoint.y -= instruction.value;
        break;
      case Action.E:
        ship.waypoint.x += instruction.value;
        break;
      case Action.W:
        ship.waypoint.x -= instruction.value;
        break;
      case Action.L:
        rotateWaypoint(ship, -instruction.value);
        break;
      case Action.R:
        rotateWaypoint(ship, instruction.value);
        break;
      case Action.F:
        ship.position.x += ship.waypoint.x * instruction.value;
        ship.position.y += ship.waypoint.y * instruction.value;
        break;
    }
    // print(ship);
  }
}

void rotateWaypoint(Ship ship, int degrees) {
  int sectorJumps = ((degrees.abs() / 90) % 4).round();
  if (degrees < 0) {
    sectorJumps = 4 - sectorJumps;
  }

  int x, y;
  switch (sectorJumps) {
    case 1:
      x = ship.waypoint.y;
      y = -ship.waypoint.x;
      break;
    case 2:
      x = -ship.waypoint.x;
      y = -ship.waypoint.y;
      break;
    case 3:
      x = -ship.waypoint.y;
      y = ship.waypoint.x;
      break;
    default:
      x = ship.waypoint.x;
      y = ship.waypoint.y;
  }
  ship.setWaypointPosition(x, y);
}

/**
 * Pos: 1, 10   //NE
 * R90
 * Pos: 10, -1  //SE  
 * R90
 * Pos: -1, -10 //SW
 * R90
 * Pos: -10, 1  //NW
 */
