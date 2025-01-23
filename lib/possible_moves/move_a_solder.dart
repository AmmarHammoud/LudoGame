import 'dart:io';

import 'package:ludo/possible_moves/possible_moves.dart';

import '../solder.dart';

class MoveASolder extends PossibleMoves {
  Solder? solder;
  int? steps;

  MoveASolder({
    this.solder,
    this.steps,
  });

  @override
  bool operator ==(Object other) {
    return other is MoveASolder &&
        other.solder == solder &&
        other.steps == steps;
  }

  @override
  int get hashCode => Object.hash(solder, steps);

  @override
  String toString() {
    // String s = "move a solder";
    // stdout.write('$s ($solder)\n');
    return 'move a $solder';
  }
}
