import 'dart:io';
import 'package:ludo/cell.dart';
import 'package:ludo/colored_circle.dart';
import 'package:ludo/ludo_solve.dart';
import 'package:ludo/pair.dart';
import 'package:ludo/player.dart';
import 'package:ludo/possible_moves/get_a_solder.dart';
import 'package:ludo/possible_moves/move_a_solder.dart';
import 'package:ludo/possible_moves/possible_moves.dart';
import 'package:ludo/solder.dart';
import 'package:ludo/state.dart';
import 'package:ludo/user_interaction.dart';
import 'constants.dart';

class Grid {
  final int _rows = 15;
  final int _columns = 15;
  late List<List<Cell>> _grid;
  int _currentPlayerIndex = 0;
  int _sixCount = 0;
  late int randomVal;
  List<Player> _players = [
    Player(
      name: 'A',
      coloredCircle: ColoredCircles.blue,
      playingArea: [
        //{6, 0} -> {6, 5}
        ...List.generate(6, (index) => Pair(x: 6, y: index)),
        //{5, 6} -> {0, 6}
        ...List.generate(6, (index) => Pair(x: index, y: 6)).reversed,
        //{0, 7}
        Pair(x: 0, y: 7),
        //{0, 8} -> {5, 8}
        ...List.generate(6, (index) => Pair(x: index, y: 8)),
        //{6, 9} -> {6, 14}
        ...List.generate(6, (index) => Pair(x: 6, y: index + 9)),
        //{7, 14}
        Pair(x: 7, y: 14),
        //{8, 14} -> {8, 9}
        ...List.generate(6, (index) => Pair(x: 8, y: index + 9)).reversed,
        //{9, 8} -> {14, 8}
        ...List.generate(6, (index) => Pair(x: index + 9, y: 8)),
        //{14, 7}
        Pair(x: 14, y: 7),
        //{14, 6} -> {9, 6}
        ...List.generate(6, (index) => Pair(x: index + 9, y: 6)).reversed,
        //{8, 5} -> {8, 0}
        ...List.generate(6, (index) => Pair(x: 8, y: index)).reversed,
        //{7, 0}
        Pair(x: 7, y: 0),
      ],
      winningArea: List.generate(5, (index) => Pair(x: 7, y: index + 1)),
      headOfInitialArea: Pair(x: 1, y: 1),
      startingPoint: Pair(x: 6, y: 0),
      endingPoint: Pair(x: 7, y: 5),
    ),
    Player(
      name: 'B',
      coloredCircle: ColoredCircles.red,
      playingArea: [
        //{0, 8} -> {5, 8}
        ...List.generate(6, (index) => Pair(x: index, y: 8)),
        //{6, 9} -> {6, 14}
        ...List.generate(6, (index) => Pair(x: 6, y: index + 9)),
        //{7, 14}
        Pair(x: 7, y: 14),
        //{8, 14} -> {8, 9}
        ...List.generate(6, (index) => Pair(x: 8, y: index + 9)).reversed,
        //{9, 8} -> {14, 8}
        ...List.generate(6, (index) => Pair(x: index + 9, y: 8)),
        //{14, 7}
        Pair(x: 14, y: 7),
        //{14, 6} -> {9, 6}
        ...List.generate(6, (index) => Pair(x: index + 9, y: 6)).reversed,
        //{8, 5} -> {8, 0}
        ...List.generate(6, (index) => Pair(x: 8, y: index)).reversed,
        //{7, 0}
        Pair(x: 7, y: 0),
        //{6, 0} -> {6, 5}
        ...List.generate(6, (index) => Pair(x: 6, y: index)),
        //{5, 6} -> {0, 6}
        ...List.generate(6, (index) => Pair(x: index, y: 6)).reversed,
        //{0, 7}
        Pair(x: 0, y: 7),
      ],
      winningArea: List.generate(5, (index) => Pair(x: index + 1, y: 7)),
      headOfInitialArea: Pair(x: 1, y: 10),
      startingPoint: Pair(x: 0, y: 8),
      endingPoint: Pair(x: 5, y: 7),
    ),
    Player(
      name: 'C',
      coloredCircle: ColoredCircles.green,
      playingArea: [
        //{8, 14} -> {8, 9}
        ...List.generate(6, (index) => Pair(x: 8, y: index + 9)).reversed,
        //{9, 8} -> {14, 8}
        ...List.generate(6, (index) => Pair(x: index + 9, y: 8)),
        //{14, 7}
        Pair(x: 14, y: 7),
        //{14, 6} -> {9, 6}
        ...List.generate(6, (index) => Pair(x: index + 9, y: 6)).reversed,
        //{8, 5} -> {8, 0}
        ...List.generate(6, (index) => Pair(x: 8, y: index)).reversed,
        //{7, 0}
        Pair(x: 7, y: 0),
        //{6, 0} -> {6, 5}
        ...List.generate(6, (index) => Pair(x: 6, y: index)),
        //{5, 6} -> {0, 6}
        ...List.generate(6, (index) => Pair(x: index, y: 6)).reversed,
        //{0, 7}
        Pair(x: 0, y: 7),
        //{0, 8} -> {5, 8}
        ...List.generate(6, (index) => Pair(x: index, y: 8)),
        //{6, 9} -> {6, 14}
        ...List.generate(6, (index) => Pair(x: 6, y: index + 9)),
        //{7, 14}
        Pair(x: 7, y: 14),
      ],
      winningArea: List.generate(5, (index) => Pair(x: 7, y: index + 9)),
      headOfInitialArea: Pair(x: 10, y: 10),
      startingPoint: Pair(x: 8, y: 14),
      endingPoint: Pair(x: 7, y: 9),
    ),
    Player(
      name: 'D',
      coloredCircle: ColoredCircles.yellow,
      playingArea: [
        //{14, 6} -> {9, 6}
        ...List.generate(6, (index) => Pair(x: index + 9, y: 6)).reversed,
        //{8, 5} -> {8, 0}
        ...List.generate(6, (index) => Pair(x: 8, y: index)).reversed,
        //{7, 0}
        Pair(x: 7, y: 0),
        //{6, 0} -> {6, 5}
        ...List.generate(6, (index) => Pair(x: 6, y: index)),
        //{5, 6} -> {0, 6}
        ...List.generate(6, (index) => Pair(x: index, y: 6)).reversed,
        //{0, 7}
        Pair(x: 0, y: 7),
        //{0, 8} -> {5, 8}
        ...List.generate(6, (index) => Pair(x: index, y: 8)),
        //{6, 9} -> {6, 14}
        ...List.generate(6, (index) => Pair(x: 6, y: index + 9)),
        //{7, 14}
        Pair(x: 7, y: 14),
        //{8, 14} -> {8, 9}
        ...List.generate(6, (index) => Pair(x: 8, y: index + 9)).reversed,
        //{9, 8} -> {14, 8}
        ...List.generate(6, (index) => Pair(x: index + 9, y: 8)),
        //{14, 7}
        Pair(x: 14, y: 7),
      ],
      winningArea: List.generate(5, (index) => Pair(x: index + 9, y: 7)),
      headOfInitialArea: Pair(x: 10, y: 1),
      startingPoint: Pair(x: 14, y: 6),
      endingPoint: Pair(x: 9, y: 7),
    ),
  ];

