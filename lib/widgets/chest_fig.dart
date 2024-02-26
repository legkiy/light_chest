enum ChestFigType { pawn, rook, horse, bishop, queen, king }

class ChestFig {
  final ChestFigType type;
  final bool isWhite;
  final String imgPath;

  ChestFig({
    required this.type,
    required this.isWhite,
    required this.imgPath,
  });
}
