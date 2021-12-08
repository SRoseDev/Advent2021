import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:math';

void main() async {
  // get input
  final file = File('Day8/input.txt');
  Stream<String> lines = file.openRead()
      .transform(utf8.decoder)       // Decode bytes to UTF-8.
      .transform(LineSplitter());    // Convert stream to individual lines.
  // parse inputs into tuples of direction and position
  List<List<String>> inputs = [];
  try {
    await for (var line in lines) {
      inputs.add(line.split('|'));
    }
    print('File is now closed.');
  } catch (e) {
    print('Error: $e');
  }
  part1(inputs);
  part2(inputs);

}

void part1(List<List<String>> inputs) {
  // count all the segments in the second index with lengths of 2, 3, 4, or 7
  var uniqueLengths = [2,3,4,7];
  var count = 0;
  for(var input in inputs) {
    var output = input[1].trim().split(' ');
    for(var o in output){
      if (uniqueLengths.contains(o.length)){
        count++;
      }
    }
  }
  print(count);
}

void part2(List<List<String>> inputs) {
  var total = 0;
  for(var input in inputs) {
    var digits = input[0].trim().split(' ');
    var outputs = input[1].trim().split(' ');
    // find the 4 unique segments
    var mapping = List.generate(10, (index) => '');
    mapping[1] = digits.firstWhere((element) => element.length == 2);
    mapping[4] = digits.firstWhere((element) => element.length == 4);
    mapping[7] = digits.firstWhere((element) => element.length == 3);
    mapping[8] = digits.firstWhere((element) => element.length == 7);

    // 3 is length 5 and overlaps 1
    mapping[3] = digits.firstWhere((element) =>
      element.length == 5 && element.split('').toSet().containsAll(mapping[1].split('')));

    // 9 is length 6 and overlaps 3
    mapping[9] = digits.firstWhere((element) =>
      element.length == 6 && element.split('').toSet().containsAll(mapping[3].split('')));

    // 0 is length 6, overlaps 1 and 7, and is not 9
    mapping[0] = digits.firstWhere((element) =>
      element.length == 6
          && element.split('').toSet().containsAll(mapping[1].split(''))
          && element.split('').toSet().containsAll(mapping[7].split(''))
          && element != mapping[9]);

    // 6 is length 6 and is not 0 or 9
    mapping[6] = digits.firstWhere((element) =>
    element.length == 6
        && element != mapping[0]
        && element != mapping[9]);

    // 5 is length 5 and is overlapped by 6
    mapping[5] = digits.firstWhere((element) =>
      element.length == 5 && mapping[6].split('').toSet().containsAll(element.split('')));

    // 2 is length 5 and is not 3 or 5
    mapping[2] = digits.firstWhere((element) =>
    element.length == 5
        && element != mapping[3]
        && element != mapping[5]);

    // all elements are mapped, see what the 4 output digits are
    var outputTotal = '';
    for(var digit in outputs){
      outputTotal += mapping.indexWhere((element) =>
          element.length == digit.length
          && element.split('').toSet().containsAll(digit.split(''))).toString();
    }
    // convert the built string into an int and add it to the running total
    total += int.parse(outputTotal);
  }

  print(total);
}