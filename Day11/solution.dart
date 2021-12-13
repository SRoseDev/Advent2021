import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:tuple/tuple.dart';

void main() async {
  // get input
  final file = File('Day11/input.txt');
  Stream<String> lines = file.openRead()
      .transform(utf8.decoder)       // Decode bytes to UTF-8.
      .transform(LineSplitter());    // Convert stream to individual lines.
  // parse inputs into tuples of direction and position
  List<List<Octopus>> inputs = [];
  try {
    await for (var line in lines) {
      List<Octopus> octopi = [];
      for(var i=0; i<line.length; i++){
        var octopus = Octopus(int.parse(line[i]), i, inputs.length);
        octopi.add(octopus);
      }
      inputs.add(octopi);
    }
    print('File is now closed.');
  } catch (e) {
    print('Error: $e');
  }

  part1(inputs);
  for(var r in inputs){
    for(var o in r){
      o.reset();
    }
  }
  part2(inputs);
}

class Octopus {
  int _initialEnergy;
  int energy;
  int x;
  int y;
  bool _canFlash = true;

  Octopus(this.energy, this.x, this.y) {
    _initialEnergy = energy;
  }

  void reset() {
    energy = _initialEnergy;
    _canFlash = true;
  }

  // every step gives one energy and resets the ability to flash
  void doStep() {
    _canFlash = true;
    energy += 1;
  }

  bool shouldFlash(){
    return this.energy > 9 && _canFlash;
  }

  // can only flash once per step
  // resets energy to 0
  void flash() {
    _canFlash = false;
    energy = 0;
  }

  // only gain energy if didn't flash this step
  void gotFlashed() {
    if(_canFlash){
      energy += 1;
    }
  }

  // grid is 10x10
  List<Tuple2<int, int>> getAdjacentOctopiLocations() {
    List<Tuple2<int, int>> octopi = [];
    // top left
    if(x>0 && y>0){
      octopi.add(Tuple2(x-1, y-1));
    }
    // top
    if(y>0){
      octopi.add(Tuple2(x, y-1));
    }
    // top Right
    if(x<9 && y>0){
      octopi.add(Tuple2(x+1, y-1));
    }
    // left
    if(x>0){
      octopi.add(Tuple2(x-1, y));
    }
    // right
    if(x<9){
      octopi.add(Tuple2(x+1, y));
    }
    // bottom left
    if(x>0 && y<9){
      octopi.add(Tuple2(x-1, y+1));
    }
    // bottom
    if(y<9){
      octopi.add(Tuple2(x, y+1));
    }
    // bottom Right
    if(x<9 && y<9){
      octopi.add(Tuple2(x+1, y+1));
    }

    return octopi;
  }
}

void part1(List<List<Octopus>> inputs) {
  var flashes = 0;
  for(var step = 0; step < 100; step++){
    // do step for each octopi
    for(var row in inputs){
      for(var octopus in row){
        octopus.doStep();
      }
    }
    // loop until all octopi that should flash have flashed
    List<Octopus> toFlash = [];
    do {
      // clear out previously flashed octopi
      toFlash.clear();
      // check for newly flashed octopi
      for(var row in inputs){
        for(var octopus in row){
          if(octopus.shouldFlash()){
            octopus.flash();
            flashes += 1;
            for(var coords in octopus.getAdjacentOctopiLocations()){
              toFlash.add(inputs[coords.item2][coords.item1]);
            }
          }
        }
      }
      // flash all the octopi who were flashed
      for(var octopus in toFlash){
        octopus.gotFlashed();
      }
    } while (toFlash.isNotEmpty);

  }
  print(flashes);
}

void part2(List<List<Octopus>> inputs) {
  var step = 0;
  var stepFlashed = 0;
  do {
    step++;
    stepFlashed = 0;
    // do step for each octopi
    for(var row in inputs){
      for(var octopus in row){
        octopus.doStep();
      }
    }
    // loop until all octopi that should flash have flashed
    List<Octopus> toFlash = [];
    do {
      // clear out previously flashed octopi
      toFlash.clear();
      // check for newly flashed octopi
      for(var row in inputs){
        for(var octopus in row){
          if(octopus.shouldFlash()){
            octopus.flash();
            stepFlashed += 1;
            for(var coords in octopus.getAdjacentOctopiLocations()){
              toFlash.add(inputs[coords.item2][coords.item1]);
            }
          }
        }
      }
      // flash all the octopi who were flashed
      for(var octopus in toFlash){
        octopus.gotFlashed();
      }
    } while (toFlash.isNotEmpty);

  } while(stepFlashed != 100);

  print(step);
}