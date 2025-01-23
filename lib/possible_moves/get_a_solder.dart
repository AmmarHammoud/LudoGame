import 'package:ludo/possible_moves/possible_moves.dart';

class GetASolder extends PossibleMoves {

  @override
  bool operator ==(Object other) {
    return other is GetASolder;
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'get a solder';
  }
}
