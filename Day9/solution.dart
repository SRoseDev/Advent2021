import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

void main() async {
  // get input
  final file = File('Day9/input.txt');
  Stream<String> lines = file.openRead()
      .transform(utf8.decoder)       // Decode bytes to UTF-8.
      .transform(LineSplitter());    // Convert stream to individual lines.
  // parse inputs into tuples of direction and position
  List<List<int>> inputs = [];
  try {
    await for (var line in lines) {
      inputs.add(line.split('').map((e) => int.parse(e)).toList());
    }
    print('File is now closed.');
  } catch (e) {
    print('Error: $e');
  }
  // build node list
  List<Node> nodes = [];
  for(var y = 0; y < inputs.length; y++){
    var row = inputs[y];
    for(var x = 0; x < row.length; x++){
      // create node
      int value = inputs[y][x];
      int left = null;
      if(x > 0){
        left = inputs[y][x-1];
      }
      int top = null;
      if(y > 0){
        top = inputs[y-1][x];
      }
      int right = null;
      if(x < row.length - 1){
        right = inputs[y][x+1];
      }
      int bottom = null;
      if(y < inputs.length - 1){
        bottom = inputs[y+1][x];
      }
      nodes.add(Node(value, x, y, left, top, right, bottom));
    }
  }

  part1(nodes);
  part2(nodes);

}

void part1(List<Node> nodes) {
  var total = 0;
  nodes.forEach((element) {
    if(element.isLowNode()){
      total += element.riskLevel();
    }
  });
  print(total);
}

void part2(List<Node> nodes) {
  var lowPoints = nodes.where((element) => element.isLowNode());
  var basinSizes = lowPoints.map((e) => e.getBasinSize(nodes)).toList();
  // multiply the 3 largest basin sizes together to get answer
  basinSizes.sort((a, b) => b.compareTo(a));
  print(basinSizes.take(3).reduce((value, element) => value * element));
}

class Node {
  int value;
  int x;
  int y;
  int top;
  int bottom;
  int left;
  int right;

  Node(this.value, this.x, this.y, this.left, this.top, this.right, this.bottom);

  bool isLowNode() {
    // check all negating cases
    if(this.left != null && this.value >= this.left){
      return false;
    } else if(this.top != null && this.value >= this.top){
      return false;
    } else if(this.right != null && this.value >= this.right){
      return false;
    } else if(this.bottom != null && this.value >= this.bottom){
      return false;
    } else {
      return true;
    }
  }

  int riskLevel() {
    return 1 + value;
  }

  int getBasinSize(List<Node> nodes){
    // nodes forming the basin
    Set<Node> basinNodes = Set();
    // previously seen nodes, prevents inf loop
    Set<Node> haveChecked = Set();
    // queue of unseen nodes to check
    Queue<Node> toCheck = Queue();
    toCheck.add(this);

    while(toCheck.isNotEmpty){
      var current = toCheck.removeFirst();
      // add current node
      basinNodes.add(current);
      // only do this if we haven't seen this node yet
      if(haveChecked.add(current)) {
        // walk basin while edges are increasing in value and not 9
        // check left
        if (current.left != null && current.left > current.value &&
            current.left != 9) {
          var left = nodes.firstWhere((element) =>
          element.x == current.x - 1 && element.y == current.y);
          toCheck.add(left);
        }
        // check top
        if (current.top != null && current.top > current.value &&
            current.top != 9) {
          var top = nodes.firstWhere((element) =>
          element.x == current.x && element.y == current.y - 1);
          toCheck.add(top);
        }
        // check right
        if (current.right != null && current.right > current.value &&
            current.right != 9) {
          var right = nodes.firstWhere((element) =>
          element.x == current.x + 1 && element.y == current.y);
          toCheck.add(right);
        }
        // check bottom
        if (current.bottom != null && current.bottom > current.value &&
            current.bottom != 9) {
          var bottom = nodes.firstWhere((element) =>
          element.x == current.x && element.y == current.y + 1);
          toCheck.add(bottom);
        }
      }
    }
    return basinNodes.length;
  }

  @override
  String toString() {
    return '$value, $x, $y, $left, $top, $right, $bottom';
  }

  @override
  bool operator ==(Object other) {
    if(other is Node){
      return toString() == other.toString();
    }
    return false;
  }

  int _hashCode;
  @override
  int get hashCode {
    if(_hashCode == null) {
      _hashCode = toString().hashCode;
    }
    return _hashCode;
  }

}