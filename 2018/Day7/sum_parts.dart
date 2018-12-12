/**
  --- Day 7: The Sum of Its Parts ---
  You find yourself standing on a snow-covered coastline; apparently, you landed a little off course. 
  The region is too hilly to see the North Pole from here, but you do spot some Elves that seem to be 
  trying to unpack something that washed ashore. It's quite cold out, so you decide to risk creating a 
  paradox by asking them for directions.

  "Oh, are you the search party?" Somehow, you can understand whatever Elves from the year 1018 speak; 
  you assume it's Ancient Nordic Elvish. Could the device on your wrist also be a translator? "Those 
  clothes don't look very warm; take this." They hand you a heavy coat.

  "We do need to find our way back to the North Pole, but we have higher priorities at the moment. 
  You see, believe it or not, this box contains something that will solve all of Santa's 
  transportation problems - at least, that's what it looks like from the pictures in the instructions." 
  It doesn't seem like they can read whatever language it's in, but you can: "Sleigh kit. Some assembly 
  required."

  "'Sleigh'? What a wonderful name! You must help us assemble this 'sleigh' at once!" They start 
  excitedly pulling more parts out of the box.

  The instructions specify a series of steps and requirements about which steps must be finished 
  before others can begin (your puzzle input). Each step is designated by a single letter. 
  For example, suppose you have the following instructions:

  Step C must be finished before step A can begin.
  Step C must be finished before step F can begin.
  Step A must be finished before step B can begin.
  Step A must be finished before step D can begin.
  Step B must be finished before step E can begin.
  Step D must be finished before step E can begin.
  Step F must be finished before step E can begin.
  Visually, these requirements look like this:


    -->A--->B--
  /    \      \
  C      -->D----->E
  \           /
    ---->F-----
  Your first goal is to determine the order in which the steps should be completed. 
  If more than one step is ready, choose the step which is first alphabetically. 
  In this example, the steps would be completed as follows:

  Only C is available, and so it is done first.
  Next, both A and F are available. A is first alphabetically, so it is done next.
  Then, even though F was available earlier, steps B and D are now also available, and B is the 
  first alphabetically of the three.
  After that, only D and F are available. E is not available because only some of its 
  prerequisites are complete. Therefore, D is completed next.
  F is the only choice, so it is done next.
  Finally, E is completed.
  So, in this example, the correct order is CABDFE.

  In what order should the steps in your instructions be completed?
  

  --- Part Two ---
  As you're about to begin construction, four of the Elves offer to help. "The sun will set soon; 
  it'll go faster if we work together." Now, you need to account for multiple people working on 
  steps simultaneously. If multiple steps are available, workers should still begin them in 
  alphabetical order.

  Each step takes 60 seconds plus an amount corresponding to its letter: A=1, B=2, C=3, and so on. 
  So, step A takes 60+1=61 seconds, while step Z takes 60+26=86 seconds. No time is required 
  between steps.

  To simplify things for the example, however, suppose you only have help from one Elf (a total of 
  two workers) and that each step takes 60 fewer seconds (so that step A takes 1 second and 
  step Z takes 26 seconds). Then, using the same instructions as above, this is how each second 
  would be spent:

  Second   Worker 1   Worker 2   Done
    0        C          .        
    1        C          .        
    2        C          .        
    3        A          F       C
    4        B          F       CA
    5        B          F       CA
    6        D          F       CAB
    7        D          F       CAB
    8        D          F       CAB
    9        D          .       CABF
    10        E          .       CABFD
    11        E          .       CABFD
    12        E          .       CABFD
    13        E          .       CABFD
    14        E          .       CABFD
    15        .          .       CABFDE
  Each row represents one second of time. The Second column identifies how many seconds have passed as 
  of the beginning of that second. Each worker column shows the step that worker is currently doing 
  (or . if they are idle). The Done column shows completed steps.

  Note that the order of the steps has changed; this is because steps now take time to finish and 
  multiple workers can begin multiple steps simultaneously.

  In this example, it would take 15 seconds for two workers to complete these steps.

  With 5 workers and the 60+ second step durations described above, how long will it take to complete 
  all of the steps?
 */
import 'dart:io';

import '../utils/input_reader.dart';

RegExp stepRegex = RegExp(r'Step\ (\w).*?step\ (\w)');
const int WORKERS = 5;
const int STEP_DURATION = 60;

