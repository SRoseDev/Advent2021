import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:tuple/tuple.dart';

void main() async {
  // get input
  final file = File('Day15/input.txt');
  Stream<String> lines = file.openRead()
      .transform(utf8.decoder)       // Decode bytes to UTF-8.
      .transform(LineSplitter());    // Convert stream to individual lines.
  // parse inputs into tuples of direction and position
 List<List<int>> riskMap = [];
  try {
    await for (var line in lines) {
      List<int> thisLine = [];
     for(var i = 0; i< line.length; i++){
       thisLine.add(int.parse(line[i]));
     }
     riskMap.add(thisLine);
    }
    print('File is now closed.');
  } catch (e) {
    print('Error: $e');
  }

  findShortestPathRisk(riskMap);
  var expandedRiskMap = expandRiskMap(riskMap, 5);
  // for(var row in expandedRiskMap){
  //   print(row.join());
  // }
  findShortestPathRisk(expandedRiskMap);

}

List<List<int>> expandRiskMap(List<List<int>> riskMap, int count) {
  List<List<int>> newRiskMap = [];
  // expand right
  for(var y = 0; y < riskMap.length; y++){
    List<int> newRow = [];
    var oldRow = riskMap[y];
    for (var x = 0; x < count; x++) {
      var newValues = oldRow.map((e) => (e + x > 9) ? ((e + x) % 9) : e + x).toList();
      newRow.addAll(newValues);
    }
    newRiskMap.add(newRow);
  }
  // expand down
  List<List<int>> completeRiskMap = [];
  for(var y = 0; y < count; y++){
    for(var row in newRiskMap){
      var newValues = row.map((e) => (e + y > 9) ? ((e + y) % 9) : e + y).toList();
      completeRiskMap.add(newValues);
    }

  }
  return completeRiskMap;
}

void findShortestPathRisk(List<List<int>> riskMap) {
  // create map of weights
  Map<Tuple2<int, int>, int> weights = Map();
  // starting value for weights is maxInt
  for(var y = 0; y < riskMap.length; y++){
    for(var x = 0; x < riskMap[y].length; x++){
      var key = Tuple2(x, y);
      weights[key] = 9223372036854775807; //max int
    }
  }
  // set weight for starting node to 0
  weights[Tuple2(0,0)] = 0;
  // keep track of exhausted nodes
  Set<Tuple2<int, int>> exhaustedNodes = Set();
  Queue<Tuple2<int, int>> toCheck = Queue();
  // add starting node
  toCheck.add(Tuple2(0, 0));
  var isWorking = toCheck.contains(Tuple2(0, 0));
  //populate weights
  while(toCheck.isNotEmpty){
    var node = toCheck.removeFirst();
    var nodeWeight = weights[node];
    // go up
    if(node.item2 > 0) {
      var up = Tuple2(node.item1, node.item2 - 1);
      // add north node to check if it has not been visited
      if (!exhaustedNodes.contains(up) && !toCheck.contains(up)){
        toCheck.add(up);
      }
      // calculate weight for north node
      weights[up] = min(weights[up], nodeWeight + riskMap[node.item2-1][node.item1]);
    }

    // go down
    if(node.item2 < riskMap.length - 1) {
      var down = Tuple2(node.item1, node.item2 + 1);
      // add south node to check if it has not been visited
      if (!exhaustedNodes.contains(down) && !toCheck.contains(down)){
        toCheck.add(down);
      }
      // calculate weight for south node
      weights[down] = min(weights[down], nodeWeight + riskMap[node.item2+1][node.item1]);
    }

    // go left
    if(node.item1 > 0) {
      var left = Tuple2(node.item1 - 1, node.item2);
      // add west node to check if it has not been visited
      if (!exhaustedNodes.contains(left) && !toCheck.contains(left)){
        toCheck.add(left);
      }
      // calculate weight for south node
      weights[left] = min(weights[left], nodeWeight + riskMap[node.item2][node.item1-1]);
    }

    // go right
    if(node.item1 < riskMap[node.item2].length - 1) {
      var right = Tuple2(node.item1 + 1, node.item2);
      // add east node to check if it has not been visited
      if (!exhaustedNodes.contains(right) && !toCheck.contains(right)){
        toCheck.add(right);
      }
      // calculate weight for south node
      weights[right] = min(weights[right], nodeWeight + riskMap[node.item2][node.item1+1]);
    }
    // node has been exhausted, add it to the list
    exhaustedNodes.add(node);
  }
  print('Exhausted node count: ${exhaustedNodes.length}');
  // print bottom corner
  var maxY = riskMap.length - 1;
  var maxX = riskMap[maxY].length - 1;

  print(weights[Tuple2(maxX, maxY)]);

}