import 'dart:async';
import 'dart:convert';
import 'dart:io';

import "package:collection/collection.dart";

void main() async {
  // get input
  final file = File('Day12/input.txt');
  Stream<String> lines = file.openRead()
      .transform(utf8.decoder)       // Decode bytes to UTF-8.
      .transform(LineSplitter());    // Convert stream to individual lines.
  // parse inputs into tuples of direction and position
  Map<String, List<String>> inputs = Map();
  try {
    await for (var line in lines) {
      var parts = line.split('-');
      inputs[parts[0]] = [...(inputs[parts[0]] ?? []), parts[1]];
      inputs[parts[1]] = [...(inputs[parts[1]] ?? []), parts[0]];
    }
    print('File is now closed.');
  } catch (e) {
    print('Error: $e');
  }

  part1(inputs);
  part2(inputs);
}

void part1(Map<String, List<String>> inputs) {
  // build each starting path
  Set<List<String>> paths = Set();
  final String invalidTerminator = 'invalid';
  final String start = 'start';
  final String end = 'end';
  for(var s in inputs[start]){
    paths.add([start, s]);
  }
  // search until all paths are found
  while(paths.any((element) => element.last != 'end')) {
    //filter out invalid paths
    paths = paths.toList().where((element) => element.last != invalidTerminator).toSet();
    // iterate each path, add each new possible branch
    Set<List<String>> newPaths = Set();
    for(var path in paths) {
      // check for terminators
      if(path.last == invalidTerminator || path.last == end){
        continue;
      }
      // get key for branches
      var key = path.last;
      if(inputs.containsKey(key)) {
        for (var branch in inputs[key]) {
          // add new paths
          if (branch == branch.toUpperCase()) {
            // we can visit uppercase caves multiple times
            newPaths.add([...path, branch]);
          } else {
            //only visit if we haven't been there yet
            if (!path.contains(branch)) {
              newPaths.add([...path, branch]);
            }
          }
        }
      }
      // set parent branch for pruning
      path.add(invalidTerminator);
    }
    paths.addAll(newPaths);
  }
  print(paths.length);
}

void part2(Map<String, List<String>> inputs) {
  // build each starting path
  Set<List<String>> paths = Set();
  final String invalidTerminator = 'invalid';
  final String start = 'start';
  final String end = 'end';
  for(var s in inputs[start]){
    paths.add([start, s]);
  }
  // search until all paths are found
  while(paths.any((element) => element.last != 'end')) {
    //filter out invalid paths
    paths = paths.toList().where((element) => element.last != invalidTerminator).toSet();
    // iterate each path, add each new possible branch
    Set<List<String>> newPaths = Set();
    for(var path in paths) {
      // check for terminators
      if(path.last == invalidTerminator || path.last == end){
        continue;
      }
      // get key for branches
      var key = path.last;
      if(inputs.containsKey(key)) {
        for (var branch in inputs[key]) {
          // add new paths
          if(branch == start){
            // cannot revisit the start
            continue;
          } else if (branch == branch.toUpperCase()) {
            // we can visit uppercase caves multiple times
            newPaths.add([...path, branch]);
          } else {
            //can definitely visit if we haven't been there yet
            if (!path.contains(branch)) {
              newPaths.add([...path, branch]);
            } else {
              // we can visit if we have only been to this cave once and there are no duplicates in the path already
              if(path.where((element) => element == branch).length == 1){
                // we have only been to this cave one before, check for other small cave duplicates
                //count frequencies of all elements by grouping them and checking length of list
                var frequencies = groupBy(path, (String value) => value);
                // for duplicates, see if they are small caves
                var canAdd = true;
                frequencies.forEach((key, value) {
                  if(value.length > 1){
                    //check if this is a small cave
                    if(key != key.toUpperCase()){
                      // small cave duplicate, can't add another
                      canAdd = false;
                    }
                  }
                });
                if(canAdd){
                  newPaths.add([...path, branch]);
                }
              }
            }
          }
        }
      }
      // set parent branch for pruning
      path.add(invalidTerminator);
    }
    paths.addAll(newPaths);
  }
  print(paths.length);
}