  Grid();

  // Grid({required List<List<Cell>> grid, required int currentPlayerIndex})
  //     : _grid = grid,
  //       _currentPlayerIndex = currentPlayerIndex;

  Grid.copy({
    required List<List<Cell>> grid,
    required int currentPlayerIndex,
    required List<Player> players,
  }) {
    _grid = List.generate(
      _rows,
      (i) => List.generate(
        _columns,
        (j) => Cell(
            coloredCircle: grid[i][j].coloredCircle,
            solders: grid[i][j].solders),
      ),
    );
    _currentPlayerIndex = currentPlayerIndex;
    _players = [];
    for (var player in players) {
      _players.add(
        Player(
          name: player.name,
          coloredCircle: player.coloredCircle,
          playingArea: player.playingArea,
          winningArea: player.winningArea,
          startingPoint: player.startingPoint,
          endingPoint: player.endingPoint,
          headOfInitialArea: player.headOfInitialArea,
        ),
      );
    }
  }

  // : _grid = grid.map((row) => row.map((cell) => Cell.copy(cell)).toList()).toList(),
  //   _currentPlayerIndex = currentPlayerIndex;

  List<Player> get players {
    return _players;
  }

  int get currentPlayerIndex {
    return _currentPlayerIndex;
  }

  set setCurrentPlayerIndex(int x) {
    _currentPlayerIndex = x;
  }

