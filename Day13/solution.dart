import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:tuple/tuple.dart';

void main() async {
  // get input
  final file = File('Day13/input.txt');
  Stream<String> lines = file.openRead()
      .transform(utf8.decoder)       // Decode bytes to UTF-8.
      .transform(LineSplitter());    // Convert stream to individual lines.
  // parse inputs into tuples of direction and position
  List<Tuple2<int, int>> dots = [];
  List<Tuple2<String, int>> folds = [];
  try {
    await for (var line in lines) {
      if(line.contains(',')){
        // dot
        var parts = line.split(',');
        dots.add(Tuple2(int.parse(parts[0]), int.parse(parts[1])));
      } else if(line.startsWith('fold')){
        // fold
        var parts = line.split(' ')[2].split('=');
        folds.add(Tuple2(parts[0], int.parse(parts[1])));
      }

    }
    print('File is now closed.');
  } catch (e) {
    print('Error: $e');
  }

  var part1 = doFolds(dots.toSet(), [folds.first]);
  print(part1.length);
  var part2 = doFolds(dots.toSet(), folds);
  printDots(part2);
}

Set<Tuple2<int, int>> doFolds(Set<Tuple2<int, int>> dots, List<Tuple2<String, int>> folds) {
  for(var fold in folds){
    if(fold.item1 == 'y'){
      // horizontal fold
      var foldPosition = fold.item2;
      // get all dots with y > fold position
      var toMove = dots.where((element) => element.item2 > foldPosition).toList();
      // remove them from the old list
      dots.removeAll(toMove);
      // set new y value to foldPosition - (currentY - foldPosition)
      toMove = toMove.map((e) => Tuple2(e.item1, foldPosition - (e.item2 - foldPosition))).toList();
      // add them back in the new positions
      dots.addAll(toMove);
    } else {
      // vertical fold
      var foldPosition = fold.item2;
      // get all dots with x > fold position
      var toMove = dots.where((element) => element.item1 > foldPosition).toList();
      // remove them from the old list
      dots.removeAll(toMove);
      // set new x value to foldPosition - (currentX - foldPosition)
      toMove = toMove.map((e) => Tuple2(foldPosition - (e.item1 - foldPosition), e.item2)).toList();
      // add them back in the new positions
      dots.addAll(toMove);
    }
  }

  return dots;
}

void printDots(Set<Tuple2<int, int>> dots){
  // get max X and Y
  var maxX = 0;
  var maxY = 0;
  for(var dot in dots){
    maxX = max(dot.item1, maxX);
    maxY = max(dot.item2, maxY);
  }
  print('$maxX, $maxY');
  for(var y = 0; y <= maxY; y++){
    var thisLine = '';
    for(var x = 0; x <= maxX; x++){
      var thisDot = Tuple2(x, y);
      if(dots.contains(thisDot)){
        thisLine += '#';
      } else {
        thisLine += ' ';
      }
    }
    print(thisLine);
  }
}