import 'dart:io';
import 'package:ludo/constants.dart';
import 'package:ludo/possible_moves/possible_moves.dart';
import 'grid.dart';
import 'possible_moves/get_a_solder.dart';
import 'possible_moves/move_a_solder.dart';
import 'solder.dart';

abstract class UserInteraction {
  static late final Map<String, Function> _objectToFunction;

  static late final Map<int, String> _intToObject;

  // static late final Grid grid;

  static void init({required Grid grid}) {
    // grid = grid;
    _objectToFunction = {
      GetASolder().toString(): _getSolderToGrid,
      MoveASolder().toString(): _moveSolder,
    };
    _intToObject = {};
    for (int i = 0; i < _objectToFunction.length; i++) {
      _intToObject[i] = _objectToFunction.keys.elementAt(i);
    }
  }

  static void printUserOptions(List<PossibleMoves> possibleMoves) {
    if (possibleMoves.isEmpty) {
      printYellow('There are no available moves\n');
      return;
    }
    printYellow('These are the available options for you: \n');
    _intToObject.clear();
    for (int i = 0; i < possibleMoves.length; i++) {
      printYellow('$i: ${possibleMoves[i]}\n');
      _intToObject[i] = possibleMoves[i].toString();
    }
  }

  static int _readUserInput() {
    stdout.write('enter you option: ');
    return int.parse(stdin.readLineSync()!);
  }

  static void executeUserOption({required Grid grid}) {
    int userInput = _readUserInput();
    var obj = _intToObject[userInput];
    _objectToFunction[obj]!(grid: grid);
    stdout.write('Original:\n');
    grid.print(includeBars: false, includeDashes: false);
  }

  static void _getSolderToGrid({required Grid grid}) {
    printYellow('GET A SOLDER\n');
    grid.getASolderToGrid(player: grid.players.first);
  }

  static void _moveSolder({required Grid grid}) {
    printYellow('MOVE A SOLDER\n');
    int cnt = 0;
    for (var solder in grid.players.first.solders) {
      printYellow('solder #${cnt++}: ${solder.toString()}');
      if (!solder.notOnInitialPos()) {
        printRed(' (Not on the grid yet)\n');
      } else {
        stdout.write('\n');
      }
    }
    int idx = _readUserInput();
    if(!grid.players.first.solders[idx].notOnInitialPos()){
      printRed('The solder you have chosen is not on the grid yet\nPlease try again:\n');
      _moveSolder(grid: grid);
      return;
    }
    grid.moveSolder(
        player: grid.players.first,
        solder: grid.players.first.solders[idx],
        steps: grid.randomVal);
  }
}