  List<List<Cell>> get getGrid {
    return _grid;
  }

  set setGrid(List<List<Cell>> pGrid) {
    _grid = List.generate(
      _rows,
      (i) => List.generate(_columns, (j) => pGrid[i][j]),
    );
  }

  void _fillPlayerArea({
    required Player player,
  }) {
    int cnt = player.soldersOnInitialArea;
    var head = player.headOfInitialArea;
    for (int i = head.x; i < head.x + 4; i++) {
      for (int j = head.y; j < head.y + 4; j++) {
        if ((i > head.x && i < head.x + 3 && j > head.y && j < head.y + 3) &&
            cnt-- > 0) {
          _grid[i][j] = Cell(coloredCircle: player.coloredCircle, solders: [
            Solder(name: player.name, color: player.coloredCircle, x: i, y: j)
          ]);
        } else {
          _grid[i][j] = Cell(coloredCircle: player.coloredCircle);
        }
      }
    }
  }

  void init() {
    _grid = List.generate(
      _rows,
      (i) => List.generate(
          _columns,
          (j) => Cell(
                coloredCircle: ColoredCircles.brown,
              )),
    );

    ///Actual playing area
    for (var cell in Constants.actualPlayingArea) {
      _grid[cell.x][cell.y] = Cell(coloredCircle: ColoredCircles.white);
    }

    for (var player in _players) {
      ///the winning area of each player
      for (var p in player.winningArea) {
        _grid[p.x][p.y] = Cell(coloredCircle: player.coloredCircle);
      }

      ///coloring the starting point of each player
      _grid[player.startingPoint.x][player.startingPoint.y] =
          Cell(coloredCircle: player.coloredCircle);

      ///coloring the initial area of each player
      _fillPlayerArea(player: player);
    }
  }

  void moveSolder({
    required Player player,
    required Solder solder,
    required int steps,
  }) {
    late int pos;
    for (int i = 0; i < player.playingArea.length; i++) {
      var pair = player.playingArea[i];
      if (pair.x == solder.x && pair.y == solder.y) {
        pos = i;
        break;
      }
    }
    if (pos + steps >= player.playingArea.length) {
      printRed('Out of the range.\n');
    }
    for (int i = pos + 1; i < pos + steps; i++) {
      if (_grid[player.playingArea[i].x][player.playingArea[i].y]
              .containsWall() &&
          _grid[player.playingArea[i].x][player.playingArea[i].y]
                  .coloredCircle !=
              player.coloredCircle) {
        printRed('You cannot pass a wall\n');
        return;
      }
    }
    //if the last cell of the path contains a wall, you can kill it
    if (_grid[player.playingArea[pos + steps].x]
                [player.playingArea[pos + steps].y]
            .containsWall() &&
        _grid[player.playingArea[pos + steps].x]
                    [player.playingArea[pos + steps].y]
                .coloredCircle !=
            player.coloredCircle) {
      var currentCell = _grid[player.playingArea[pos + steps].x]
          [player.playingArea[pos + steps].y];
      //get the opposite color
      late Player opposite;
      for (var player in _players) {
        if (player.coloredCircle == currentCell.coloredCircle) {
          opposite = player;
        }
      }
      //send the wall to its initial area
      opposite.soldersOnInitialArea += currentCell.solders.length;

      //update the coordinates of each solder to its initial state
      for (var solder in currentCell.solders) {
        solder.returnToInitialPos();
      }

      //clear the solders on the current cell
      currentCell.solders.clear();

      //add the new current solder
      currentCell.solders.add(solder);

      for (var cell in Constants.safeCells) {
        if (cell.x == solder.x && cell.y == solder.y) solder.isSafe = true;
      }
      return;
    }

    _grid[solder.x][solder.y].solders.removeLast();
    pos += steps;
    solder.x = player.playingArea[pos].x;
    solder.y = player.playingArea[pos].y;
    _grid[solder.x][solder.y].solders.add(solder);
    for (var cell in Constants.safeCells) {
      if (cell.x == solder.x && cell.y == solder.y) solder.isSafe = true;
    }
  }