void main() async {
  File input = InputReader.openInputFile('Day7', 'input.txt');
  if (!await input.exists()) {
    print('Input file not found');
    return;
  }

  input.readAsLines().then((lines) {
    getRootNode(lines).then((nodeInfo) {

      nodeInfo.parents.forEach((key, children) =>
          print('Node $key children: ${children.join(',')}'));

      getInstructions(nodeInfo)
          .then((instrct) => print('Instructions: $instrct'));

      getWorkingSeconds(nodeInfo).then((seconds) => print('Seconds: $seconds'));
    });
  });
}

class NodesInformation {
  Map<String, List<String>> parents;
  Map<String, int> references;
  NodesInformation(this.parents, this.references);
}

class Worker {
  int index;
  String step;
  int workingTime;
  Worker(this.index, this.workingTime);
}

/** Returns information like the fathers and their children but also 
 * the times the children are being referenced
 */
Future<NodesInformation> getRootNode(List<String> lines) async {
  Map<String, List<String>> parents = Map<String, List<String>>();
  Map<String, int> references = Map<String, int>();

  for (final String line in lines) {
    final Match match = stepRegex.firstMatch(line);
    String value = match.group(1);
    String childValue = match.group(2);

    parents.update(value, (children) {
      children.add(childValue);
      return children;
    }, ifAbsent: () {
      var children = List<String>();
      children.add(childValue);
      return children;
    });

    references.update(childValue, (references) {
      return ++references;
    }, ifAbsent: () => 1);
  }

  return NodesInformation(parents, references);
}

/** Returns the way the instructions should be done */
Future<String> getInstructions(NodesInformation nodeInfo) async {
  var instruction = '';
  var available = List<String>();
  NodesInformation nodes = NodesInformation(
      Map.from(nodeInfo.parents), Map.from(nodeInfo.references));

  for (final String key in nodes.parents.keys) {
    if (nodes.references[key] == null) {
      nodes.references[key] = 0;
      available.add(key);
    }
  }

  available.sort((a, b) => a.compareTo(b));

  while (available.length > 0) {
    String node = available.removeAt(0);
    instruction += node;
    nodes.references.remove(node);
    if (nodes.parents.containsKey(node)) {
      bool nodeAdded = false;
      for (String child in nodes.parents[node]) {
        nodes.references[child] -= 1;
        if (nodes.references[child] == 0) {
          available.add(child);
          nodes.references.remove(child);
          nodeAdded = true;
        }
      }
      nodes.parents.remove(node);
      if (nodeAdded) available.sort((a, b) => a.compareTo(b));
    }
  }
  return instruction;
}

/** Returns the time in seconds that it would take to finish the steps */
Future<int> getWorkingSeconds(NodesInformation nodeInfo) async {
  List<Worker> workers = List();
  int ammountWorkers = WORKERS;
  while (--ammountWorkers >= 0) workers.add(Worker(ammountWorkers, 0));

  var available = List<String>();
  NodesInformation nodes = NodesInformation(
      Map.from(nodeInfo.parents), Map.from(nodeInfo.references));

  for (final String key in nodes.parents.keys) {
    if (nodes.references[key] == null) {
      nodes.references[key] = 0;
      available.add(key);
    }
  }

  available.sort((a, b) => a.compareTo(b));
  int workSeconds = 0;

  while (available.length > 0 || noOneIsWorking(workers)) {
    if (workersAvailable(workers)) {
      for (Worker worker in workers.where((w) => w.workingTime == 0)) {
        if (available.length == 0) break;
        String node = available.removeAt(0);
        worker.workingTime = node.codeUnitAt(0) - 64 + STEP_DURATION;
        worker.step = node;
        nodes.references.remove(node);
      }
    }

    for (Worker w in workers) {
      if (w.step != null) {
        if (--w.workingTime == 0) {
          String node = w.step;
          w.step = null;
          if (nodes.parents.containsKey(node)) {
            bool nodeAdded = false;
            for (String child in nodes.parents[node]) {
              nodes.references[child] -= 1;
              if (nodes.references[child] == 0) {
                available.add(child);
                nodes.references.remove(child);
                nodeAdded = true;
              }
            }
            nodes.parents.remove(node);
            if (nodeAdded) available.sort((a, b) => a.compareTo(b));
          }
        }
      }
    }
    ++workSeconds;
  }

  return workSeconds;
}

/** Validate wheter there is a free worker */
bool workersAvailable(List<Worker> workers) {
  return workers.any((w) => w.workingTime == 0);
}

/** Validates whether there is or not no one working */
bool noOneIsWorking(List<Worker> workers) {
  return workers.any((w) => w.workingTime > 0);
}
