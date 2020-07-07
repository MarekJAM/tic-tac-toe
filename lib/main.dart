import 'dart:math';

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
    SystemChrome.setEnabledSystemUIOverlays([]);
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
            RotatedBox(quarterTurns: 2, child: ScoreInfo('Player 2')),
            GameArea(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScoreInfo('Player 1'),
                FlatButton.icon(
                  icon: Icon(Icons.refresh),
                  label: Text('Restart'),
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

class ScoreInfo extends StatelessWidget {
  const ScoreInfo(this.player);
  final String player;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: 
      Selector<Game, Map<String,int>>(
              shouldRebuild: (_, __) => true,
              selector: (_, game) => game.score,
              builder: (ctx, score, child) {
                return Text('x ${score['cross']} : ${score['circle']} o');
              },
            ),      
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 2),
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
    return Container(
      child: Stack(
        children: [
          Table(
            border: TableBorder(
              verticalInside: BorderSide(width: 2),
              horizontalInside: BorderSide(width: 2),
            ),
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
          Positioned.fill(
            child: Selector<Game, List<int>>(
              shouldRebuild: (previous, next) => previous != next,
              selector: (_, game) => game.offsets,
              builder: (ctx, data, child) {
                if (data != null) {
                  return CustomPaint(
                    painter: WinPainter(data),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
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
              return data.board[widget.field] == FieldStatus.circle
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Circle(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Cross(),
                    );
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

class Cross extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CrossState();
}

class CrossState extends State<Cross> with SingleTickerProviderStateMixin {
  double _fraction = 0.0;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    var controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {
          _fraction = animation.value;
        });
      });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: CrossPainter(_fraction));
  }
}

class CrossPainter extends CustomPainter {
  Paint _paint;
  double _fraction;

  CrossPainter(this._fraction) {
    _paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    double leftLineFraction, rightLineFraction;

    if (_fraction < .5) {
      leftLineFraction = _fraction / .5;
      rightLineFraction = 0.0;
    } else {
      leftLineFraction = 1.0;
      rightLineFraction = (_fraction - .5) / .5;
    }

    canvas.drawLine(
        Offset(0.0, 0.0),
        Offset(size.width * leftLineFraction, size.height * leftLineFraction),
        _paint);

    if (_fraction >= .5) {
      canvas.drawLine(
          Offset(size.width, 0.0),
          Offset(size.width - size.width * rightLineFraction,
              size.height * rightLineFraction),
          _paint);
    }
  }

  @override
  bool shouldRepaint(CrossPainter oldDelegate) {
    return oldDelegate._fraction != _fraction;
  }
}

class Circle extends StatefulWidget {
  @override
  _CircleState createState() => _CircleState();
}

class _CircleState extends State<Circle> with SingleTickerProviderStateMixin {
  double _fraction = 0.0;
  Animation<double> _animation;
  AnimationController _controller;
  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(duration: Duration(milliseconds: 300), vsync: this);

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _fraction = _animation.value;
        });
      });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CirclePainter(fraction: _fraction),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CirclePainter extends CustomPainter {
  final double fraction;
  var _circlePaint;

  CirclePainter({this.fraction}) {
    _circlePaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset(0.0, 0.0) & size;

    canvas.drawArc(rect, -pi / 2, pi * 2 * fraction, false, _circlePaint);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }
}

class WinPainter extends CustomPainter {
  WinPainter(this.offsets);
  final List<int> offsets;

  @override
  void paint(Canvas canvas, Size size) {
    // Define a paint object
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..color = Colors.black;

    canvas.drawLine(
      Offset(size.width / 6 * offsets[0], size.width / 6 * offsets[1]),
      Offset(size.width / 6 * offsets[2], size.width / 6 * offsets[3]),
      paint,
    );
  }

  @override
  bool shouldRepaint(WinPainter oldDelegate) => false;
}
