import 'dart:io';
import 'dart:convert';
import 'dart:async';

void main() async {
  // get input
  final file = File('input.txt');
  Stream<String> lines = file.openRead()
      .transform(utf8.decoder)       // Decode bytes to UTF-8.
      .transform(LineSplitter());    // Convert stream to individual lines.
  List<int> inputs = [];
  // parse inputs into array as integers
  try {
    await for (var line in lines) {
      inputs.add(int.parse(line));
    }
    print('File is now closed.');
  } catch (e) {
    print('Error: $e');
  }
  compareByWindow(1, inputs);
  compareByWindow(3, inputs);
}

void compareByWindow(int windowSize, List<int> inputs) {
  var count = 0;
  for(var i = windowSize; i<inputs.length; i++) {
    // calculate previous window
    var prev = 0;
    for(int j = windowSize; j>0; j--){
      prev += inputs[i-j];
    }
    //calculate current window
    var current = 0;
    for(int k = 0; k<windowSize; k++){
      current += inputs[i-k];
    }
    if(current > prev){
      count++;
    }
  }
  print(count);
}
