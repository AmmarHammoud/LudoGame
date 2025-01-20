/*
Green:   \x1B[32m
Blue:    \x1B[34m
Red:     \x1B[31m
Cyan:    \x1B[36m
Black:   \x1B[30m
Yellow:  \x1B[33m
Magenta: \x1B[35m
White:   \x1B[37m
Reset:   \x1B[0m
*/

import 'dart:io';

import 'package:ludo/pair.dart';

import 'cell.dart';

const String cyan = '\x1B[36m';
const String red = '\x1B[31m';
const String green = '\x1B[32m';
const String blue = '\x1B[34m';
const String yellow = '\x1B[33m';
const String reset = '\x1B[0m';

printCyan(String t) {
  stdout.write('$cyan$t$reset');
}

printRed(String t) {
  stdout.write('$red$t$reset');
}

printGreen(String t) {
  stdout.write('$green$t$reset');
}

printBlue(String t) {
  stdout.write('$blue$t$reset');
}

printYellow(String t) {
  stdout.write('$yellow$t$reset');
}

abstract class Constants {
  static List<Pair> actualPlayingArea = [
    //{6, 0} -> {6, 5}
    ...List.generate(6, (index) => Pair(x: 6, y: index)),
    //{5, 6} -> {0, 6}
    ...List.generate(6, (index) => Pair(x: index, y: 6)).reversed,
    //{0, 7}
    Pair(x: 0, y: 7),
    //{0, 8} -> {5, 8}
    ...List.generate(6, (index) => Pair(x: index, y: 8)),
    //{6, 9} -> {6, 14}
    ...List.generate(6, (index) => Pair(x: 6, y: index + 9)),
    //{7, 14}
    Pair(x: 7, y: 14),
    //{8, 14} -> {8, 9}
    ...List.generate(6, (index) => Pair(x: 8, y: index + 9)).reversed,
    //{9, 8} -> {14, 8}
    ...List.generate(6, (index) => Pair(x: index + 9, y: 8)),
    //{14, 7}
    Pair(x: 14, y: 7),
    //{14, 6} -> {9, 6}
    ...List.generate(6, (index) => Pair(x: index + 9, y: 6)).reversed,
    //{8, 5} -> {8, 0}
    ...List.generate(6, (index) => Pair(x: 8, y: index)).reversed,
    //{7, 0}
    Pair(x: 7, y: 0),
  ];
  static List<Pair> safeCells = [
    Pair(x: 8, y: 0),
    Pair(x: 6, y: 6),
    Pair(x: 6, y: 14),
    Pair(x: 14, y: 8),
  ];
}
