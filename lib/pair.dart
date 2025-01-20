class Pair {
  late int x;
  late int y;

  Pair({
    required this.x,
    required this.y,
  });

  Pair.copy(Pair original) : x = original.x, y = original.y;

  @override
  bool operator ==(covariant Pair other) {
    if(identical(this, other)) return true;
    return x == other.x && y == other.y;
  }

  @override
  String toString() {
    return '{x: $x, y: $y}';
  }
}
