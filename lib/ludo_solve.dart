import 'dart:io';
import 'dart:math';
import 'package:ludo/constants.dart';
import 'package:ludo/grid.dart';
import 'package:ludo/possible_moves/get_a_solder.dart';
import 'package:ludo/possible_moves/possible_moves.dart';
import 'package:ludo/state.dart';
import 'player.dart';
import 'solder.dart';

abstract class LudoSolve {
  // State applyRandomNumberOutcome(State currentState, int randomValue){
  //   currentState.grid.getPossibleMoves(currentRandomValue: randomValue);
  // }
  // static List<State> generateNeighbors({
  //   required State currentState,
  //   required List<PossibleMoves>? possibleMoves,
  // }) {
  //   printGreen('current random value: ${currentState.grid.randomVal}\n');
  //   List<State> neighbors = [];
  //   var currentGrid = currentState.grid;
  //   possibleMoves ??=
  //       currentGrid.getPossibleMoves(currentRandomValue: currentGrid.randomVal);
  //   for (var move in possibleMoves) {
  //     if (move is GetASolder) {
  //       Grid newGrid = Grid.copy(
  //         randomValue: currentGrid.randomVal,
  //           pGrid: currentGrid.getGrid,
  //           currentPlayerIndex: currentGrid.currentPlayerIndex,
  //           players: currentGrid.players);
  //
  //       newGrid.getASolderToGrid(
  //           player: newGrid.players[newGrid.currentPlayerIndex]);
  //
  //       State newState = State(grid: newGrid);
  //
  //       neighbors.add(newState);
  //     } else {
  //       for (var solder
  //           in currentGrid.players[currentGrid.currentPlayerIndex].solders) {
  //         if (solder.notOnInitialPos()) {
  //           stdout.write('y\n');
  //           Grid newGrid = Grid.copy(
  //             randomValue: currentGrid.randomVal,
  //               pGrid: currentGrid.getGrid,
  //               currentPlayerIndex: currentGrid.currentPlayerIndex,
  //               players: currentGrid.players);
  //           newGrid.moveSolder(
  //               player: newGrid.players[newGrid.currentPlayerIndex],
  //               solder: Solder.copy(solder),
  //               steps: currentGrid.randomVal);
  //
  //           State newState = State(grid: newGrid);
  //
  //           neighbors.add(newState);
  //         }
  //       }
  //     }
  //   }
  //
  //   return neighbors;
  // }

  static List<State> getNextStates({
    required State currentState,
    required int randomValue,
  }) {
    List<State> neighbors = [];
    var currentGrid = currentState.grid;
    var possibleMoves =
        currentGrid.getPossibleMoves(currentRandomValue: randomValue);
    // printCyan('APPLY RANDOM NUMBER {${currentGrid.players[currentGrid.currentPlayerIndex].name}}\n');
    for (var move in possibleMoves) {
      if (move is GetASolder) {
        Grid newGrid = Grid.copy(
            randomValue: currentGrid.randomVal,
            pGrid: currentGrid.getGrid,
            currentPlayerIndex: currentGrid.currentPlayerIndex,
            players: currentGrid.players);

        newGrid.getASolderToGrid(
            player: newGrid.players[newGrid.currentPlayerIndex]);

        State newState = State(
            grid: newGrid, probability: currentState.probability * (1.0 / 6.0));

        neighbors.add(newState);
      } else {
        for (var solder
            in currentGrid.players[currentGrid.currentPlayerIndex].solders) {
          if (solder.notOnInitialPos()) {
            Grid newGrid = Grid.copy(
                randomValue: currentGrid.randomVal,
                pGrid: currentGrid.getGrid,
                currentPlayerIndex: currentGrid.currentPlayerIndex,
                players: currentGrid.players);
            newGrid.moveSolder(
                player: newGrid.players[newGrid.currentPlayerIndex],
                solder: Solder.copy(solder),
                steps: currentGrid.randomVal);

            State newState = State(
                grid: newGrid,
                probability: currentState.probability * (1.0 / 6.0));
            neighbors.add(newState);
          }
        }
      }
    }
    return neighbors;
  }

