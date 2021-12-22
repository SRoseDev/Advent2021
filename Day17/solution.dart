import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

void main() async {
  // get input
  final file = File('Day17/input.txt');
  Stream<String> lines = file.openRead()
      .transform(utf8.decoder)       // Decode bytes to UTF-8.
      .transform(LineSplitter());    // Convert stream to individual lines.

  int targetXStart = 0;
  int targetYStart = 0;
  int targetXEnd = 0;
  int targetYEnd = 0;
  try {
    await for (var line in lines) {
      // split on spaces
      var parts = line.split(' ');
      // get x
      var xParts = parts[2].split('..');
      var x1 = int.parse(xParts[0].substring(2));
      var x2 = int.parse(xParts[1].replaceAll(',', ''));
      // x1 closer to starting point of 0
      if(x1.abs() < x2.abs()){
        targetXStart = x1;
        targetXEnd = x2;
      } else {
        targetXStart = x2;
        targetXEnd = x1;
      }
      targetXStart = min(x1, x2);
      targetXEnd = max(x1, x2);
      // get y
      var yParts = parts[3].split('..');
      var y1 = int.parse(yParts[0].substring(2));
      var y2 = int.parse(yParts[1]);
      if(y1.abs() < y2.abs()){
        targetYStart = y1;
        targetYEnd = y2;
      } else {
        targetYStart = y2;
        targetYEnd = y1;
      }
    }
    print('File is now closed.');
  } catch (e) {
    print('Error: $e');
  }

  print('Target Area: $targetXStart, $targetYStart to $targetXEnd, $targetYEnd');
  part1(targetXStart, targetYStart, targetXEnd, targetYEnd);
  part2(targetXStart, targetYStart, targetXEnd, targetYEnd);
}

void part1(int targetXStart, int targetYStart, int targetXEnd, int targetYEnd) {
  // check a sensible range
  List<Probe> probes = [];
  for(var x = 0; x <= targetXEnd; x++){
    for(var y=0; y < targetYEnd.abs(); y++){
      probes.add(Probe(x, y, targetXStart, targetXEnd, targetYStart, targetYEnd));
    }
  }

  var maxY = 0;
  while(probes.any((element) => !element.isPastTarget())){
    for(var probe in probes){
      if(!probe.isPastTarget()){
        probe.doStep();
        if(probe.isWithinTargetArea()){
          maxY = max(maxY, probe.yMax);
        }
      }
    }
  }

  print('Part1: $maxY');
}

void part2(int targetXStart, int targetYStart, int targetXEnd, int targetYEnd) {
  // check a sensible range
  List<Probe> probes = [];
  for(var x = 0; x <= targetXEnd; x++){
    for(var y=-1*targetYEnd.abs(); y < targetYEnd.abs(); y++){
      probes.add(Probe(x, y, targetXStart, targetXEnd, targetYStart, targetYEnd));
    }
  }

  Set<String> hitTarget = Set();
  while(probes.any((element) => !element.isPastTarget())){
    for(var probe in probes){
      if(!probe.isPastTarget()){
        probe.doStep();
        if(probe.isWithinTargetArea()){
          hitTarget.add(probe.identifier);
        }
      }
    }
  }

  print('Part2: ${hitTarget.length}');
}


class Probe {
  int x = 0;
  int y = 0;
  int xVel;
  int yVel;
  int yMax =0;

  String identifier;

  int targetXStart;
  int targetXEnd;
  int targetYStart;
  int targetYEnd;

  Probe(this.xVel, this.yVel, this.targetXStart, this.targetXEnd, this.targetYStart, this.targetYEnd){
    this.identifier = '$xVel|$yVel';
  }

  void doStep() {
    // apply current velocity
    x += xVel;
    y += yVel;
    // track highest y
    yMax = max(yMax, y);
    // update xVel
    if(xVel != 0){
      if(xVel > 0){
        xVel -= 1;
      } else {
        xVel += 1;
      }
    }
    // update yVel
    yVel -= 1;
  }

  bool isWithinTargetArea() {
    return x >= targetXStart && x <= targetXEnd
        && y <= targetYStart && y >= targetYEnd;
  }
  
  bool isPastTarget() {
    return x > targetXEnd || y < targetYEnd;
  }

}