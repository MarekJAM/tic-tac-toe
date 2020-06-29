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
  Field recentlyUpdated;

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
    print(board);
    if (board[field] == FieldStatus.empty) {
      board.update(field, (value) => isCrossTurn ? FieldStatus.cross : FieldStatus.circle);
      isCrossTurn = !isCrossTurn;
      recentlyUpdated = field;
      notifyListeners();
    }
  }

  void clearBoard() {
    board.updateAll((key, value) => FieldStatus.empty);
    notifyListeners();
  }
}
