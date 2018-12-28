// const String INITIAL_STATE = '#..#.#..##......###...###';
// const Map<String, String> COMBINATIONS = {
//   '...##': '#',
//   '..#..': '#',
//   '.#...': '#',
//   '.#.#.': '#',
//   '.#.##': '#',
//   '.##..': '#',
//   '.####': '#',
//   '#.#.#': '#',
//   '#.###': '#',
//   '##.#.': '#',
//   '##.##': '#',
//   '###..': '#',
//   '###.#': '#',
//   '####.': '#',
// };
const String INITIAL_STATE = '..##.#######...##.###...#..#.#.#..#.##.#.##....####..........#..#.######..####.#.#..###.##..##..#..#';
const Map<String, String> COMBINATIONS = {
  '#..#.': '.',
  '..#..': '.',
  '..#.#': '#',
  '##.#.': '.',
  '.#...': '#',
  '#....': '.',
  '#####': '#',
  '.#.##': '.',
  '#.#..': '.',
  '#.###': '#',
  '.##..': '#',
  '##...': '.',
  '#...#': '#',
  '####.': '#',
  '#.#.#': '.',
  '#..##': '.',
  '.####': '.',
  '...##': '.',
  '..###': '#',
  '.#..#': '.',
  '##..#': '#',
  '.#.#.': '.',
  '..##.': '.',
  '###..': '.',
  '###.#': '#',
  '#.##.': '#',
  '.....': '.',
  '.##.#': '#',
  '....#': '.',
  '##.##': '#',
  '...#.': '#',
  '.###.': '.'
};

void main() async {
  advanceGenerations(20)
      .then((plants) => print('Part 1: There are $plants plants'));

  advanceGenerations(50000000000)
  .then((plants) => print('Part 2: There are $plants plants'));
}

class Node {
  String pot;
  int position;
  Node left;
  Node right;

  Node(this.pot, this.position, {this.left = null, this.right = null});

  String getSixPots() {
    return this.left.left.pot +
        this.left.pot +
        this.pot +
        this.right.pot +
        this.right.right.pot;
  }

  Node insertRight(Node node) {
    node.right = this.right;
    node.left = this;
    this.right = node;
    return node;
  }

  Future<Node> addPadding() async {
    List<Future<Node>> endsFutures = List<Future<Node>>();
    endsFutures.add(this.getStart());
    endsFutures.add(this.getEnd());

    return await Future.wait(endsFutures).then((ends) async {
      List<Future> futures = List<Future>();

      //Add left pad
      futures.add(ends[0]._addLeftPadding());

      //Add right pad
      futures.add(ends[1]._addRightPadding());

      await Future.wait(futures);

      return ends[0].left.left.left == null ? ends[0] : ends[0].left;
    });
  }

  Future _addLeftPadding() async {
    Node tmp = this.insertLeft(Node('.', this.position - 1));
    tmp = tmp.insertLeft(Node('.', tmp.position - 1));
    if (this.pot == '#') tmp.insertLeft(Node('.', tmp.position - 1));
  }

  Future _addRightPadding() async {
    Node tmp = this.insertRight(Node('.', this.position + 1));
    tmp = tmp.insertRight(Node('.', this.position + 1));
    if (this.pot == '#') tmp.insertRight(Node('.', this.position + 1));
  }

  Future<Node> getEnd() async {
    Node end = this;
    while (end.right != null) end = end.right;
    return end;
  }

  Future<Node> getStart() async {
    Node start = this;
    while (start.left != null) start = start.left;
    return start;
  }

  Node insertLeft(Node node) {
    node.right = this;
    node.left = this.left;

    if (this.left != null) {
      this.left.right = node;
    }

    this.left = node;
    return node;
  }

  int SumPotsWithPlants(String value) {
    Node tmp = this;
    int potSum = 0;

    while (tmp.left != null) tmp = tmp.left;
    while (tmp.right != null) {
      if (tmp.pot == value) {
        potSum += tmp.position;
      }
      tmp = tmp.right;
    }
    return potSum;
  }

  static Future<Node> createNodes(String pots, {startingPot = 0}) async {
    List<String> potsList = pots.split('');
    Node node = Node(potsList[0], startingPot);

    for (int index = 1; index < potsList.length; index++) {
      node = node.insertRight(Node(potsList[index], index + startingPot));
    }
    return await node.getStart();
  }
}

Future<int> advanceGenerations(final int generations) async {
  Node node = await Node.createNodes(INITIAL_STATE);
  node = await node.addPadding();

  for (int generation = 0; generation < generations; generation++) {
    Node tmp = null;

    while (node.right.right != null) {
      final String sixPots = node.getSixPots();
      final String result = COMBINATIONS[sixPots] ?? '.';
      if (tmp == null) {
        tmp = Node(result, node.position);
      } else {
        tmp = tmp.insertRight(Node(result, node.position));
      }
      node = node.right;
    }

    node = await tmp.addPadding();
  }
  return node.SumPotsWithPlants('#');
}
