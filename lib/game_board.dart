import 'package:chess/components/piece.dart';
import 'package:chess/components/square.dart';
import 'package:chess/helper/helper_methods.dart';
import 'package:chess/values/colors.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late List<List<ChessPiece?>> board;

  ChessPiece? selectedPiece;

  //varsayılan olarak -1 değerinde seçilmeyenler
  int selectedRow = -1;
  int selectedCol = -1;

  @override
  void initState() {
    _initializeBoard();
    super.initState();
  }

  void _initializeBoard() {
    List<List<ChessPiece?>> newBoard = List.generate(
      8,
      (index) => List.generate(8, (index) => null),
    );

    //piyonların konumu
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece(
        type: ChessPieceType.pawn,
        imagePath: 'lib/images/pawn.png',
      );
      newBoard[6][i] = ChessPiece(
        type: ChessPieceType.pawn,
        imagePath: 'lib/images/pawn_white.png',
      );

      //kalelerin konumları
      newBoard[0][0] = ChessPiece(
        type: ChessPieceType.rook,
        imagePath: 'lib/images/rook.png',
      );
      newBoard[0][7] = ChessPiece(
        type: ChessPieceType.rook,
        imagePath: 'lib/images/rook.png',
      );
      newBoard[7][0] = ChessPiece(
        type: ChessPieceType.rook,
        imagePath: 'lib/images/rook_white.png',
      );
      newBoard[7][7] = ChessPiece(
        type: ChessPieceType.rook,
        imagePath: 'lib/images/rook_white.png',
      );

      //atların konumları
      newBoard[0][1] = ChessPiece(
        type: ChessPieceType.knight,
        imagePath: 'lib/images/knight.png',
      );
      newBoard[0][6] = ChessPiece(
        type: ChessPieceType.knight,
        imagePath: 'lib/images/knight.png',
      );
      newBoard[7][1] = ChessPiece(
        type: ChessPieceType.knight,
        imagePath: 'lib/images/knight_white.png',
      );
      newBoard[7][6] = ChessPiece(
        type: ChessPieceType.knight,
        imagePath: 'lib/images/knight_white.png',
      );

      //fillerin konumları
      newBoard[0][2] = ChessPiece(
        type: ChessPieceType.bishop,
        imagePath: 'lib/images/bishop.png',
      );
      newBoard[0][5] = ChessPiece(
        type: ChessPieceType.bishop,
        imagePath: 'lib/images/bishop.png',
      );
      newBoard[7][2] = ChessPiece(
        type: ChessPieceType.bishop,
        imagePath: 'lib/images/bishop_white.png',
      );
      newBoard[7][5] = ChessPiece(
        type: ChessPieceType.bishop,
        imagePath: 'lib/images/bishop_white.png',
      );

      //Vezirlerin konumu
      newBoard[0][3] = ChessPiece(
        type: ChessPieceType.queen,
        imagePath: 'lib/images/queen.png',
      );
      newBoard[7][3] = ChessPiece(
        type: ChessPieceType.queen,
        imagePath: 'lib/images/queen_white.png',
      );

      //Şahların konumu
      newBoard[0][4] = ChessPiece(
        type: ChessPieceType.king,
        imagePath: 'lib/images/king.png',
      );
      newBoard[7][4] = ChessPiece(
        type: ChessPieceType.king,
        imagePath: 'lib/images/king_white.png',
      );
    }
    board = newBoard;
  }

  void pieceSelected(int row, int col) {
    setState(() {
      if (board[row][col] != null) {
        selectedPiece = board[row][col];
        selectedRow = row;
        selectedCol = col;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: GridView.builder(
        itemCount: 8 * 8,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
        ),
        itemBuilder: (context, index) {
          int row = index ~/ 8;
          int col = index % 8;

          bool isSelected = selectedRow == row && selectedCol == col;

          return Square(
            isWhite: isWhite(index),
            piece: board[row][col],
            isSelected: isSelected,
            onTap: () => pieceSelected(row, col),
          );
        },
      ),
    );
  }
}
