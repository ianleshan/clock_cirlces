import 'package:digital_clock/numbers.dart';

class LEDDisplay {
  DigitDisplay hourTens, hourOnes, colon, minuteTens, minuteOnes;

  LEDDisplay() {
    hourTens = DigitDisplay(Numbers().zero);
    hourOnes = DigitDisplay(Numbers().zero);
    minuteTens = DigitDisplay(Numbers().zero);
    minuteOnes = DigitDisplay(Numbers().zero);
  }

  void startAnimation(String clock) {
    hourTens.startAnimation(Numbers().getPoints(int.parse(clock[0])));
    hourOnes.startAnimation(Numbers().getPoints(int.parse(clock[1])));
    minuteTens.startAnimation(Numbers().getPoints(int.parse(clock[2])));
    minuteOnes.startAnimation(Numbers().getPoints(int.parse(clock[3])));
  }

  void animate(double value) {
    hourTens.animate(value);
    hourOnes.animate(value);
    minuteTens.animate(value);
    minuteOnes.animate(value);
  }

  List<List<double>> inflate(double w, double h, double heightOffset) {
    var width = w / 3;
    return hourTens.inflate(width, h, 0.0, heightOffset)
      ..addAll(hourOnes.inflate(width, h, 0.8, heightOffset))
      ..addAll(minuteTens.inflate(width, h, 2.0, heightOffset))
      ..addAll(minuteOnes.inflate(width, h, 2.8, heightOffset));
  }
}

class DigitDisplay {
  List<List<double>> array;
  List<List<double>> origin;
  List<List<double>> target;

  DigitDisplay(List<List<double>> a) {
    this.array = a.toList();
  }

  void startAnimation(List<List<double>> animateTo) {
    origin = List.from(array);
    target = List.from(animateTo);
  }

  void animate(double value) {
    for (var i = 0; i < array.length; i++) {
      array[i][0] = origin[i][0] + ((target[i][0] - origin[i][0]) * value);
      array[i][1] = origin[i][1] + ((target[i][1] - origin[i][1]) * value);
    }
  }

  List<List<double>> inflate(double w, double h, double o, double c) {
    return array.map((f) {
      return [(f[0] + o) * w, (f[1] * h) + c];
    }).toList();
  }
}
