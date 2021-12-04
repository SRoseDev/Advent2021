import 'dart:io';
import 'dart:convert';
import 'dart:async';

void main() async {
  // get input
  final file = File('Day4/input.txt');
  Stream<String> lines = file.openRead()
      .transform(utf8.decoder)       // Decode bytes to UTF-8.
      .transform(LineSplitter());    // Convert stream to individual lines.
  // parse inputs into tuples of direction and position
  List<int> calledNumbers = [];
  List<List<int>> boardPieces = [];
  List<BingoBoard> boards = [];
  try {
    await for (var line in lines) {
      if(line.trim().isNotEmpty) {
        if(calledNumbers.isEmpty){
          //first line is picks
          var parts = line.split(',');
          for(var part in parts){
            calledNumbers.add(int.parse(part));
          }
        } else {
          // store list to build board once new line is hit
          var parts = line.split(' ');
          List<int> boardRow = [];
          for(var part in parts){
            if(part.isNotEmpty) {
              boardRow.add(int.parse(part));
            }
          }
          boardPieces.add(boardRow);
          // boards are always 5x5
          if(boardPieces.length == 5) {
            BingoBoard board = new BingoBoard();
            for (var piece in boardPieces){
              board.addRow(piece);
            }
            boards.add(board);
            boardPieces.clear();
          }
        }
      }
    }
    print('File is now closed.');
  } catch (e) {
    print('Error: $e');
  }

  part1(calledNumbers, boards);
  part2(calledNumbers, boards);
}

void part1(List<int> calledNumbers, List<BingoBoard> boards){
  for(var calledNumber in calledNumbers){
    for(var board in boards){
      board.calledNumber(calledNumber);
      if(board.hasWinner()){
        print('Last Number Called: $calledNumber, Winning board score: ${board.calculateScore()}');
        return;
      }
    }
  }
}

void part2(List<int> calledNumbers, List<BingoBoard> boards){
  // keep going until only one board, then pay board out until winning
  for(var calledNumber in calledNumbers){
    for (var board in boards) {
      board.calledNumber(calledNumber);
    }
    if(boards.length > 1) {
      // filter out all winning boards
      boards = boards.where((board) => !board.hasWinner()).toList();
    } else {
      //check if winner
      if(boards[0].hasWinner()){
        print('Last Number Called: $calledNumber, Last winning board score: ${boards[0].calculateScore()}');
        return;
      }
    }
  }
}

class BingoBoard {
  final List<List<int>> rows = [];
  // need the last called number for score calculation
  int lastCalledNumber = -1;

  void addRow(List<int> row){
    if(row != null)
      rows.add(row);
  }

  bool hasWinner() {
    return hasRowFilled() || hasColumnFilled();
  }

  bool hasRowFilled() {
    for(var row in rows) {
      var rowMarked = 0;
      for(var i in row) {

        // count how many called numbers are in the column
        if (i == -1) {
          rowMarked++;
        } else {
          // this one isn't a winner, skip checking the rest
          continue;
        }
        // if called numbers equals number of rows, that column is full
        if (rowMarked == row.length) {
          return true;
        }
      }
    }
    return false;
  }

  bool hasColumnFilled() {
    final rowsCount = rows.length;
    for(var i=0; i<rows.length; i++){
      var columnMarked = 0;
      for(var row in rows){
        // count how many called numbers are in the column
        if(row[i] == -1){
          columnMarked++;
        } else {
          // this one isn't a winner, skip checking the rest
          continue;
        }
      }
      // if called numbers equals number of rows, that column is full
      if(columnMarked == rowsCount){
        return true;
      }
    }
    return false;
  }

  void calledNumber(int number) {
    lastCalledNumber = number;
    for(var row in rows){
      for(var i=0; i< row.length; i++){
        if(row[i] == number){
          // use -1 to denote a called number
          row[i] = -1;
        }
      }
    }
  }

  int calculateScore() {
    // sum all unmarked numbers
    int sum = 0;
    for(var row in rows){
      for(int i in row){
        if(i != -1){
          sum += i;
        }
      }
    }
    return sum * lastCalledNumber;
  }

  @override
  String toString() {
    for(var row in rows){
      print(row);
    }
    print('\n');
  }
}