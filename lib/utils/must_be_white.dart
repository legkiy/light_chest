bool mustBeWhite(int index) {
  final int x = index ~/ 8;
  final int y = index % 8;
  return (x + y) % 2 == 0;
}
