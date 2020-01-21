import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

///Primary Color of Twitter
const kTwitterPrimaryColor = Color(0xFF1da1f2);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: TwitterSpinner(),
        ),
      ),
    );
  }
}

class TwitterSpinner extends StatefulWidget {
  @override
  _TwitterSpinnerState createState() => _TwitterSpinnerState();
}

class _TwitterSpinnerState extends State<TwitterSpinner>
    with TickerProviderStateMixin {

  AnimationController _controller;
  Animation startAngleAnimation;
  Tween<double> startAngleTween = Tween(begin: 0, end: 2 * pi);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1, milliseconds: 500),
    )..addListener(() {
        setState(() {});
      });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.forward(from: 0);
      }
    });

    startAngleAnimation = startAngleTween.animate(CurvedAnimation(
      curve: Curves.linear,
      parent: _controller,
    ));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TwitterSpinnerPainter(startAngleAnimation.value),
    );
  }
}

class TwitterSpinnerPainter extends CustomPainter {
  double startAngle;

  TwitterSpinnerPainter(this.startAngle);

  @override
  void paint(Canvas canvas, Size size) {
    double radius = 25;
    double outerCirclePercent = 20;
    double width = 8;

    Paint innerCirclePaint = Paint()
      ..color = kTwitterPrimaryColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Paint outerCirclePaint = Paint()
      ..color = kTwitterPrimaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Offset center = new Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, radius, innerCirclePaint);

    double arcAngle = 2 * pi * (outerCirclePercent / 100);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        arcAngle, false, outerCirclePaint);
  }

  @override
  bool shouldRepaint(TwitterSpinnerPainter oldDelegate) {
    return startAngle != oldDelegate.startAngle;
  }
}
