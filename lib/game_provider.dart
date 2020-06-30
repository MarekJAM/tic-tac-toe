import 'package:flutter/material.dart';

enum Field {
  topL,
  topC,
  topR,
  midL,
  midC,
  midR,
  botL,
  botC,
  botR,
}

enum FieldStatus { empty, circle, cross }

class Game with ChangeNotifier {
  bool isCrossTurn = true;
  bool isPlayer1Winner = false;
  int moveCount = 0;
  Field recentlyUpdated;
  List<int>
      winningPos; // contains winning coordinates of 2 fields (both ends) - ax, ay, bx, by, counted from 1 to 3 (e.g. 1,1 is top left), needed to count offset

  Map<Field, FieldStatus> board = {
    Field.topL: FieldStatus.empty,
    Field.topC: FieldStatus.empty,
    Field.topR: FieldStatus.empty,
    Field.midL: FieldStatus.empty,
    Field.midC: FieldStatus.empty,
    Field.midR: FieldStatus.empty,
    Field.botL: FieldStatus.empty,
    Field.botC: FieldStatus.empty,
    Field.botR: FieldStatus.empty,
  };

  void updateField(Field field) {
    if (board[field] == FieldStatus.empty) {
      board.update(field,
          (value) => isCrossTurn ? FieldStatus.cross : FieldStatus.circle);
      isCrossTurn = !isCrossTurn;
      recentlyUpdated = field;
      moveCount++;
      checkWinner();
      notifyListeners();
    }
  }

  void clearBoard() {
    board.updateAll((key, value) => FieldStatus.empty);
    moveCount = 0;
    notifyListeners();
  }

  void checkWinner() {
    if (moveCount >= 5) {
      if (board[Field.topL] == board[Field.topC] &&
          board[Field.topL] == board[Field.topR]) {
            winningPos = [1,1,3,1];
            notifyListeners();
      } else if (board[Field.midL] == board[Field.midC] &&
          board[Field.midL] == board[Field.midR]) {
            winningPos = [1,2,3,2];
            notifyListeners();
      } else if (board[Field.botL] == board[Field.botC] &&
          board[Field.botL] == board[Field.botR]) {
            winningPos = [1,3,3,3];
            notifyListeners();
      } else if (board[Field.topL] == board[Field.midL] &&
          board[Field.topL] == board[Field.botL]) {
            winningPos = [1,1,1,3];
            notifyListeners();
      } else if (board[Field.topC] == board[Field.midC] &&
          board[Field.topC] == board[Field.botC]) {
            winningPos = [2,1,2,3];
            notifyListeners();
      } else if (board[Field.topR] == board[Field.midR] &&
          board[Field.topR] == board[Field.botR]) {
            winningPos = [3,1,3,3];
            notifyListeners();
      } else if (board[Field.topL] == board[Field.midC] &&
          board[Field.topL] == board[Field.botR]) {
            winningPos = [1,1,3,3];
            notifyListeners();
      } else if (board[Field.botL] == board[Field.midC] &&
          board[Field.botL] == board[Field.topR]) {
            winningPos = [1,3,3,1];
            notifyListeners();
          }
      isPlayer1Winner = true;
    }
  }
}
