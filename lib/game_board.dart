import 'package:flutter/material.dart';
import 'package:light_chest/utils/utils.dart';
import 'package:light_chest/widgets/widgets.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late List<List<ChestFig?>> board;
  ChestFig? selectedFig;
  int selectRow = -1;
  int selectCol = -1;

  List<List<int>> validMoves = [];

  @override
  void initState() {
    super.initState();
    _initBoard();
  }

  void _initBoard() {
    List<List<ChestFig?>> newBoard =
        List.generate(8, (index) => List.generate(8, (index) => null));

    // Place pawn
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = ChestFig(
          type: ChestFigType.pawn,
          isWhite: false,
          imgPath: 'assets/chest/pawn.svg');

      newBoard[6][i] = ChestFig(
          type: ChestFigType.pawn,
          isWhite: true,
          imgPath: 'assets/chest/pawn.svg');
    }
    //place rooks
    newBoard[0][0] = ChestFig(
        type: ChestFigType.rook,
        isWhite: false,
        imgPath: 'assets/chest/rook.svg');
    newBoard[0][7] = ChestFig(
        type: ChestFigType.rook,
        isWhite: false,
        imgPath: 'assets/chest/rook.svg');
    newBoard[7][0] = ChestFig(
        type: ChestFigType.rook,
        isWhite: true,
        imgPath: 'assets/chest/rook.svg');
    newBoard[7][7] = ChestFig(
        type: ChestFigType.rook,
        isWhite: true,
        imgPath: 'assets/chest/rook.svg');

    // Place horses
    newBoard[0][1] = ChestFig(
        type: ChestFigType.horse,
        isWhite: false,
        imgPath: 'assets/chest/horse.svg');
    newBoard[0][6] = ChestFig(
        type: ChestFigType.horse,
        isWhite: false,
        imgPath: 'assets/chest/horse.svg');
    newBoard[7][1] = ChestFig(
        type: ChestFigType.horse,
        isWhite: true,
        imgPath: 'assets/chest/horse.svg');
    newBoard[7][6] = ChestFig(
        type: ChestFigType.horse,
        isWhite: true,
        imgPath: 'assets/chest/horse.svg');

    // Place bishops
    newBoard[0][2] = ChestFig(
        type: ChestFigType.bishop,
        isWhite: false,
        imgPath: 'assets/chest/bishop.svg');
    newBoard[0][5] = ChestFig(
        type: ChestFigType.bishop,
        isWhite: false,
        imgPath: 'assets/chest/bishop.svg');
    newBoard[7][2] = ChestFig(
        type: ChestFigType.bishop,
        isWhite: true,
        imgPath: 'assets/chest/bishop.svg');
    newBoard[7][5] = ChestFig(
        type: ChestFigType.bishop,
        isWhite: true,
        imgPath: 'assets/chest/bishop.svg');

    // Place queens
    newBoard[0][3] = ChestFig(
        type: ChestFigType.queen,
        isWhite: false,
        imgPath: 'assets/chest/queen.svg');
    newBoard[7][4] = ChestFig(
        type: ChestFigType.queen,
        isWhite: true,
        imgPath: 'assets/chest/queen.svg');

    // Place kings
    newBoard[0][4] = ChestFig(
        type: ChestFigType.king,
        isWhite: false,
        imgPath: 'assets/chest/king.svg');
    newBoard[7][3] = ChestFig(
        type: ChestFigType.king,
        isWhite: true,
        imgPath: 'assets/chest/king.svg');

    board = newBoard;
  }

  void figSelected(int row, int col) {
    setState(() {
      if (board[row][col] != null) {
        selectedFig = board[row][col];
        selectRow = row;
        selectCol = col;
      }
    });
    validMoves = calculateRowValidMoves(selectRow, selectCol, selectedFig);
  }

  List<List<int>> calculateRowValidMoves(int row, int col, ChestFig? figure) {
    List<List<int>> candidateMoves = [];
    int direction = figure!.isWhite ? -1 : 1;

    switch (figure.type) {
      case ChestFigType.pawn:
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
        }
        if ((row == 1 && !figure.isWhite) || (row == 6 && figure.isWhite)) {
          if (isInBoard(row + 2 *direction, col) &&
              board[row + 2 * direction][col] == null &&
              board[row + direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }
        }

        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite) {
          candidateMoves.add([row + direction, col - 1]);
        }

        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite) {
          candidateMoves.add([row + direction, col + 1]);
        }
        break;
      case ChestFigType.rook:
        break;
      case ChestFigType.horse:
        break;
      case ChestFigType.bishop:
        break;
      case ChestFigType.queen:
        break;
      case ChestFigType.king:
        break;
      default:
    }
    return candidateMoves;
  }

  @override
  Widget build(BuildContext context) {
    final pawn = ChestFig(
      type: ChestFigType.pawn,
      isWhite: true,
      imgPath: 'assets/chest/pawn.svg',
    );
    return Scaffold(
      body: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8 * 8,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
        itemBuilder: (context, index) {
          int row = index ~/ 8;
          int col = index % 8;

          bool isSelected = selectRow == row && selectCol == col;
          bool isValidMove = false;

          for (var position in validMoves) {
            if (position[0] == row && position[1] == col) {
              isValidMove = true;
            }
          }

          return Square(
            isWhite: mustBeWhite(index),
            figure: board[row][col],
            isSelected: isSelected,
            onTap: () => figSelected(row, col),
            isValidMove: isValidMove,
          );
        },
      ),
    );
  }
}
