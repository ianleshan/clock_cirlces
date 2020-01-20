import 'package:digital_clock/digit_display.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ClockCanvas extends CustomPainter {
  Size oldSize;

  List<CirclePixel> pixels = List();
  LEDDisplay digits;
  Color color;
  Color background;

  ClockCanvas(this.digits, {this.color, this.background});

  @override
  void paint(Canvas canvas, Size size) {
    if (oldSize == null || size != oldSize) {
      resize(size);
    }

    canvas.drawPaint(Paint()..color = background);

    var clockHeight = size.height / 1.9;
    var heightOffset = size.height / 2 - clockHeight / 2;

    var paint = Paint()..color = color;
    pixels.forEach((f) {
      f.update(digits.inflate(size.width * 0.8, clockHeight, heightOffset));
      f.render(canvas, paint);
    });
  }

  void resize(Size size) {
    pixels = List();
    // double radius = 15.0;
    double radius = size.width / 34;
    double w = size.width / radius;
    double h = size.height / radius;

    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        double x = i * radius;
        double y = (j * radius);
        pixels.add(
            CirclePixel(x + (j % 2 == 0 ? radius / 2 : 0), y, radius * .43));
      }
    }
  }

  @override
  bool shouldRepaint(ClockCanvas oldDelegate) {
    return true;
  }
}

class CirclePixel {
  double x;
  double y;
  double maxRadius;
  double radius = 1.0;

  CirclePixel(this.x, this.y, this.maxRadius);

  void render(Canvas canvas, Paint paint) {
    canvas.drawCircle(Offset(x, y), radius, paint);
  }

  void update(List<List<double>> array) {
    radius = 0;
    array.forEach((i) {
      var distance = hypot(x - i[0], y - i[1]);
      radius = math.max(
          maxRadius * math.pow(((maxRadius * 1.9) / distance), 3.5), radius);
    });
    radius = math.min(radius, maxRadius);
    if (radius < 0.1) radius = 0;
  }

  double hypot(double x, double y) {
    return math.sqrt(x * x + y * y);
  }
}
