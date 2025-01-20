import 'dart:io';
import 'package:ludo/colored_circle.dart';
import 'package:ludo/grid.dart';
import 'package:ludo/possible_moves/get_a_solder.dart';
import 'package:ludo/possible_moves/possible_moves.dart';
import 'package:ludo/state.dart';
import 'cell.dart';

abstract class LudoSolve {
  static List<List<Cell>> copyGrid(Grid grid) {
    List<List<Cell>> ans;
    ans = List.generate(
      15,
      (i) => List.generate(
        15,
        (j) => Cell(
            coloredCircle: grid.getGrid[i][j].coloredCircle,
            solders: grid.getGrid[i][j].solders),
      ),
    );
    return ans;
  }

  static List<State> generateNeighbors({
    required State currentState,
    required List<PossibleMoves> possibleMoves,
  }) {
    List<State> neighbors = [];
    var currentGrid = currentState.grid;

    // Grid newGrid = Grid.copy(grid: currentGrid.getGrid, currentPlayerIndex: currentGrid.currentPlayerIndex, players: currentGrid.players);
    // newGrid.getGrid[7][0] = Cell(coloredCircle: ColoredCircles.purple);
    // State newState = State(grid: newGrid);
    // neighbors.add(newState);

    for (var move in possibleMoves) {
      if (move is GetASolder) {
        Grid newGrid = Grid.copy(
            grid: currentGrid.getGrid,
            currentPlayerIndex: currentGrid.currentPlayerIndex,
            players: currentGrid.players);

        newGrid.getASolderToGrid(
            player: newGrid.players[newGrid.currentPlayerIndex]);

        State newState = State(grid: newGrid);

        neighbors.add(newState);
      } else {
        for (var solder
            in currentGrid.players[currentGrid.currentPlayerIndex].solders) {
          if (solder.notOnInitialPos()) {
            stdout.write('y\n');
            Grid newGrid = Grid.copy(
                grid: currentGrid.getGrid,
                currentPlayerIndex: currentGrid.currentPlayerIndex,
                players: currentGrid.players);
            newGrid.moveSolder(
                player: newGrid.players[newGrid.currentPlayerIndex],
                solder: solder,
                steps: currentGrid.randomVal);

            State newState = State(grid: newGrid);

            neighbors.add(newState);
          }
        }
      }
    }

    return neighbors;
  }

  // static int _solve(State currentState, int depth, bool isChance, Player player) {
  //   if(depth == 0 || currentState.grid.aPlayerHasWon()){
  //     return currentState.grid.evaluate(player: player);
  //   }
  //   if(isChance){
  //     int expectedValue = 0;
  //   }
  // }

  static void solve() {}
}
