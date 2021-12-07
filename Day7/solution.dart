import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:math';

void main() async {
  // get input
  final file = File('Day7/input.txt');
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
  part1(inputs);
  part2(inputs);

}

void part1(List<int> inputs) {
  var minPosition = inputs.reduce(min);
  var maxPosition = inputs.reduce(max);
  print(minPosition);
  print(maxPosition);
  // no built in maxInt :sadpanda:
  var best = 0x7fffffffffffffff;
  for(var pos = minPosition; pos <= maxPosition; pos++){
    best = min(best, inputs.map((value) => ((value - pos).abs()))
      .reduce((value, element) => value + element));
  }
  print(best);
}

void part2(List<int> inputs) {
  var minPosition = inputs.reduce(min);
  var maxPosition = inputs.reduce(max);
  print(minPosition);
  print(maxPosition);
  // no built in maxInt :sadpanda:
  var best = 0x7fffffffffffffff;
  for(var pos = minPosition; pos <= maxPosition; pos++){
    best = min(best, inputs.map((value) => (sumFuelForRange((value - pos).abs() ?? 0)))
        .reduce((value, element) => value + element));
  }
  print(best);
}

int sumFuelForRange(int range){
  if(range == 0)
    return 0;

  var r = List.generate(range, (int v) => v+1);
  return r.reduce((value, element) => value+element);
}