import 'dart:io';
import 'package:ludo/grid.dart';
import 'package:ludo/user_interaction.dart';

void main(List<String> arguments) {
  Grid ludoGrid = Grid();
  ludoGrid.init();
  UserInteraction.init(grid: ludoGrid);
  // ludoGrid.print(includeDashes: false, includeBars: false);
  // stdout.write(Constants.actualPlayingArea);
  ludoGrid.print(includeDashes: false, includeBars: false);
  ludoGrid.play();
}
