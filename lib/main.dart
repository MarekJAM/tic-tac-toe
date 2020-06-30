import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/game_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Game()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            RotatedBox(quarterTurns: 2, child: new Text("Player 2")),
            GameArea(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FlatButton.icon(
                  icon: Icon(Icons.refresh),
                  label: Text('Refresh'),
                  onPressed: () {
                    Provider.of<Game>(context, listen: false).clearBoard();
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class GameArea extends StatefulWidget {
  const GameArea({
    Key key,
  }) : super(key: key);

  @override
  _GameAreaState createState() => _GameAreaState();
}

class _GameAreaState extends State<GameArea> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        Selector<Game, List<int>>(
          shouldRebuild: (previous, next) => previous != next,
          selector: (_, game) => game.winningPos,
          builder: (ctx, data, child) {
            if (data != null) {
              return CustomPaint(
                painter: WinPainter(data),
              );
            } else {
              return Container();
            }
          },
          child: Container(),
        ),
        Table(
          border: TableBorder(
              verticalInside: BorderSide(width: 2),
              horizontalInside: BorderSide(width: 2)),
          children: [
            TableRow(
              children: [
                TableCell(
                  deviceSize: deviceSize,
                  field: Field.topL,
                ),
                TableCell(
                  deviceSize: deviceSize,
                  field: Field.topC,
                ),
                TableCell(
                  deviceSize: deviceSize,
                  field: Field.topR,
                ),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                  deviceSize: deviceSize,
                  field: Field.midL,
                ),
                TableCell(
                  deviceSize: deviceSize,
                  field: Field.midC,
                ),
                TableCell(
                  deviceSize: deviceSize,
                  field: Field.midR,
                ),
              ],
            ),
            TableRow(
              children: [
                TableCell(
                  deviceSize: deviceSize,
                  field: Field.botL,
                ),
                TableCell(
                  deviceSize: deviceSize,
                  field: Field.botC,
                ),
                TableCell(
                  deviceSize: deviceSize,
                  field: Field.botR,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class TableCell extends StatefulWidget {
  const TableCell({Key key, @required this.deviceSize, @required this.field})
      : super(key: key);

  final Size deviceSize;
  final Field field;

  @override
  _TableCellState createState() => _TableCellState();
}

class _TableCellState extends State<TableCell> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: widget.deviceSize.width / 3,
        width: widget.deviceSize.width / 3,
        child: Consumer<Game>(
          builder: (ctx, data, _) {
            if (data.board[widget.field] != FieldStatus.empty &&
                data.board[widget.field] != null) {
              return CustomPaint(
                  painter: FieldPainter(data.board[widget.field]));
            } else {
              return Container();
            }
          },
        ),
      ),
      onTap: () {
        Provider.of<Game>(context, listen: false).updateField(widget.field);
      },
    );
  }
}

class FieldPainter extends CustomPainter {
  FieldPainter(this.fieldStatus);
  final FieldStatus fieldStatus;

  @override
  void paint(Canvas canvas, Size size) {
    // Define a paint object
    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.red;

    if (fieldStatus == FieldStatus.circle) {
      canvas.drawCircle(
        Offset(size.width / 2, size.width / 2),
        size.width * 0.4,
        circlePaint,
      );
    } else {
      canvas.drawLine(
        Offset(size.width / 6, size.width / 6),
        Offset(size.width * 5 / 6, size.width * 5 / 6),
        circlePaint,
      );
      canvas.drawLine(
        Offset(size.width / 6, size.width * 5 / 6),
        Offset(size.width * 5 / 6, size.width / 6),
        circlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(FieldPainter oldDelegate) => false;
}

class WinPainter extends CustomPainter {
  WinPainter(this.positions);
  final List<int> positions;

  @override
  void paint(Canvas canvas, Size size) {
    // Define a paint object
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.blue;
      print(positions);

    canvas.drawLine(
      Offset(size.width / 6 * positions[0], size.width / 6 * positions[1]),
      Offset(size.width / 6 * positions[2], size.width / 6 * positions[3]),
      paint,
    );
  }

  @override
  bool shouldRepaint(WinPainter oldDelegate) => false;
}
