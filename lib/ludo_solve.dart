import 'dart:io';
import 'package:ludo/grid.dart';
import 'package:ludo/possible_moves/get_a_solder.dart';
import 'package:ludo/possible_moves/possible_moves.dart';
import 'package:ludo/state.dart';
import 'solder.dart';

abstract class LudoSolve {
  static List<State> generateNeighbors({
    required State currentState,
    required List<PossibleMoves> possibleMoves,
  }) {
    List<State> neighbors = [];
    var currentGrid = currentState.grid;
    for (var move in possibleMoves) {
      if (move is GetASolder) {
        Grid newGrid = Grid.copy(
            pGrid: currentGrid.getGrid,
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
                pGrid: currentGrid.getGrid,
                currentPlayerIndex: currentGrid.currentPlayerIndex,
                players: currentGrid.players);
            newGrid.moveSolder(
                player: newGrid.players[newGrid.currentPlayerIndex],
                solder: Solder.copy(solder),
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
