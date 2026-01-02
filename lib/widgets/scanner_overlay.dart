import 'package:flutter/material.dart';

class ScannerOverlay extends StatefulWidget {
  const ScannerOverlay({super.key});

  @override
  ScannerOverlayState createState() => ScannerOverlayState();
}

class ScannerOverlayState extends State<ScannerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: _ScannerOverlayPainter(_animation.value),
          child: Container(),
        );
      },
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final double value;

  _ScannerOverlayPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width * 0.7;
    final double h = size.height * 0.4;

    final double left = (size.width - w) / 2;
    final double top = (size.height - h) / 2;
    final double right = left + w;
    final double bottom = top + h;

    final dark = Paint()..color = Colors.black.withValues(alpha: 0.5);

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, top), dark);
    canvas.drawRect(Rect.fromLTWH(0, top, left, h), dark);
    canvas.drawRect(Rect.fromLTWH(right, top, size.width - right, h), dark);
    canvas.drawRect(
      Rect.fromLTWH(0, bottom, size.width, size.height - bottom),
      dark,
    );

    final border = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), border);

    final laser = Paint()
      ..color = Colors.redAccent.withValues(alpha: 0.7)
      ..strokeWidth = 2;

    final y = top + h * value;
    canvas.drawLine(Offset(left, y), Offset(right, y), laser);
  }

  @override
  bool shouldRepaint(_ScannerOverlayPainter oldDelegate) => true;
}
