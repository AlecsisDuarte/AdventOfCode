import 'dart:collection';
import '../../utils/dart_utils.dart' show readInput;

main() async {
  String input = await readInput(2019, 6);
  countDirectIndirectOribits(input);
}

class Node {
  String parent;
  List<String> children;

  Node(this.parent, this.children);

  @override
  String toString() {
    return "$parent: $children";
  }
}

class Parent {
  String parent;
  bool passed = false;

  Parent(this.parent);
}



void countDirectIndirectOribits(String input) {
  List<String> map = input.split("\n");
  HashMap<String, int> orbits = HashMap();
  HashMap<String, Node> relationships = HashMap();
  HashMap<String, Parent> parents = HashMap();

  for (String rel in map) {
    List<String> objects = rel.split(")");
    addOrbits(orbits, relationships, parents, objects);
  }

  int indirectDirectOrbits = orbits.values.reduce((val, res) => res + val);
  int sanToYouOrbitsDistance = calculateSanYouDistance(orbits, parents);

  print("Part 1 - Total orbits $indirectDirectOrbits");
  print("Part 2 - SAN & YOU have $sanToYouOrbitsDistance");
}

void addOrbits(HashMap<String, int> orbits, HashMap<String, Node> relationships,
    HashMap<String, Parent> parents, List<String> objects) {
  String from = objects[0];
  String to = objects[1];

  Node node = Node(from, [to]);
  parents[to] = new Parent(from);

  if (relationships.containsKey(from)) {
    relationships[from].children.add(node.children.first);
  } else {
    relationships[from] = Node(from, node.children);
  }

  Queue<Node> nodes = Queue();
  nodes.add(node);

  while (nodes.isNotEmpty) {
    node = nodes.removeFirst();
    for (String to in node.children) {
      orbits[to] =
          (orbits[to] ?? 0) + (orbits[from] == null ? 1 : orbits[from] + 1);
      if (relationships.containsKey(to)) {
        nodes.add(relationships[to]);
      }
    }
  }
}

int calculateSanYouDistance(HashMap<String, int> orbits, HashMap<String,Parent> parents) {
  String sanYouParent = getYouAndSantaParent(parents);
  int parentOrbits = orbits[sanYouParent];
  return orbits["SAN"] + orbits["YOU"] - (parentOrbits * 2) - 4;
}

String getYouAndSantaParent(HashMap<String, Parent> parents) {
  String child = "YOU";
  while (parents[child] != null) {
    parents[child].passed = true;
    child = parents[child].parent;
  }

  child = "SAN";
  while (parents[child] != null) {
    if (parents[child].passed || child == "YOU") {
      return parents[child].parent;
    }
    child = parents[child].parent;
  }
  return null;
}
