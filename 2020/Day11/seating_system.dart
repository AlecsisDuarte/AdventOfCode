import '../../utils/dart_utils.dart';

class Point {
  Point(this.x, this.y);
  int x;
  int y;
  @override
  String toString() {
    return "{x: $x, y: $y}";
  }
}

List<Point> directions = [
  Point(-1, -1), //Up Left
  Point(0, -1), //Up
  Point(1, -1), //Up Right
  Point(1, 0), //Right
  Point(1, 1), //Down Right
  Point(0, 1), //Down
  Point(-1, 1), //Down Left
  Point(-1, 0) //Left
];

void main(List<String> args) async {
  String input = await readInput(2020, 11);
  solvePartOneAndTwo(input);
}

List<List<bool>> inputToSeats(String input) {
  List<List<bool>> seats = List();
  for (String line in input.split("\n")) {
    seats.add([null]);
    for (String pos in line.split("")) {
      seats.last.add(pos == "L" ? false : null);
    }
    seats.last.add(null);
  }
  List<bool> emptyLine = List.filled(seats.first.length, null);
  seats.insert(0, emptyLine);
  seats.add(emptyLine);
  return seats;
}

void solvePartOneAndTwo(String input) {
  List<List<bool>> seats = inputToSeats(input);
  int occupiedSeats = howManySeatsEndUpOccupied(seats);
  seats = inputToSeats(input);
  print("Part 1: Seats occupied = $occupiedSeats");
  howManySeatsEndUpOccupiedPartTwo(seats).then(
      (occupiedSeats) => print("Part 2: Seats occupied = $occupiedSeats"));
}

int howManySeatsEndUpOccupied(List<List<bool>> seats) {
  List<Point> changingStates;
  int occupiedSeats;
  do {
    changingStates = List();
    occupiedSeats = 0;
    for (int y = 1; y < seats.length - 1; y++) {
      List<bool> line = seats[y];
      for (int x = 1; x < line.length - 1; x++) {
        bool seat = line[x];
        if (seat == null)
          continue;
        else if (seat == true) {
          ++occupiedSeats;
        }
        changesState(seats, x, y, changingStates);
      }
    }
    changingStates.forEach((p) => seats[p.y][p.x] = !seats[p.y][p.x]);
  } while (changingStates.isNotEmpty);
  return occupiedSeats;
}

Future<int> howManySeatsEndUpOccupiedPartTwo(List<List<bool>> seats) async {
  List<Point> changingStates;
  int occupiedSeats;
  do {
    changingStates = List();
    occupiedSeats = 0;
    for (int y = 1; y < seats.length - 1; y++) {
      List<bool> line = seats[y];
      for (int x = 1; x < line.length - 1; x++) {
        bool seat = line[x];
        if (seat == null)
          continue;
        else if (seat == true) {
          ++occupiedSeats;
        }
        await changesStateWithoutMistake(seats, x, y, changingStates);
      }
    }
    changingStates.forEach((p) => seats[p.y][p.x] = !seats[p.y][p.x]);
  } while (changingStates.isNotEmpty);
  return occupiedSeats;
}

void changesState(
    List<List<bool>> seats, int x, int y, List<Point> changingStates) {
  bool state = seats[y][x];
  switch (state) {
    case true: // occupied
      if (occupiedChanges(seats, x, y)) {
        changingStates.add(Point(x, y));
      }
      break;
    case false: // empty
      if (emptyChanges(seats, x, y)) {
        changingStates.add(Point(x, y));
      }
      break;
  }
}

void changesStateWithoutMistake(
    List<List<bool>> seats, int x, int y, List<Point> changingStates) async {
  bool state = seats[y][x];
  switch (state) {
    case true: // occupied
      bool occupiedChanges = await occupiedChangesMoreTolerant(seats, x, y);
      if (occupiedChanges) {
        changingStates.add(Point(x, y));
      }
      break;
    case false: // empty
      bool emptyChanges = await emptyChangesInSight(seats, x, y);
      if (emptyChanges) {
        changingStates.add(Point(x, y));
      }
      break;
  }
}

bool occupiedChanges(List<List<bool>> seats, int x, int y) =>
    directions
        .map((point) => seats[y + point.y][x + point.x])
        .fold(0, (occupied, seat) => occupied += seat == true ? 1 : 0) >=
    4;

Future<bool> occupiedChangesMoreTolerant(
        List<List<bool>> seats, int x, int y) async =>
    await Future.wait(directions
            .map((point) => occupiedInSight(seats, Point(x, y), point)))
        .then((seatsStates) =>
            seatsStates.fold(
                0, (occupied, seat) => occupied += seat == true ? 1 : 0) >=
            5);

bool emptyChanges(List<List<bool>> seats, int x, int y) => !directions
    .map((point) => seats[y + point.y][x + point.x])
    .firstWhere((seat) => seat == true, orElse: () => false);

Future<bool> emptyChangesInSight(List<List<bool>> seats, int x, int y) async =>
    await Future.wait(directions.map((point) =>
        occupiedInSight(seats, Point(x, y), point,
            printPoint: (x == 4 && y == 1)))).then((seatsStates) =>
        !seatsStates.firstWhere((seat) => seat == true, orElse: () => false));

Future<bool> occupiedInSight(List<List<bool>> seats, Point p, Point pDir,
    {printPoint = false}) async {
  int width = seats.first.length;
  int height = seats.length;
  p.x += pDir.x;
  p.y += pDir.y;
  while (p.x > 0 && p.y > 0 && p.y < height && p.x < width) {
    bool seat = seats[p.y][p.x];
    if (seat == true) {
      return true;
    }
    if (seat == false) {
      return false;
    }
    p.x += pDir.x;
    p.y += pDir.y;
  }
  return null;
}

void printGrid(List<List<bool>> grid) {
  grid.forEach((element) {
    List<String> line = List();
    element.forEach((e) => line.add(e == true
        ? "#"
        : e == false
            ? "L"
            : "."));
    print(line.join());
  });
}
