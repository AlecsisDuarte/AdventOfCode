import 'dart:collection';

import '../../utils/dart_utils.dart';

main() async {
  String input = await readInput(2019, 12);
  List<Moon> moons = createMoons(input);
  // totalEnergyOnThisSteps(moons);
  repeatedUniverse(moons);
}

enum Axis { X, Y, Z }

const Map<Axis, String> axisName = {
  Axis.X: "x",
  Axis.Y: "y",
  Axis.Z: "z",
};

class Moon {
  Map<Axis, int> _positions;
  Map<Axis, int> _velocities = {Axis.X: 0, Axis.Y: 0, Axis.Z: 0};

  Moon(int x, int y, int z, {velX = 0, velY = 0, velZ = 0}) {
    _positions = {Axis.X: x, Axis.Y: y, Axis.Z: z};
    _velocities = {Axis.X: velX, Axis.Y: velY, Axis.Z: velZ};
  }

  int get posX => _positions[Axis.X];
  int get posY => _positions[Axis.Y];
  int get posZ => _positions[Axis.Z];

  int get velX => _velocities[Axis.X];
  int get velY => _velocities[Axis.Y];
  int get velZ => _velocities[Axis.Z];

  void set setPosX(x) => _positions[Axis.X] = x;
  void set setPosY(y) => _positions[Axis.Y] = y;
  void set setPosZ(z) => _positions[Axis.Z] = z;

  void _incAxisPos(Axis axis, int inc) => _positions[axis] += inc;
  void _incAxisVel(Axis axis, int inc) => _velocities[axis] += inc;

  bool _hasGreaterPos(Axis axis, Moon moon) =>
      _positions[axis] > moon._positions[axis];

  void applyGravity(Moon moon) =>
      Axis.values.forEach((axis) => _applyGravitiyOnAxis(axis, moon));

  void addVelocity() => Axis.values.forEach(_addVelocityOnAxis);

  void _applyGravitiyOnAxis(Axis axis, Moon moon) {
    if (_hasGreaterPos(axis, moon)) {
      _incAxisVel(axis, -1);
      moon._incAxisVel(axis, 1);
    } else if (moon._hasGreaterPos(axis, this)) {
      _incAxisVel(axis, 1);
      moon._incAxisVel(axis, -1);
    }
  }

  void _addVelocityOnAxis(Axis axis) => _incAxisPos(axis, _velocities[axis]);

  int get potentialEnergy => posX.abs() + posY.abs() + posZ.abs();
  int get kineticEnergy => velX.abs() + velY.abs() + velZ.abs();

  int get totalEnergy => potentialEnergy * kineticEnergy;

  String pad(int n, {width = 2}) => n.toString().padLeft(width, " ");

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() =>
      "$posX,$posY,$posZ,$velX,$velY,$velZ";

  Moon get clone => Moon(posX, posY, posZ, velX: velX, velY: velY, velZ: velZ);
}

List<Moon> createMoons(String input) {
  RegExp reg = RegExp(r"<x=(-?\d+), y=(-?\d+), z=(-?\d+)>");
  List<Moon> moons = [];

  for (RegExpMatch match in reg.allMatches(input)) {
    int x = int.parse(match.group(1));
    int y = int.parse(match.group(2));
    int z = int.parse(match.group(3));

    moons.add(Moon(x, y, z));
  }
  return moons;
}

void totalEnergyOnThisSteps(List<Moon> orgMoons, {int steps = 1000}) {
  List<Moon> moons = orgMoons.map((moon) => moon.clone).toList();

  for (int step = 1; step <= steps; step++) {
    for (int moonA = 0; moonA < moons.length - 1; moonA++) {
      Moon fromMoon = moons[moonA];
      for (int moonB = moonA + 1; moonB < moons.length; moonB++) {
        Moon toMoon = moons[moonB];
        fromMoon.applyGravity(toMoon);
      }
      fromMoon.addVelocity();
    }
    moons.last.addVelocity();
  }

  int totalEnergy = 0;
  moons.forEach((moon) => totalEnergy += moon.totalEnergy);
  print("Part 1 - Total energy: $totalEnergy");
}

void printMoonListOnStep(List<Moon> moons, int step) {
  print("Afer $step steps: ");
  moons.forEach(print);
  print("");
}

void repeatedUniverse(List<Moon> orgMoons) {
  List<Moon> moons = orgMoons.map((moon) => moon.clone).toList();

  HashSet<String> hashcodes = HashSet();
  String hashcode;
  int step = -1;

  do {
    StringBuffer buffer = StringBuffer();
    for (int moonA = 0; moonA < moons.length - 1; moonA++) {
      Moon fromMoon = moons[moonA];
      for (int moonB = moonA + 1; moonB < moons.length; moonB++) {
        Moon toMoon = moons[moonB];
        fromMoon.applyGravity(toMoon);
      }
      fromMoon.addVelocity();
      buffer.write(fromMoon.toString());
    }
    moons.last.addVelocity();
    buffer.write(moons.last.toString());
    hashcode = buffer.toString();
    step++;
  } while (hashcodes.add(hashcode));

  print("Part 2 - Universe repeats after $step steps");
}
