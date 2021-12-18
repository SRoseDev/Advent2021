import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

void main() async {
  // get input
  final file = File('Day16/input.txt');
  Stream<String> lines = file.openRead()
      .transform(utf8.decoder)       // Decode bytes to UTF-8.
      .transform(LineSplitter());    // Convert stream to individual lines.
  String input = '';
  try {
    await for (var line in lines) {
      input = line;
    }
    print('File is now closed.');
  } catch (e) {
    print('Error: $e');
  }
  Queue<String> chars = Queue();
  var asBinary = input.split('').map((e) => Packet.hexToBinary[e]).join('');
  chars.addAll(asBinary.split(''));
  Packet packet;

  // once queue is all 0 we have processed all the non-padding bits
  while(chars.any((element) => element != '0')){
    // get next header
    var version = '0';
    // remove 3 elements and add them to literal
    // using the take method here doesn't remove them from the queue :sadpanda:
    for(var i = 0; i < 3; i++) {
      version += chars.removeFirst();
    }
    var versionInt = int.parse(Packet.binaryToHex[version]);
    var type = '0';
    for(var i = 0; i < 3; i++) {
      type += chars.removeFirst();
    }
    // check if literal type
    if(type == Packet.hexToBinary['4']){
      packet = parseLiteral(versionInt, chars);
    } else {
      //operator packet
      var typeInt = int.parse(Packet.binaryToHex[type]);
      packet = parseOperator(versionInt, typeInt, chars);
    }
  }

  print(packet);
  // part1
  print('Part1: ${packet.getVersionSum()}');
  // part2
  print('Part2: ${packet.getValue()}');

}

LiteralPacket parseLiteral(int version, Queue chars){
  var literal = '';
  // the last group starts with a 0
  while(chars.removeFirst() != '0'){
    var digit = '';
    for(var i = 0; i < 4; i++) {
      digit += chars.removeFirst();
    }
    literal += digit;
  }
  // add last digit
  var lastDigit = '';
  for(var i = 0; i < 4; i++) {
    lastDigit += chars.removeFirst();
  }
  literal += lastDigit;
  var literalPacket = LiteralPacket(version, int.parse(literal, radix:2));
  return literalPacket;

}

OperatorPacket parseOperator(int version, int typeId, Queue chars){
  //find length
  var operatorPacket = OperatorPacket(version, typeId, []);
  var lengthTypeId = chars.removeFirst();
  var bitLength = 15;
  if(lengthTypeId == '1'){
    bitLength = 11;
  }
  // build binary number for length of packets
  var lengthBinary = '';
  for(var i = 0; i < bitLength; i++){
    lengthBinary += chars.removeFirst();
  }
  var packetLength = int.parse(lengthBinary, radix: 2);
  if(bitLength == 15) {
    // packetLength represents the total number of bits to parse for this operator
    Queue<String> subQueue = Queue();
    for (var i = 0; i < packetLength; i++) {
      subQueue.add(chars.removeFirst());
    }
    while (subQueue.any((element) => element != '0')) {
      var subVersion = '0';
      // remove 3 elements and add them to literal
      // using the take method here doesn't remove them from the queue :sadpanda:
      for (var i = 0; i < 3; i++) {
        subVersion += subQueue.removeFirst();
      }
      var subType = '0';
      for (var i = 0; i < 3; i++) {
        subType += subQueue.removeFirst();
      }
      if(subType == Packet.hexToBinary['4']){
        if(subQueue.any((element) => element != '0')){
          operatorPacket.packets.add(parseLiteral(
              int.parse(Packet.binaryToHex[subVersion]), subQueue));
        }
      } else {
        if(subQueue.any((element) => element != '0')) {
          var typeInt = int.parse(Packet.binaryToHex[subType]);
          operatorPacket.packets.add(parseOperator(
              int.parse(Packet.binaryToHex[subVersion]), typeInt, subQueue));
        }
      }
    }
  } else {
    // packetLength represents the total number of literal packets in this operator
    while ( operatorPacket.packets.length < packetLength) {
      var subVersion = '0';
      // remove 3 elements and add them to literal
      // using the take method here doesn't remove them from the queue :sadpanda:
      for (var i = 0; i < 3; i++) {
        subVersion += chars.removeFirst();
      }
      var subType = '0';
      for (var i = 0; i < 3; i++) {
        subType += chars.removeFirst();
      }
      if(subType == Packet.hexToBinary['4']){
        if(chars.any((element) => element != '0')) {
          operatorPacket.packets.add(
              parseLiteral(int.parse(Packet.binaryToHex[subVersion]), chars));
        }
      } else {
        if(chars.any((element) => element != '0')) {
          var typeInt = int.parse(Packet.binaryToHex[subType]);
          operatorPacket.packets.add(
              parseOperator(int.parse(Packet.binaryToHex[subVersion]), typeInt, chars));
        }
      }
    }
  }
  return operatorPacket;
}

abstract class Packet {
  int version;

  Packet(this.version);

  int getVersionSum();
  int getValue();

  static final Map<String, String> hexToBinary = {
    '0': '0000',
    '1': '0001',
    '2': '0010',
    '3': '0011',
    '4': '0100',
    '5': '0101',
    '6': '0110',
    '7': '0111',
    '8': '1000',
    '9': '1001',
    'A': '1010',
    'B': '1011',
    'C': '1100',
    'D': '1101',
    'E': '1110',
    'F': '1111'
  };

  static final Map<String, String> binaryToHex = {
    '0000': '0',
    '0001': '1',
    '0010':'2',
    '0011': '3',
    '0100': '4',
    '0101': '5',
    '0110': '6',
    '0111': '7',
    '1000': '8',
    '1001': '9',
    '1010': 'A',
    '1011': 'B',
    '1100': 'C',
    '1101': 'D',
    '1110': 'E',
    '1111': 'F'
};
}

class LiteralPacket extends Packet {
  int value;

  LiteralPacket(int version, this.value): super(version);

  @override
  String toString() {
    return 'LiteralPacket {version: $version, value: $value}';
  }

  @override
  int getVersionSum() {
    return super.version;
  }

  @override
  int getValue() {
    return value;
  }
}

class OperatorPacket extends Packet {
  List<Packet> packets;
  int typeId;

  OperatorPacket(int version, this.typeId, this.packets): super(version);

  @override
  String toString() {
    return 'OperatorPacket {version: $version, typeID: $typeId, packets: ${packets}}';
  }

  @override
  int getVersionSum() {
    int total = version;
    for(var packet in packets){
      total += packet.getVersionSum();
    }
    return total;
  }

  @override
  int getValue() {
    switch(typeId){
      case 0:
        var total = 0;
        for(var packet in packets){
          total += packet.getValue();
        }
        return total;
        break;
      case 1:
        var total = 1;
        for(var packet in packets){
          total *= packet.getValue();
        }
        return total;
        break;
      case 2:
        var minimum = 9223372036854775807; //max int
        for(var packet in packets){
          minimum = min(packet.getValue(), minimum);
        }
        return minimum;
        break;
      case 3:
        var maximum = 0;
        for(var packet in packets){
          maximum = max(packet.getValue(), maximum);
        }
        return maximum;
        break;
      case 5:
        if(packets[0].getValue() > packets[1].getValue()){
          return 1;
        } else {
          return 0;
        }
        break;
      case 6:
        if(packets[0].getValue() < packets[1].getValue()){
          return 1;
        } else {
          return 0;
        }
        break;
      case 7:
        if(packets[0].getValue() == packets[1].getValue()){
          return 1;
        } else {
          return 0;
        }
        break;

    }
    return 0;
  }
}