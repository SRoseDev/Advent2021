import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:math';

import 'package:sortedmap/sortedmap.dart';

void main() async {
  // get input
  final file = File('Day5/input.txt');
  Stream<String> lines = file.openRead()
      .transform(utf8.decoder)       // Decode bytes to UTF-8.
      .transform(LineSplitter());    // Convert stream to individual lines.
  // parse inputs into tuples of direction and position
  List<Line> inputs = [];
  try {
    await for (var line in lines) {
      var points = line.split(' -> ');
      var p1 = points[0].split(',');
      var p2 = points[1].split(',');
      var start = Point(int.parse(p1[0]), int.parse(p1[1]));
      var end = Point(int.parse(p2[0]), int.parse(p2[1]));
      inputs.add(Line(start, end));
    }
    print('File is now closed.');
  } catch (e) {
    print('Error: $e');
  }

  CalculateMatrixCounts(inputs.where((element) => element.isHorizontal() || element.isVertical()).toList());
  CalculateMatrixCounts(inputs);

}

void CalculateMatrixCounts(List<Line> inputs) {
  Map<int, Map<int, int>> matrix = new Map();
  for(var line in inputs){
    for(var point in line.generatePoints()){
      if(matrix[point.y] == null){
        matrix[point.y] = new Map<int, int>();
      }
      matrix[point.y][point.x] = (matrix[point.y][point.x] ?? 0) + 1;
    }
  }
  var count = 0;
  // count all points where frequency greater than 1
  for(var row in matrix.keys){
    for(var column in matrix[row].keys){
      if(matrix[row][column] > 1){
        count++;
      }
    }
  }
  print(count);
}

class Point {
  int x;
  int y;

  Point(this.x, this.y);
}

class Line {
  Point start;
  Point end;

  Line(this.start, this.end);

  bool isVertical() {
    return start.x == end.x;
  }

  bool isHorizontal() {
    return start.y == end.y;
  }

  // points are not guaranteed to run low to high
  // use this function to generate all points to avoid nasty for loops
  List<Point> generatePoints(){
    List<Point> points = [];
    if(isVertical()){
      if(start.y < end.y){
        for(var y = start.y; y <= end.y; y++){
          points.add(new Point(start.x, y));
        }
      } else {
        for(var y = start.y; y >= end.y; y--){
          points.add(new Point(start.x, y));
        }
      }
    } else if(isHorizontal()){
      if(start.x < end.x){
        for(var x = start.x; x <= end.x; x++){
          points.add(new Point(x, start.y));
        }
      } else {
        for(var x = start.x; x >= end.x; x--){
          points.add(new Point(x, start.y));
        }
      }
    } else {
      // 45 degree diagonals
      var curX = start.x;
      var xIncrement = 1;
      if(end.x < start.x){
        xIncrement = -1;
      }
      var curY = start.y;
      var yIncrement = 1;
      if(end.y < start.y){
        yIncrement = -1;
      }
      // add starting point
      points.add(new Point(start.x, start.y));
      do {
        // walk line
        curX += xIncrement;
        curY += yIncrement;
        // add current point
        points.add(new Point(curX, curY));
      } while(curX != end.x);
    }
    return points;
  }
}