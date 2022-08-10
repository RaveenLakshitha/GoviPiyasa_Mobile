import 'package:flutter/material.dart';

class BackgroundDrawer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    Path mainBG = Path();
    mainBG.addRect(Rect.fromLTRB(0, 0, size.width, size.height));
    paint.color = Colors.lightGreen;
    canvas.drawPath(mainBG, paint);

    Path topOrange = Path()
      ..moveTo(size.width, 0)
      ..lineTo(0, 0)
      ..cubicTo(0, size.height * 0.45, size.width, size.height * 0.1,
          size.width, size.height * 0.45);
    paint.color = Colors.white;

    // canvas.drawPath(topOrange, paint);

    Path bottomOrange = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, 0)
      ..cubicTo(0, size.height * 0.4, size.width, size.height * 0.1,
          size.width, size.height * 0.45);

    topOrange.addPath(bottomOrange, Offset(0, size.height * 0.55));

    canvas.drawPath(topOrange, paint);

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}