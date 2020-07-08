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
  List<int> offsets;
  Map<String, int> score = {"cross": 0, "circle": 0};

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
    offsets = null;
    isCrossTurn = true;
    notifyListeners();
  }

  void checkWinner() {
    if (moveCount >= 5) {
      if (board[Field.topL] == board[Field.topC] &&
          board[Field.topL] == board[Field.topR] &&
          board[Field.topL] != FieldStatus.empty) {
        offsets = [0, 1, 6, 1];
        updateScore();
      } else if (board[Field.midL] == board[Field.midC] &&
          board[Field.midL] == board[Field.midR] &&
          board[Field.midL] != FieldStatus.empty) {
        offsets = [0, 3, 6, 3];
        updateScore();
      } else if (board[Field.botL] == board[Field.botC] &&
          board[Field.botL] == board[Field.botR] &&
          board[Field.botL] != FieldStatus.empty) {
        offsets = [0, 5, 6, 5];
        updateScore();
      } else if (board[Field.topL] == board[Field.midL] &&
          board[Field.topL] == board[Field.botL] &&
          board[Field.topL] != FieldStatus.empty) {
        offsets = [1, 0, 1, 6];
        updateScore();
      } else if (board[Field.topC] == board[Field.midC] &&
          board[Field.topC] == board[Field.botC] &&
          board[Field.topC] != FieldStatus.empty) {
        offsets = [3, 0, 3, 6];
        updateScore();
      } else if (board[Field.topR] == board[Field.midR] &&
          board[Field.topR] == board[Field.botR] &&
          board[Field.topR] != FieldStatus.empty) {
        offsets = [5, 0, 5, 6];
        updateScore();
      } else if (board[Field.topL] == board[Field.midC] &&
          board[Field.topL] == board[Field.botR] &&
          board[Field.topL] != FieldStatus.empty) {
        offsets = [0, 0, 6, 6];
        updateScore();
      } else if (board[Field.botL] == board[Field.midC] &&
          board[Field.botL] == board[Field.topR] &&
          board[Field.botL] != FieldStatus.empty) {
        offsets = [0, 6, 6, 0];
        updateScore();
      }
      isPlayer1Winner = true;
    }
  }

  void updateScore() {
    if (board[recentlyUpdated] == FieldStatus.cross) {
      score['cross']++;
    } else {
      score['circle']++;
    }
    print(score);
    notifyListeners();
  }

  void resetScore() {
    score['cross'] = 0;
    score['circle'] = 0;
    notifyListeners();
  }
}
