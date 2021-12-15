import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

void main() async {
  // get input
  final file = File('Day14/input.txt');
  Stream<String> lines = file.openRead()
      .transform(utf8.decoder)       // Decode bytes to UTF-8.
      .transform(LineSplitter());    // Convert stream to individual lines.
  // parse inputs into tuples of direction and position
  String template = '';
  Map<String, String> insertions = Map();
  try {
    await for (var line in lines) {
      if(line.contains(' -> ')){
        // insertion
        var parts = line.split(' -> ');
        insertions[parts[0]] = parts[1];
      } else if(line.isNotEmpty){
        // template
        template = line;
      }

    }
    print('File is now closed.');
  } catch (e) {
    print('Error: $e');
  }

  var part1Template = doInsertions(template, insertions, 10);
  calculatePolymer(part1Template);
  var part2Template = doInsertions(template, insertions, 40);
  calculatePolymer(part2Template);

}

Map<String, int> doInsertions(String startingTemplate, Map<String, String> insertions, int count) {
  // hold count of each pair
  Map<String, int> pairs = Map();
  for(var j=0; j<startingTemplate.length-1; j++){
    var key = '${startingTemplate[j]}${startingTemplate[j+1]}';
    pairs[key] = (pairs[key] ?? 0) + 1;
  }
  for(var i = 0; i< count; i++){
    // hold the newly built pairs list
    Map<String, int> newPairs = Map();
    // for each pair, do insertion
    pairs.forEach((key, value) {
      // get the 2 new keys
      var key1 = '${key[0]}${insertions[key]}';
      var key2 = '${insertions[key]}${key[1]}';
      // insert the 2 new keys
      newPairs[key1] = (newPairs[key1] ?? 0) + value;
      newPairs[key2] = (newPairs[key2] ?? 0) + value;
    });
    // set current template to the new template
    pairs = newPairs;
  }
  return pairs;
}

void calculatePolymer(Map<String, int> pairs){
  // get most and least occurring element
  Map<String, int> counts = Map();
  // only count the last element to avoid double counting the overlaps
  pairs.forEach((key, value) {
    counts[key[1]] = (counts[key[1]] ?? 0) + value;
  });
  // find lowest and highest frequencies in map
  int lowest = 9223372036854775807; //max int
  int highest = 0;
  print(counts);
  counts.forEach((key, value) {
    lowest = min(lowest, value);
    highest = max(highest, value);
  });

  print(highest - lowest);
}