import 'package:flutter/material.dart';

class Score {
  late double value;
  late int time;
  Score(this.value, this.time);
}

class ProgressChart extends StatefulWidget {
  const ProgressChart({Key? key, required this.scores}) : super(key: key);
  final List<Score> scores;
  @override
  State<ProgressChart> createState() => _ProgressChartState();
}

class _ProgressChartState extends State<ProgressChart> {
  // late double _min, _max;
  @override
  void initState() {
    super.initState();
    // var min = double.maxFinite;
    // var max = double.maxFinite;
    // widget.scores.forEach((p) {
    //   min = min > p.value ? p.value : min;
    //   max = max < p.value ? p.value : max;
    // });

    setState(() {
      // _min = min;
      // _max = max;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(),
      painter: ChartPainter(),
    );
  }
}

class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    const radius = 50.0;
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1;

    canvas.drawCircle(c, radius, paint);
    canvas.drawLine(Offset.zero, const Offset(20, 20), paint);
  }

  @override
  bool shouldRepaint(ChartPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(ChartPainter oldDelegate) => false;
}
