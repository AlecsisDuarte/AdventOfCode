import '../../utils/dart_utils.dart';

const int EARLIEST_TIMESTAMP_INDEX = 0;
const int BUSES_ID_INDEX = 1;
const int EARLIEST_TIMESTAMP_PART_TWO = 100000000000000;

class Notes {
  Notes(this.earliestDepart, this.busIDs, this.buses);
  int earliestDepart;
  List<int> busIDs;
  List<Bus> buses;
}

class Bus extends Comparable {
  Bus(this.id, this.departure);
  int id;
  int departure;
  int get offseted => id + departure;

  @override
  int compareTo(bus) {
    return this.offseted.compareTo(bus.offseted);
  }

  @override
  String toString() {
    return "{id: $id, departure: $departure, offseted: $offseted}";
  }

  bool validTime(int time) {
    return (time + departure) % id == 0;
  }
}

void main(List<String> args) async {
  String input = await readInput(2020, 13);
  _solvePartOneAndTwo(input);
}

void _solvePartOneAndTwo(String input) {
  Notes notes = getNotes(input);
  int earliestBusID = getEarliestBusID(notes);
  print("Part 1: Earliest bus ID = $earliestBusID");
  int earliestTime = earliestTimestamp(notes);
  print("Part 2 Earliest timestmap = $earliestTime");
}

Notes getNotes(String input) {
  List<String> lines = input.split("\n");
  int earliestDeparture = int.parse(lines[EARLIEST_TIMESTAMP_INDEX]);
  List<int> busesIDs = List();
  List<Bus> buses = List();
  int departure = 0;
  for (String busID in lines[BUSES_ID_INDEX].split(",")) {
    if (busID != "x") {
      int id = int.parse(busID);
      busesIDs.add(id);
      buses.add(Bus(id, departure));
    }
    departure++;
  }
  buses.sort();
  return Notes(earliestDeparture, busesIDs, buses);
}

int getEarliestBusID(Notes notes) {
  int time = notes.earliestDepart;
  for (;; time++) {
    for (int busID in notes.busIDs) {
      if (time % busID == 0) {
        return (time - notes.earliestDepart) * busID;
      }
    }
  }
}

int earliestTimestamp(Notes notes) {
  int time = notes.earliestDepart;
  int busIndex = 0;
  int increase = 1;
  do {
    Bus bus = notes.buses[busIndex];
    if (bus.validTime(time)) {
      busIndex++;
      increase *= bus.
    }
    time += increase;
  } while (busIndex < notes.buses.length);
}

int maxTimestamp(int time, Notes notes) {
  int maxTime = time;
  for (Bus bus in notes.buses) {
    int offset = notes.buses.first.departure - bus.departure;
    if ((time - offset) > maxTime) maxTime = time - offset;
  }
  return maxTime;
}
