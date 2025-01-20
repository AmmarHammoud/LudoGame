import 'package:ludo/colored_circle.dart';
import 'pair.dart';

class Solder {
  late final String name;
  late final ColoredCircles color;
  late Pair initialPos;
  late int x;
  late int y;
  late bool isSafe;

  Solder({
    required this.name,
    required this.color,
    required this.x,
    required this.y,
    this.isSafe = false,
  }) : initialPos = Pair(x: x, y: y);

  Solder.copy(Solder original)
      : name = original.name,
        color = original.color,
        x = original.x,
        y = original.y,
        isSafe = original.isSafe,
        initialPos = Pair.copy(original.initialPos);

  bool notOnInitialPos() {
    return initialPos.x != x || initialPos.y != y;
  }

  void returnToInitialPos() {
    x = initialPos.x;
    y = initialPos.y;
  }

  @override
  String toString() {
    return 'Solder{x: $x, y: $y}';
  }
}
