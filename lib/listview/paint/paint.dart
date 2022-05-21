import 'package:flutter/material.dart';

class PaintPage extends StatefulWidget {
  const PaintPage({Key? key}) : super(key: key);

  @override
  State<PaintPage> createState() => _PaintPageState();
}

class _PaintPageState extends State<PaintPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paint'),
      ),
      body: Column(
        children: [
          ClipPath(
            clipper: TriangleClipper(),
            child: Container(
              height: 100,
              width: 100,
              color: Colors.red,
            ),
          ),
          CustomPaint(
            painter: TrianglePainter(),
            child: Container(
              color: Colors.transparent,
              height: 300,
              width: 300,
            ),
          )
        ],
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  final double radius = 50;
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width / 2, 0);
    // path.lineTo(radius / 2, size.height - radius);
    // path.quadraticBezierTo(0, size.height, radius, size.height);
    // path.lineTo(size.width - radius, size.height);
    // path.quadraticBezierTo(size.width, size.height, size.width - radius / 2, size.height - radius);
    // path.lineTo(size.width / 2 + radius / 2, radius);
    // // path.quadraticBezierTo(size.width / 2, 0, size.width / 2 - radius, radius);
    // path.lineTo(radius / 2, size.height - radius);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class TrianglePainter extends CustomPainter {
  final double radius = 60;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final path = Path();
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;
    paint.color = Colors.blueAccent;
    path.moveTo(radius, size.height);
    // path.quadraticBezierTo(
    //   size.width * 0.1,
    //   size.height * 0.78,
    //   size.width * 0.3,
    //   size.height * 0.89,
    // );
    // path.quadraticBezierTo(
    //   size.width * 0.45,
    //   size.height * 0.95,
    //   size.width * 0.6,
    //   size.height * 0.85,
    // );
    // path.quadraticBezierTo(
    //   size.width * 0.75,
    //   size.height * 0.75,
    //   size.width * 0.85,
    //   size.height * 0.7,
    // );
    // path.quadraticBezierTo(
    //   size.width * 0.95,
    //   size.height * 0.65,
    //   size.width * 1,
    //   size.height * 0.68,
    // );
    path.lineTo(size.width - radius, size.height);
    path.lineTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    canvas.drawPath(path, paint);
    final paint1 = Paint();
    paint1.style = PaintingStyle.fill;
    paint1.color = Colors.yellow;
    canvas.drawPath(path, paint1);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(TrianglePainter oldDelegate) => false;
}
