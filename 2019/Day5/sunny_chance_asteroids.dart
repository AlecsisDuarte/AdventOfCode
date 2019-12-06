import 'dart:io';

main() {

}

Future<String> getIntcodes() async {
  File input = File("../Day2/input.txt");

  await input.exists();
  return input.readAsString();
}

