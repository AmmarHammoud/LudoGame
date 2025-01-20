import 'package:ludo/solder.dart';
import 'colored_circle.dart';

class Cell {
  List<Solder> solders = [];
  late ColoredCircles coloredCircle;

  Cell({
    List<Solder>? solders,
    required this.coloredCircle,
  }) : solders = solders ?? [];

  Cell.copy(Cell original){
    for(var s in original.solders){
      solders.add(Solder.copy(s));
    }
    coloredCircle = original.coloredCircle;
  }
      // : solders =
      //       original.solders.map((solder) => Solder.copy(solder)).toList(),
      //   coloredCircle = original.coloredCircle;

  bool containsWall() {
    return solders.length >= 2;
  }

  @override
  String toString() {
    String s = '';
    for (var solder in solders) {
      s += solder.name;
    }
    return s;
  }
}
