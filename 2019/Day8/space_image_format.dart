import '../../utils/dart_utils.dart' show readInput;

const int PIXELS_WIDE = 25;
const int PIXELS_TALL = 6;

main() async {
  String input = await readInput(2019, 8);
  List<Layer> layers = countLayerDigits(input);
  solvePartOne(layers);
  solvePartTwo(layers);
}

void solvePartOne(List<Layer> layers) {
  Layer layer = layers.reduce((val, min) {
    if (min == null || val.ceros < min.ceros) {
      return val;
    }
    return min;
  });

  print(
      "Part 1 - [1 Digits ${layer.ones}] * [2 Digits ${layer.twos}] = ${layer.ones * layer.twos}");
}

void solvePartTwo(List<Layer> layers) {
  print("Part 2 - The image");
  int index = 0;
  int imageSize = PIXELS_TALL * PIXELS_WIDE;

  do {
    StringBuffer buffer = StringBuffer();
    for (int x = 0; x < PIXELS_WIDE; x++) {
      int pixel = 2;
      for (int l = 0; l < layers.length; l++) {
        pixel = layers[l].pixels[index];
        if (pixel < 2) {
          break;
        }
      }
      buffer.write(pixel == 0 ? "  " : "X ");
      index++;
    }
    print(buffer.toString());
  } while (index < imageSize);
}

List<Layer> countLayerDigits(String input) {
  int layerSize = PIXELS_WIDE * PIXELS_TALL;
  List<Layer> layers = List();
  int index = 0;

  while (index < input.length) {
    int to = index + layerSize;
    Layer layer = Layer();

    for (; index < to; index++) {
      int pixel = input.codeUnitAt(index) - 48;
      layer.reps[pixel]++;
      layer.pixels.add(pixel);
    }
    layers.add(layer);
  }
  return layers;
}

class Layer {

  Layer() {
    reps = List.filled(3, 0);
    pixels = List();
  }

  List<int> pixels;
  List<int> reps;

  int get ceros => reps[0];

  int get ones => reps[1];

  int get twos => reps[2];
}