  void _clearSolderOnInitialArea(Pair head) {
    for (int i = head.x; i < head.x + 4; i++) {
      for (int j = head.y; j < head.y + 4; j++) {
        if (_grid[i][j].solders.isNotEmpty) {
          _grid[i][j].solders.clear();
          return;
        }
      }
    }
  }

  void getASolderToGrid({required Player player}) {
    if (player.soldersOnInitialArea < 0) return;
    player.soldersOnInitialArea--;
    _clearSolderOnInitialArea(player.headOfInitialArea);
    var solder = player.solders.removeAt(0);

    solder.x = player.startingPoint.x;
    solder.y = player.startingPoint.y;

    player.solders.add(solder);
    _grid[player.startingPoint.x][player.startingPoint.y].solders.add(solder);
  }

  ///check if a player has won
  bool aPlayerHasWon() {
    for (var player in _players) {
      if (player.soldersInWinningArea == 4) return true;
    }
    return false;
  }

  ///check if the current player has no solders on the grid
  bool playerHasNoSoldersOnGrid(Player player) {
    // printCyan('solders on initial area: ${player.soldersOnInitialArea}\n');
    return player.soldersOnInitialArea == 4;
    // for (var cell in player.playingArea) {
    //   var currentCell = _grid[cell.x][cell.y];
    //   if (currentCell.solders.isNotEmpty &&
    //       currentCell.solders[0].name == player.name) return false;
    // }
    // return true;
  }

  List<PossibleMoves> getPossibleMoves({required int currentRandomValue}) {
    List<PossibleMoves> possibleMoves = [];
    var currentPlayer = _players[currentPlayerIndex];

    bool currentPlayerHasNoSoldersOnGrid =
        playerHasNoSoldersOnGrid(currentPlayer);

    if (currentRandomValue != 6 && currentPlayerHasNoSoldersOnGrid) return [];

    if (currentRandomValue == 6 && currentPlayerHasNoSoldersOnGrid) {
      ///move a solder from the initial area to the grid
      possibleMoves.add(GetASolder());
    } else if (currentRandomValue == 6 && !currentPlayerHasNoSoldersOnGrid) {
      ///if the user has some solders on the its initial area
      ///then he may choose either to get one of them to the grid
      ///or move one of the current
      if (currentPlayer.soldersOnInitialArea > 0) {
        ///getting another solder
        possibleMoves.add(GetASolder());

        ///move one of the current
        possibleMoves.add(MoveASolder());
      } else {
        possibleMoves.add(MoveASolder());
      }
    } else {
      possibleMoves.add(MoveASolder());
    }
    return possibleMoves;
  }

  int evaluate({required Player player}) {
    int evaluation = 0;

    //solder on safe cells
    for (var solder in player.solders) {
      if (solder.isSafe) evaluation += 2;
    }

    return evaluation;
  }

