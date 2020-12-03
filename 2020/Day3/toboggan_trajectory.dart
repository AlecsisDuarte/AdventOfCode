import '../../utils/dart_utils.dart';

List<List<bool>> treeArea;

List<Traverse> traverses = [
  Traverse(1, 1),
  Traverse(3, 1),
  Traverse(5, 1),
  Traverse(7, 1),
  Traverse(1, 2),
];

class Traverse {
  Traverse(this.indexRight, this.indexDown);
  int indexDown;
  int indexRight;
}

void main(List<String> args) async {
  String input = await readInput(2020, 3);
  initializeTreeArea(input);
  print("Part 1: Trees encountered = " +
      treesEncounteredInTraverse(traverses[1]).toString());
  print("Part 2: Trees encountered in all traverses = " +
      treesEncounteredInAllTraverses().toString());
}

void initializeTreeArea(String input) {
  treeArea = new List();
  for (String line in input.split("\n")) {
    List<bool> treeLine = new List(line.length);
    for (int index = 0; index < line.length; index++) {
      treeLine[index] = line[index] == "#";
    }
    treeArea.add(treeLine);
  }
}

int treesEncounteredInTraverse(Traverse traverse) {
  int x = 0;
  int y = 0;
  int encounters = 0;
  int maxLength = treeArea[0].length;
  int maxDepth = treeArea.length - 1;

  do {
    x += traverse.indexRight;
    if (x >= maxLength) x -= maxLength;
    y += traverse.indexDown;
    if (y > maxDepth) break;
    if (treeArea[y][x]) encounters++;
  } while (true);
  return encounters;
}

int treesEncounteredInAllTraverses() {
  int encountersMultiplication = 1;
  for (Traverse traverse in traverses) {
    encountersMultiplication *= treesEncounteredInTraverse(traverse);
  }
  return encountersMultiplication;
}