  static int _solve({
    required State currentState,
    required int depth,
    required bool isChance,
    required Player player,
  }) {
    if (depth == 0 || currentState.grid.aPlayerHasWon()) {
      return currentState.grid.evaluate(player: player);
    }
    if (isChance) {
      double expectedValue = 0.0;
      for (int random = 1; random <= 6; random++) {
        var neighbors = getNextStates(
          currentState: currentState,
          randomValue: random,
        );
        for (var nextState in neighbors) {
          int evaluation = _solve(
            currentState: nextState,
            depth: depth - 1,
            isChance: false,
            player: player,
          );
          expectedValue += nextState.probability * evaluation;
        }
      }
      return expectedValue.toInt();
    } else if (player.name != currentState.grid.players[0].name) {
      int maxValue = -1000000;
      for (var neighbor in getNextStates(
        currentState: currentState,
        randomValue: currentState.grid.randomVal,
      )) {
        int eval = _solve(
            currentState: neighbor,
            depth: depth - 1,
            isChance: true,
            player: player);
        maxValue = max(maxValue, eval);
      }
      return maxValue;
    } else {
      int minValue = 1000000;
      for (var neighbor in getNextStates(
        currentState: currentState,
        randomValue: currentState.grid.randomVal,
      )) {
        int eval = _solve(
            currentState: neighbor,
            depth: depth - 1,
            isChance: true,
            player: player);
        minValue = min(minValue, eval);
      }
      return minValue;
    }
  }

  static PossibleMoves findBestMove({
    required State currentState,
    required int depth,
    required bool isChance,
    required Player player,
  }) {
    // Step 1: Generate all possible moves and their resulting states
    var possibleMoves = currentState.grid
        .getPossibleMoves(currentRandomValue: currentState.grid.randomVal);

    // printYellow('player solders in fun BEFORE: ${player.solders}\n');
    // Map each possible move to its resulting state
    var moveToStateMap = <PossibleMoves, State>{};
    for (var move in possibleMoves) {
      var newState = LudoSolve.applyMoveToState(
        currentState: currentState,
        move: move,
      );
      moveToStateMap[move] = newState;
    }

    // printYellow('player solders in fun AFTER:  ${player.solders}\n');

    // Step 2: Evaluate each move's resulting state
    var moveEvaluations = <PossibleMoves, int>{};
    for (var move in moveToStateMap.keys) {
      var resultingState = moveToStateMap[move]!;
      int evaluation = LudoSolve.solve(
        currentState: resultingState,
        depth: depth,
        isChance: isChance,
        player: player,
      );
      moveEvaluations[move] = evaluation;
    }

    // Step 3: Select the move leading to the best evaluation
    var bestMove = moveEvaluations.entries
        .reduce((best, current) => current.value > best.value ? current : best)
        .key;

    return bestMove;
  }

  static State applyMoveToState({
    required State currentState,
    required PossibleMoves move,
  }) {
    var newGrid = Grid.copy(
      randomValue: currentState.grid.randomVal,
      pGrid: currentState.grid.getGrid,
      currentPlayerIndex: currentState.grid.currentPlayerIndex,
      players: currentState.grid.players,
    );
    // printYellow('player solders in fun BEFORE: ${currentState.grid.players[currentState.grid.currentPlayerIndex].solders}\n');

    newGrid.applyMove(
        move: move,
        player: newGrid.players[newGrid.currentPlayerIndex],
        debug: true);

    // printYellow('player solders in fun AFTER:  ${currentState.grid.players[currentState.grid.currentPlayerIndex].solders}\n');
    return State(grid: newGrid);
  }

  static int solve({
    required State currentState,
    required int depth,
    required bool isChance,
    required Player player,
  }) {
    return _solve(
        currentState: currentState,
        depth: depth,
        isChance: isChance,
        player: player);
  }
}
