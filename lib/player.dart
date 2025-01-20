import 'dart:math';

import 'package:ludo/cell.dart';
import 'package:ludo/colored_circle.dart';
import 'package:ludo/constants.dart';
import 'package:ludo/pair.dart';
import 'package:ludo/solder.dart';

class Player {
  late final String name;
  int soldersOnInitialArea = 4;
  int soldersInWinningArea = 0;
  late Pair _startingPoint;
  late Pair _endingPoint;
  late Pair _headOfInitialArea;
  late List<Pair> winningArea;
  late ColoredCircles coloredCircle;
  late List<Solder> solders = [];
  late List<Pair> playingArea;

  Player({
    required this.name,
    required this.coloredCircle,
    required this.playingArea,
    required this.winningArea,
    required Pair startingPoint,
    required Pair endingPoint,
    required Pair headOfInitialArea,
  })  : _startingPoint = startingPoint,
        _endingPoint = endingPoint,
        _headOfInitialArea = headOfInitialArea {
    playingArea = [...playingArea, ...winningArea];
    for (int i = _headOfInitialArea.x + 1; i < _headOfInitialArea.x + 3; i++) {
      for (int j = _headOfInitialArea.y + 1;
          j < _headOfInitialArea.y + 3;
          j++) {
        solders.add(Solder(
          name: name,
          color: coloredCircle,
          x: i,
          y: j,
        ));
      }
    }
  }

  Player.copy(Player original)
      : name = original.name,
        soldersOnInitialArea = original.soldersOnInitialArea,
        soldersInWinningArea = original.soldersInWinningArea,
        _startingPoint = Pair.copy(original._startingPoint),
        _endingPoint = Pair.copy(original._endingPoint),
        _headOfInitialArea = Pair.copy(original._headOfInitialArea),
        coloredCircle = original.coloredCircle,
        playingArea = original.playingArea.map((p) => Pair.copy(p)).toList(),
        winningArea = original.winningArea.map((p) => Pair.copy(p)).toList(),
        solders = original.solders.map((s) => Solder.copy(s)).toList();

  int generateRandomNumber() {
    return Random().nextInt(6) + 1;
  }

  Pair get headOfInitialArea {
    return _headOfInitialArea;
  }

  Pair get startingPoint {
    return _startingPoint;
  }

  Pair get endingPoint {
    return _endingPoint;
  }

  @override
  bool operator ==(covariant Player other) {
    if (identical(this, other)) return true;
    return name == other.name;
  }
}
