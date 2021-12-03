import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:sortedmap/sortedmap.dart';

void main() async {
  // get input
  final file = File('Day3/input.txt');
  Stream<String> lines = file.openRead()
      .transform(utf8.decoder)       // Decode bytes to UTF-8.
      .transform(LineSplitter());    // Convert stream to individual lines.
  // parse inputs into tuples of direction and position
  List<String> inputs = [];
  try {
    await for (var line in lines) {
      inputs.add(line);
    }
    print('File is now closed.');
  } catch (e) {
    print('Error: $e');
  }

  part1(inputs);
  part2(inputs);

}

void part1(List<String> inputs) {
  // Add 1 to value if digit is a 1.
  // If the value if more than half the list size a 1 occurred more
  // Use a sorted map so the count index lines up with the binary string index
  // when iterating
  Map<int, int> counts = SortedMap(Ordering.byKey());
  for (String input in inputs) {
    for (var i = 0; i<input.length; i++){
      if(input[i] == '1'){
        // default to 0 if map value is null
        counts[i] = (counts[i] ?? 0)+1;
      } else {
        counts[i] = (counts[i] ?? 0)-1;
      }
    }
  }
  // build binary string
  var gamma = '';
  var epsilon = '';
  counts.forEach((key, value) {
    if(value >= 0){
      gamma += '1';
      epsilon += '0';
    } else {
      gamma += '0';
      epsilon += '1';
    }
  });

  var gammaDecimal = int.parse(gamma, radix: 2);
  var epsilonDecimal = int.parse(epsilon, radix: 2);

  print(gammaDecimal * epsilonDecimal);
}

void part2(List<String> inputs) {
  final oxygen = getOxygen([...inputs]);
  final co2 = getCO2([...inputs]);
  print(oxygen * co2);
}

int getOxygen(List<String> inputs){
  // Add 1 to value if digit is a 1.
  // If the value if more than half the list size a 1 occurred more
  // Use a sorted map so the count index lines up with the binary string index
  // when iterating
  var currentIndex = 0;
  while(inputs.length > 1) {
    var currentCount = 0;
    for (String input in inputs) {
      if (input[currentIndex] == '1') {
        // default to 0 if map value is null
        currentCount++;
      } else {
        currentCount--;
      }
    }
    var expectedCharacter = '1';
    if(currentCount < 0){
      expectedCharacter = '0';
    }
    inputs = inputs.where((element) => element[currentIndex] == expectedCharacter).toList();
    currentIndex++;
  }
  //only 1 value left, it's the oxygen
  return int.parse(inputs[0], radix: 2);
}

int getCO2(List<String> inputs){
  // Add 1 to value if digit is a 1.
  // If the value if more than half the list size a 1 occurred more
  // Use a sorted map so the count index lines up with the binary string index
  // when iterating
  var currentIndex = 0;
  while(inputs.length > 1) {
    var currentCount = 0;
    for (String input in inputs) {
      if (input[currentIndex] == '1') {
        // default to 0 if map value is null
        currentCount++;
      } else {
        currentCount--;
      }
    }
    var expectedCharacter = '0';
    if(currentCount < 0){
      expectedCharacter = '1';
    }
    inputs = inputs.where((element) => element[currentIndex] == expectedCharacter).toList();
    currentIndex++;
  }
  //only 1 value left, it's the oxygen
  return int.parse(inputs[0], radix: 2);
}