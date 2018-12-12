const GAME_INFO = [
  '439 players; last marble is worth 71307 points',
  '439 players; last marble is worth 7130700 points'
];

void main() async {
  int part = 1;
  GAME_INFO.forEach((gameinfo) {
    final List<String> info = gameinfo.split(' ');
    final int players = int.parse(info[0]);
    final int lastMarble = int.parse(info[6]);

    getHighestScore(players, lastMarble)
        .then((highScore) => print('Part ${part++} - High Score: $highScore'));
  });
}

Future<int> getHighestScore(final int players, final int lastMarble) async {
  Node currentMarble = Node(0);
  currentMarble.next = currentMarble;
  currentMarble.prev = currentMarble;

  int marble = 0;
  int player = 0;
  final List<int> playerScore = List<int>.filled(players, 0);

  while (++marble < lastMarble) {
    if (player == playerScore.length) player = 0;

    if (marble % 23 == 0) {
      playerScore[player] += marble;
      currentMarble = currentMarble.lastSevenNode();

      playerScore[player] += currentMarble.value;
      currentMarble = currentMarble.remove();
    } else {
      currentMarble = currentMarble.next;
      currentMarble = currentMarble.insert(Node(marble));
    }
    player++;
  }
  return playerScore.reduce((max, cur) => max = max > cur ? max : cur);
}

class Node {
  int value;
  Node prev;
  Node next;

  Node(this.value, {this.prev = null, this.next = null});
  
  Node insert(Node node) {
    node.next = this.next;
    this.next.prev = node;
    this.next = node;
    node.prev = this;
    return node;
  }

  Node remove() {
    Node prev = this.prev;
    Node next = this.next;

    prev.next = this.next;
    next.prev = prev;

    return next;
  }

  Node lastSevenNode() {
    return this.prev.prev.prev.prev.prev.prev.prev;
  }
}
