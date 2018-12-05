/**
  --- Day 4: Repose Record ---
  You've sneaked into another supply closet - this time, it's across from the prototype suit manufacturing lab. 
  You need to sneak inside and fix the issues with the suit, but there's a guard stationed outside the lab, so 
  this is as close as you can safely get.

  As you search the closet for anything that might help, you discover that you're not the first person to want 
  to sneak in. Covering the walls, someone has spent an hour starting every midnight for the past few months 
  secretly observing this guard post! They've been writing down the ID of the one guard on duty that night - the 
  Elves seem to have decided that one guard was enough for the overnight shift - as well as when they fall 
  asleep or wake up while at their post (your puzzle input).

  For example, consider the following records, which have already been organized into chronological order:

  [1518-11-01 00:00] Guard #10 begins shift
  [1518-11-01 00:05] falls asleep
  [1518-11-01 00:25] wakes up
  [1518-11-01 00:30] falls asleep
  [1518-11-01 00:55] wakes up
  [1518-11-01 23:58] Guard #99 begins shift
  [1518-11-02 00:40] falls asleep
  [1518-11-02 00:50] wakes up
  [1518-11-03 00:05] Guard #10 begins shift
  [1518-11-03 00:24] falls asleep
  [1518-11-03 00:29] wakes up
  [1518-11-04 00:02] Guard #99 begins shift
  [1518-11-04 00:36] falls asleep
  [1518-11-04 00:46] wakes up
  [1518-11-05 00:03] Guard #99 begins shift
  [1518-11-05 00:45] falls asleep
  [1518-11-05 00:55] wakes up

  Timestamps are written using year-month-day hour:minute format. The guard falling asleep or waking up is always
  the one whose shift most recently started. Because all asleep/awake times are during the midnight hour 
  (00:00 - 00:59), only the minute portion (00 - 59) is relevant for those events.
  ote that guards count as asleep on the minute they fall asleep, and they count as awake on the minute they wake
  up. For example, because Guard #10 wakes up at 00:25 on 1518-11-01, minute 25 is marked as awake.

  If you can figure out the guard most likely to be asleep at a specific time, you might be able to trick that 
  guard into working tonight so you can have the best chance of sneaking in. You have two strategies for choosing 
  the best guard/minute combination.

  Strategy 1: Find the guard that has the most minutes asleep. What minute does that guard spend asleep the most?

  In the example above, Guard #10 spent the most minutes asleep, a total of 50 minutes (20+25+5), while Guard #99 
  only slept for a total of 30 minutes (10+10+10). Guard #10 was asleep most during minute 24 (on two days, whereas 
  any other minute the guard was asleep was only seen on one day).

  While this example listed the entries in chronological order, your entries are in the order you found them. 
  You'll need to organize them before they can be analyzed.

  What is the ID of the guard you chose multiplied by the minute you chose? (In the above example, the answer would 
  be 10 * 24 = 240.)

  --- Part Two ---
  Strategy 2: Of all guards, which guard is most frequently asleep on the same minute?

  In the example above, Guard #99 spent minute 45 asleep more than any other guard or minute - three times in total. 
  (In all other cases, any guard spent any minute asleep at most twice.)

  What is the ID of the guard you chose multiplied by the minute you chose?
 */

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

/** Returns the strategy of the guard that slept the most */
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
