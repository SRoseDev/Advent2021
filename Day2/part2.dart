import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:tuple/tuple.dart';

void main() async {
  // get input
  final file = File('Day2/input.txt');
  Stream<String> lines = file.openRead()
      .transform(utf8.decoder)       // Decode bytes to UTF-8.
      .transform(LineSplitter());    // Convert stream to individual lines.
  List<Tuple2<String, int>> inputs = [];
  // parse inputs into tuples of direction and position
  try {
    await for (var line in lines) {
      var parts = line.split(' ');
      inputs.add(Tuple2(parts.first, int.parse(parts.last)));
    }
    print('File is now closed.');
  } catch (e) {
    print('Error: $e');
  }
  // move the sub
  var posX = 0;
  var posY = 0;
  var aim = 0;
  for(var input in inputs) {
    switch(input.item1){
      case 'forward':
        posX += input.item2;
        posY += input.item2 * aim;
        break;
      case 'up':
        aim -= input.item2;
        break;
      case 'down':
        aim += input.item2;
        break;
    }
  }
  print(posX * posY);
}