  void _play({int currentPlayerIndex = 0}) {
    _currentPlayerIndex = currentPlayerIndex;
    if (aPlayerHasWon()) return;
    var currentPlayer = _players[currentPlayerIndex];
    int randomValue = currentPlayer.generateRandomNumber();
    randomVal = randomValue;
    printBlue(
        'current player is ${currentPlayer.name}, playing with random number: $randomValue\n');
    // print();

    var possibleMoves = getPossibleMoves(currentRandomValue: randomValue);
    // stdout.write('POSSIBLE MOVES: $possibleMoves\n');

    var neighbors = LudoSolve.generateNeighbors(
      currentState: State(grid: this),
      possibleMoves: possibleMoves,
    );

    if (currentPlayerIndex == 0) {
      stdout.write('neighbors:\n');
      stdout.write('$neighbors\n');
      UserInteraction.printUserOptions(possibleMoves);
      if (possibleMoves.isNotEmpty) UserInteraction.executeUserOption(grid: this);
    }
    if (randomValue == 6 && _sixCount <= 3) {
      _sixCount++;
      _play(currentPlayerIndex: currentPlayerIndex);
    } else {
      _sixCount = 0;
      _play(currentPlayerIndex: ++currentPlayerIndex % 4);
    }
  }

  void play() {
    // var currentPlayer = _players[_currentPlayerIndex];
    // _currentRandomValue = currentPlayer.generateRandomNumber();
    // printBlue('current random number: $_currentRandomValue\n');
    _play();
  }

  /// <--- some helper function to print the grid with colored cells --->

  /// to print the dashes that separate between rows
  _printDashes({bool includeIndexes = true}) {
    if (includeIndexes) stdout.write('    ');
    for (int i = 0; i < _columns * (includeIndexes ? 2.5 : 2.1); i++) {
      stdout.write('___');
    }
  }

  /// to print every column number
  _printColumnsNumbers() {
    printYellow('   |  ');
    for (int i = 0; i < _columns; i++) {
      if (i.toString().length == 1) {
        printYellow('0${i.toString()}   |  ');
      } else {
        printYellow('${i.toString()}   |  ');
      }
    }
  }

  _printARowNumber(int i) {
    if (i.toString().length == 1) {
      printYellow('0${i.toString()} |  ');
    } else {
      printYellow('${i.toString()} |  ');
    }
  }

  /// to print a colored cell
  _printCell(
    Cell c, {
    bool includeBars = true,
    bool includeIndexes = true,
  }) {
    if (c.solders.isEmpty) {
      includeIndexes
          ? stdout.write('${c.coloredCircle.circle}  ')
          : stdout.write('${c.coloredCircle.circle}  ');
    } else {
      switch (c.solders[0].color) {
        case ColoredCircles.blue:
          includeIndexes ? printBlue(' $c   ') : printBlue(' $c   ');
          break;
        case ColoredCircles.red:
          includeIndexes ? printRed(' $c   ') : printRed(' $c   ');
          break;
        case ColoredCircles.green:
          includeIndexes ? printGreen(' $c   ') : printGreen(' $c   ');
          break;
        case ColoredCircles.yellow:
          includeIndexes ? printYellow(' $c   ') : printYellow(' $c   ');
          break;
        default:
          break;
      }
    }
    if (includeBars) {
      includeIndexes ? stdout.write('|  ') : stdout.write(' | ');
    } else {
      includeIndexes ? stdout.write('   ') : stdout.write(' ');
    }
  }

  /// to print the grid with colored cells in a readable way
  void print({
    bool includeIndexes = true,
    bool includeDashes = true,
    bool includeBars = true,
  }) {
    if (includeIndexes) {
      _printColumnsNumbers();
      stdout.write('\n');
    }
    for (int i = 0; i < _rows; i++) {
      if (includeDashes) _printDashes(includeIndexes: includeIndexes);
      stdout.write('\n');
      if (includeIndexes) _printARowNumber(i);
      for (int j = 0; j < _columns; j++) {
        _printCell(_grid[i][j],
            includeBars: includeBars, includeIndexes: includeIndexes);
      }
      stdout.write('\n');
    }
    if (includeDashes) _printDashes(includeIndexes: includeIndexes);
    stdout.write('\n\n');
  }
}
