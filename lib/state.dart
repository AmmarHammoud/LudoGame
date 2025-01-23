import 'grid.dart';

class State {
  late Grid grid;
  late double probability;

  State({
    required this.grid,
    this.probability = 1.0,
  });

  State.copy(State original)
      : grid = Grid.copy(
            randomValue: original.grid.randomVal,
            pGrid: original.grid.getGrid,
            currentPlayerIndex: original.grid.currentPlayerIndex,
            players: original.grid.players),
        probability = original.probability;

  @override
  String toString() {
    grid.print();
    return 'x';
  }
}
