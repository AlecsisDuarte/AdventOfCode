import 'dart:io';

import '../utils/input_reader.dart';

RegExp logRegex = new RegExp(r"(\d*)-(\d*)-(\d*)\ (\d*):(\d*).+?(\d+|f|w)");
var datetimeGroupList = [1,2,3,4,5];

void main() async {
  File input = InputReader.openInputFile('Day4', 'input.txt');
  if (!await input.exists()) {
    print('File not found');
    return;
  }

  input
    .readAsLines()
    .then((lines) {
      var sleepTimes = getSleepTimes(lines);
      getStrategy(sleepTimes)
      .then((strategy) => print('Strategy: $strategy'));
    });

}


Map<int,Times> getSleepTimes(List<String> logs) {
  var records = Map<int,String>();
  logs.forEach((log) {
    var logMatch = logRegex.firstMatch(log);
    int dateTime = int.parse(logMatch.groups(datetimeGroupList).reduce((line, part) => line += part));
    String info = logMatch.group(6);

    records.putIfAbsent(dateTime, () => info);
  });

  var sleepTimes = Map<int,Times>();
  var timeStamps = records.keys.toList();

  for(int index = 0; index < timeStamps.length; index++) {
    int timeStamp = timeStamps[index];
    int guard = int.parse(records[timeStamp]);
    do {
      int initSleepTime = timeStamps[++index];
      int wakeTime = timeStamps[++index];
      for(int sleepTime = initSleepTime; sleepTime < wakeTime; sleepTime++) {
        sleepTimes.update(
          sleepTime, 
          (update) { ++update.times; },
          ifAbsent: () => Times(guard, 1));
      }
    } while(index + 1 < timeStamps.length && records[timeStamps[index + 1]] == 'f');
  }
  
  return sleepTimes;
}

Future<int> getStrategy(Map<int, Times> sleepTimes) async {
  int minute = 0;

  Times maxTime = sleepTimes.values.reduce((maxTime, time) => maxTime = maxTime.times > time.times? maxTime : time);
  sleepTimes.forEach((dt,time){
    if (time == maxTime) {
      minute = (dt % 100);
      return;
    }
  });

  return minute * maxTime.guard;
}

class Times {
  int guard;
  int times;

  Times(this.guard, this.times);
}