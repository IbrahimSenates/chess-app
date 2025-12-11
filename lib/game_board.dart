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

  //seçili taş için hamle
  List<List<int>> validMoves = [];

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
        isWhite: false,
      );
      newBoard[6][i] = ChessPiece(
        type: ChessPieceType.pawn,
        imagePath: 'lib/images/pawn_white.png',
        isWhite: true,
      );

      //kalelerin konumları
      newBoard[0][0] = ChessPiece(
        type: ChessPieceType.rook,
        imagePath: 'lib/images/rook.png',
        isWhite: false,
      );
      newBoard[0][7] = ChessPiece(
        type: ChessPieceType.rook,
        imagePath: 'lib/images/rook.png',
        isWhite: false,
      );
      newBoard[7][0] = ChessPiece(
        type: ChessPieceType.rook,
        imagePath: 'lib/images/rook_white.png',
        isWhite: true,
      );
      newBoard[7][7] = ChessPiece(
        type: ChessPieceType.rook,
        imagePath: 'lib/images/rook_white.png',
        isWhite: true,
      );

      //atların konumları
      newBoard[0][1] = ChessPiece(
        type: ChessPieceType.knight,
        imagePath: 'lib/images/knight.png',
        isWhite: false,
      );
      newBoard[0][6] = ChessPiece(
        type: ChessPieceType.knight,
        imagePath: 'lib/images/knight.png',
        isWhite: false,
      );
      newBoard[7][1] = ChessPiece(
        type: ChessPieceType.knight,
        imagePath: 'lib/images/knight_white.png',
        isWhite: true,
      );
      newBoard[7][6] = ChessPiece(
        type: ChessPieceType.knight,
        imagePath: 'lib/images/knight_white.png',
        isWhite: true,
      );

      //fillerin konumları
      newBoard[0][2] = ChessPiece(
        type: ChessPieceType.bishop,
        imagePath: 'lib/images/bishop.png',
        isWhite: false,
      );
      newBoard[0][5] = ChessPiece(
        type: ChessPieceType.bishop,
        imagePath: 'lib/images/bishop.png',
        isWhite: false,
      );
      newBoard[7][2] = ChessPiece(
        type: ChessPieceType.bishop,
        imagePath: 'lib/images/bishop_white.png',
        isWhite: true,
      );
      newBoard[7][5] = ChessPiece(
        type: ChessPieceType.bishop,
        imagePath: 'lib/images/bishop_white.png',
        isWhite: true,
      );

      //Vezirlerin konumu
      newBoard[0][3] = ChessPiece(
        type: ChessPieceType.queen,
        imagePath: 'lib/images/queen.png',
        isWhite: false,
      );
      newBoard[7][3] = ChessPiece(
        type: ChessPieceType.queen,
        imagePath: 'lib/images/queen_white.png',
        isWhite: true,
      );

      //Şahların konumu
      newBoard[0][4] = ChessPiece(
        type: ChessPieceType.king,
        imagePath: 'lib/images/king.png',
        isWhite: false,
      );
      newBoard[7][4] = ChessPiece(
        type: ChessPieceType.king,
        imagePath: 'lib/images/king_white.png',
        isWhite: true,
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

      //seçildikten sonra geçerli hamlelerin hesaplanması
      validMoves = calculateRawValidMoves(
        selectedRow,
        selectedCol,
        selectedPiece,
      );
    });
  }

  List<List<int>> calculateRawValidMoves(int row, int col, ChessPiece? piece) {
    List<List<int>> candidateMoves = [];

    int direction = piece!.isWhite ? -1 : 1;

    switch (piece.type) {
      case ChessPieceType.pawn:
        //kare boşsa ilerleyebilir
        if (isInBoard(row + direction, col) &&
            (board[row + direction][col] == null)) {
          candidateMoves.add([row + direction, col]);
        }

        //başlangıç pozisyonunda iki kare ilerleyebilir
        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null &&
              board[row + direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }
        }

        //çapraz olarak taşları ele geçirebilir
        //sol çapraz
        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col - 1]);
        }
        //sağ çapraz
        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite != piece.isWhite) {
          candidateMoves.add([row + direction, col + 1]);
        }
        break;

      case ChessPieceType.rook:
        var directions = [
          [-1, 0], //yukarı
          [1, 0], //aşağı
          [0, -1], //sol
          [0, 1], //sağ
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;

      case ChessPieceType.knight:
        var knightMoves = [
          [-2, -1], //2 yukarı 1 sol
          [-2, 1], //2 yukarı 1 sağ
          [2, -1], //2 aşağı 1 sol
          [2, 1], //2 aşağı 1 sağ
          [-1, -2], //1 yukarı 2 sol
          [-1, 2], //1 yukarı 2 sağ
          [1, -2], // 1 aşağı 2 sol
          [1, 2], //1 aşağı 2 sağ
        ];
        for (var direction in knightMoves) {
          var newRow = row + direction[0];
          var newCol = col + direction[1];

          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
            continue;
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;

      case ChessPieceType.bishop:
        var bishopMoves = [
          [-1, -1], //sol yukarı çapraz
          [-1, 1], // sağ yukarı çapraz
          [1, -1], //sol aşağı çapraz
          [1, 1], //sağ aşağı çapraz
        ];
        for (var direction in bishopMoves) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;

      case ChessPieceType.queen:
        var queenMoves = [
          [-1, 0], //yukarı hareket
          [1, 0], // aşağı hareket
          [0, -1], //sola hareket
          [0, 1], //sağa hareket
          [-1, -1], //sol yukarı çapraz
          [-1, 1], //sağ yukarı çapraz
          [1, -1], //sol aşağı çapraz
          [1, 1], //sağ aşağı çapraz
        ];
        for (var direction in queenMoves) {
          var i = 1;

          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isInBoard(newRow, newCol)) {
              break;
            }
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;

      case ChessPieceType.king:
        var kingMoves = [
          [-1, 0], //yukarı
          [1, 0], //aşağı
          [0, -1], //sol
          [0, 1], //sağ
          [-1, -1], //sol yukarı çapraz
          [-1, 1], //sağ yukarı çapraz
          [1, -1], //aşağı sol çapraz
          [1, 1], //aşağı sağ çapraz
        ];
        for (var direction in kingMoves) {
          var newRow = row + direction[0];
          var newCol = col + direction[1];
          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
            continue;
          }
          candidateMoves.add([newRow, newCol]);
        }

      default:
    }

    return candidateMoves;
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

          //geçerli bir hareket olup olmadığını kontrol edelim
          bool isValidMove = false;
          for (var position in validMoves) {
            //örn (2,0) ve (3,0) validMoves içine eklenmiş olsun, position[0]=row position[1]=col oluyor
            if (position[0] == row && position[1] == col) {
              isValidMove = true;
            }
          }

          return Square(
            isWhite: isWhite(index),
            piece: board[row][col],
            isSelected: isSelected,
            isValidMove: isValidMove,
            onTap: () => pieceSelected(row, col),
          );
        },
      ),
    );
  }
}
