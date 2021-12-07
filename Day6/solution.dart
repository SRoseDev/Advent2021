import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:sortedmap/sortedmap.dart';

void main() async {
  // get input
  final file = File('Day6/input.txt');
  Stream<String> lines = file.openRead()
      .transform(utf8.decoder)       // Decode bytes to UTF-8.
      .transform(LineSplitter());    // Convert stream to individual lines.
  // parse inputs into tuples of direction and position
  List<int> inputs = [];
  try {
    await for (var line in lines) {
      inputs = line.split(',').map((e) => int.parse(e)).toList();
    }
    print('File is now closed.');
  } catch (e) {
    print('Error: $e');
  }
  countFishAfterCycles(80, [...inputs]);
  countFishAfterCycles(256, [...inputs]);

}

void countFishAfterCycles(int dayCycles, List<int> inputs) {
  // group fish by days left
  var fishGroups = SortedMap<int, int>();
  for(var f in inputs){
    fishGroups[f] = (fishGroups[f] ?? 0) + 1;
  }
  // do cycles
  for(var cycle = 0; cycle<dayCycles; cycle++) {
    // count how many will spawn new fish
    var newFish = fishGroups[0] ?? 0;
    // shift map counts
    for (var i = 1; i <= 8; i++) {
      fishGroups[i - 1] = fishGroups[i];
    }
    // add new fish that spawns
    fishGroups[8] = newFish;
    // reset the fish that were at 0 to 6
    fishGroups[6] = (fishGroups[6] ?? 0) + newFish;
  }
  // sum the fish
  var count = 0;
  for(var i=0; i<=8; i++){
    count+=fishGroups[i];
  }
  print(count);
}