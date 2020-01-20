// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:digital_clock/clock_canvas.dart';
import 'package:digital_clock/digit_display.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Theme {
  background,
  cloudy,
  foggy,
  rainy,
  snowy,
  sunny,
  thunderstorm,
  windy,
}

final _lightTheme = {
  _Theme.background: Colors.white,
  _Theme.cloudy: Colors.grey.shade800,
  _Theme.foggy: Colors.grey.shade500,
  _Theme.rainy: Colors.blue.shade700,
  _Theme.snowy: Colors.white,
  _Theme.sunny: Colors.yellow.shade800,
  _Theme.thunderstorm: Colors.blueGrey.shade400,
  _Theme.windy: Colors.green.shade700,
};

final _darkTheme = {
  _Theme.background: Colors.black,
  _Theme.cloudy: Colors.grey.shade800,
  _Theme.foggy: Colors.grey.shade500,
  _Theme.rainy: Colors.blue.shade700,
  _Theme.snowy: Colors.white,
  _Theme.sunny: Colors.yellow,
  _Theme.thunderstorm: Colors.blueGrey.shade600,
  _Theme.windy: Colors.green.shade500,
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock>
    with SingleTickerProviderStateMixin {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  LEDDisplay digitDisplay;
  Animation<double> animation;
  AnimationController controller;

  Color pixelColor = Colors.white;
  Color backgroundColor = Colors.black;

  @override
  void initState() {
    super.initState();

    digitDisplay = LEDDisplay();
    controller = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      controller.drive(
        CurveTween(
          curve: Curves.easeOutQuad,
        ),
      ),
    )..addListener(() {
        setState(() {
          digitDisplay.animate(animation.value);
        });
      });

    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  var number = 0;

  void _updateTime() {
    setState(() {
      final h = DateFormat('HH').format(_dateTime);
      final m = DateFormat('ss').format(_dateTime);
      final clock = h + m;

      digitDisplay.startAnimation(clock);
      if (number > 9) number = 0;
      controller.reset();
      controller.forward();
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;

    backgroundColor = colors[_Theme.background];

    switch (widget.model.weatherCondition) {
      case WeatherCondition.cloudy:
        pixelColor = colors[_Theme.cloudy];
        break;
      case WeatherCondition.foggy:
        pixelColor = colors[_Theme.foggy];
        break;
      case WeatherCondition.rainy:
        pixelColor = colors[_Theme.rainy];
        break;
      case WeatherCondition.snowy:
        pixelColor = colors[_Theme.snowy];
        break;
      case WeatherCondition.sunny:
        pixelColor = colors[_Theme.sunny];
        break;
      case WeatherCondition.thunderstorm:
        pixelColor = colors[_Theme.thunderstorm];
        break;
      case WeatherCondition.windy:
        pixelColor = colors[_Theme.windy];
        break;
      default:
        pixelColor = colors[_Theme.sunny];
    }

    return Container(
      child: CustomPaint(
        painter: ClockCanvas(
          digitDisplay,
          color: pixelColor,
          background: backgroundColor,
        ),
      ),
    );
  }
}
