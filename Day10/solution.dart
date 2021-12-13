import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

void main() async {
  // get input
  final file = File('Day10/input.txt');
  Stream<String> lines = file.openRead()
      .transform(utf8.decoder)       // Decode bytes to UTF-8.
      .transform(LineSplitter());    // Convert stream to individual lines.
  // parse inputs into tuples of direction and position
  List<String> inputs = [];
  try {
    await for (var line in lines) {
      inputs.add(line);
    }
    print('File is now closed.');
  } catch (e) {
    print('Error: $e');
  }

 part1(inputs);
 part2(inputs);
}

class Stack<T> {
  final _stack = Queue<T>();

  int get length => _stack.length;

  bool canPop() => _stack.isNotEmpty;

  void clearStack(){
    while(_stack.isNotEmpty){
      _stack.removeLast();
    }
  }

  void push(T element) {
    _stack.addLast(element);
  }

  T pop() {
    T lastElement = _stack.last;
    _stack.removeLast();
    return lastElement;
  }

  T peek() => _stack.last;

}

void part1(List<String> inputs) {
  var points = Map<String, int>();
  points[")"] = 3;
  points["]"] = 57;
  points["}"] = 1197;
  points[">"] = 25137;

  var pairs = Map<String, String>();
  pairs["("] = ")";
  pairs["["] = "]";
  pairs["{"] = "}";
  pairs["<"] = ">";

  var total = 0;

  for(var input in inputs){
    var stack = Stack<String>();
    for(var c in input.split("")){
      // if the character is an opener, add it to the stack
      if(pairs.containsKey(c)){
        stack.push(c);
      } else {
        if(stack.canPop()) {
          // check if this character matched the current one on the stack
          var lastOpen = stack.pop();
          if (pairs[lastOpen] != c) {
            // this is the bad character
            total += points[c];
            continue;
          }
        } else {
          //empty stack, this is the bad character
          total += points[c];
          continue;
        }
      }
    }
  }
  print(total);

}

void part2(List<String> inputs) {
  var points = Map<String, int>();
  points[")"] = 1;
  points["]"] = 2;
  points["}"] = 3;
  points[">"] = 4;

  var pairs = Map<String, String>();
  pairs["("] = ")";
  pairs["["] = "]";
  pairs["{"] = "}";
  pairs["<"] = ">";

  var totals = [];

  for(var input in inputs){
    var stack = Stack<String>();
    var wasCorrupt = false;
    for(var c in input.split("")){
      // if the character is an opener, add it to the stack
      if(pairs.containsKey(c)){
        stack.push(c);
      } else {
        if(stack.canPop()) {
          // check if this character matched the current one on the stack
          var lastOpen = stack.peek();
          if (pairs[lastOpen] != c) {
            // this is a corrupted line
            wasCorrupt = true;
            break;
          } else {
            // matching pair, remove this one from the stack
            stack.pop();
          }
        } else {
          //empty stack, this is a corrupted line
          wasCorrupt = true;
          break;
        }
      }
    }
    if(!wasCorrupt && stack.canPop()) {
      var total = 0;
      // get matched for remaining elements in stack
      while (stack.canPop()) {
        total *= 5;
        total += points[pairs[stack.pop()]];
      }
      totals.add(total);
    }
  }
  totals.sort();

  print(totals[(totals.length/2).floor()]);

}