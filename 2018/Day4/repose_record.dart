import 'dart:collection';
import 'dart:io';

import '../utils/input_reader.dart';

RegExp logRegex = new RegExp(r"(\d*)-(\d*)-(\d*)\ (\d*):(\d*).+?(\d+|f|w)");
var datetimeGroupList = [1, 2, 3, 4, 5];

void main() async {
  File input = InputReader.openInputFile('Day4', 'input.txt');
  if (!await input.exists()) {
    print('File not found');
    return;
  }

  input.readAsLines().then((lines) {
    var sleepTimes = getSleepTimes(lines);
    getStrategy(Map.from(sleepTimes)).then((strategy) => print(
        'Strategy for the guard that slept more than any other: $strategy'));

    getMoreSleptsInMinute(Map.from(sleepTimes)).then((strategy) => print(
        'Strategy for the guard that slept more in the same minute: $strategy'));
  });
}

/** Returns how many times the guards slept in each hour:minute */
Map<String, Times> getSleepTimes(List<String> logs) {
  var recordsList = List<LogInfo>();
  logs.forEach((log) {
    var logMatch = logRegex.firstMatch(log);
    int dateTime = int.parse(logMatch
        .groups(datetimeGroupList)
        .reduce((line, part) => line += part));
    String info = logMatch.group(6);
    recordsList.add(LogInfo(dateTime, info));
  });

  recordsList.sort((a, b) => a.datetime.compareTo(b.datetime));
  var sleepTimes = Map<String, Times>();

  for (int index = 0; index < recordsList.length; index++) {
    int guard = int.parse(recordsList[index].info);
    if (index < recordsList.length - 2 && recordsList[index + 1].info == 'f') {
      do {
        int hourMinSleep = recordsList[++index].datetime % 10000;
        int hourMinWake = recordsList[++index].datetime % 10000;

        for (int sleepTime = hourMinSleep;
            sleepTime != hourMinWake;
            sleepTime++) {
          if (sleepTime == 2359) sleepTime = 0;
          sleepTimes.update(
              "$sleepTime-$guard", (time) => Times(guard, time.times + 1),
              ifAbsent: () => Times(guard, 1));
        }
      } while (
          index + 1 < recordsList.length && recordsList[index + 1].info == 'f');
    }
  }

  return sleepTimes;
}

Future<int> getStrategy(Map<String, Times> sleepTimes) async {
  int minute = 0;
  var guardSleepTime = Map<int, int>();

  sleepTimes.values.forEach((guardTimes) => guardSleepTime.update(
      guardTimes.guard, (timeSlept) => timeSlept += guardTimes.times,
      ifAbsent: () => guardTimes.times));

  int maxSleepingGuard =
      guardSleepTime.values.reduce((max, cur) => max = max > cur ? max : cur);

  int guard = guardSleepTime.entries
      .where((gs) => gs.value == maxSleepingGuard)
      .first
      .key;

  String guardTimeInfo = "";

  final String strGuard = guard.toString();

  sleepTimes.removeWhere((timeGuard, times) => !timeGuard.endsWith(strGuard));

  var maxSleepTimes = sleepTimes.values.reduce((maxTimes, times) =>
      maxTimes = maxTimes.times > times.times ? maxTimes : times);

  sleepTimes.forEach((time, times) {
    if (times == maxSleepTimes) {
      guardTimeInfo = time;
    }
  });

  var time = guardTimeInfo.split('-')[0];
  minute = int.parse(time.length > 1 ? time.substring(time.length - 2) : time);

  return minute * guard;
}

/** Returns the result for the guard that slept more times in the same minute */
Future<int> getMoreSleptsInMinute(Map<String, Times> sleepTimes) async {
  Times maxSleptGuardTimes = sleepTimes.values
      .reduce((max, curr) => max = max.times > curr.times ? max : curr);
  String guardTimestamp = '';
  sleepTimes.removeWhere((guardTime, times) => times != maxSleptGuardTimes);
  sleepTimes.forEach((guardTime, times) => guardTimestamp = guardTime);

  var time = guardTimestamp.split('-')[0];
  var minute =
      int.parse(time.length > 1 ? time.substring(time.length - 2) : time);
  return maxSleptGuardTimes.guard * minute;
}

class Times {
  int guard;
  int times;

  Times(this.guard, this.times);
}

class LogInfo {
  int datetime;
  String info;
  LogInfo(this.datetime, this.info);
}
