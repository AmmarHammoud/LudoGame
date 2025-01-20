import 'grid.dart';

class State {
  late Grid grid;
  late int probability;

  State({
    required this.grid,
    this.probability = 1,
  });

  @override
  String toString() {
    grid.print();
    return 'x';
  }
}
