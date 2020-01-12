/*
* Port of clock draw 
*/

import 'dart:math';


import 'package:flutter/material.dart';
import './theme.dart';
ThemeData customTheme;
enum faceType { Seconds, Hours }

class ClockFace extends StatefulWidget {
  @override
  _Face createState() => _Face();
}

class _Face extends State<ClockFace> {
  double widthHeight;

  @override
  Widget build(BuildContext context) {
    widthHeight = min(
      MediaQuery.of(context).size.height,
      MediaQuery.of(context).size.width,
    );
    customTheme = themeData(context);
    return Center(
      child: Container(
        padding: EdgeInsets.only(left: 21, top: 6, right: 5, bottom: 5),
        width: widthHeight,
        height: widthHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            image: customTheme.brightness == Brightness.light
                ? AssetImage('clock_bg.png') // draw brightness background
                : AssetImage('clock_bg_dark.png'), // or dark background
          ),
        ),
        child: CustomPaint(
          painter: FacePainter(),
        ),
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  static double radius;
  double angle;
  int tickLength;

  static TextStyle getTextStyle() {
    return TextStyle(
        fontSize: radius == null ? 0 : radius * 0.109,
        fontWeight: FontWeight.w900,
        color: customTheme.highlightColor);
  }

  TextPainter textPainter = TextPainter(
    textDirection: TextDirection.rtl,
    textAlign: TextAlign.center,
  );
  TextStyle fifthsNumberTextStyle = getTextStyle();

  TextStyle nonTheFifthsNumbersTextStyle = TextStyle(
    fontSize: radius == null ? 0 : radius * 0.055,
    fontWeight: FontWeight.w900,
    color: customTheme.accentColor.withOpacity(0.8),
  );

  Paint nonFifthsTicksPaint = Paint() // non Fifths Ticks
    ..color = customTheme.accentColor
    ..strokeWidth = 3
    ..style = PaintingStyle.stroke;

  Paint FifthsTicksPaint = Paint() // Fifths Ticks
    ..color = customTheme.highlightColor
    ..strokeWidth = 10
    ..style = PaintingStyle.stroke;

  Paint circlesPaint = Paint()
    ..strokeWidth = 1.0
    ..color = customTheme.highlightColor.withOpacity(0.3)
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    radius = min(size.width / 2, size.height / 2); // نصف القطر
    angle = 2 * (pi / 60); // الزاوية
    drawFace(canvas, size, faceType.Seconds); // draw seconds,minuts ticks,numbers
    drawFace(canvas, size, faceType.Hours);   // draw hours ticks,numbers
  }

  void drawFace(Canvas canvas, Size size, faceType type) {
    double _radius = radius;
    double _spaceText;
    int numbersRange;
    TextStyle style;

    if (type == faceType.Hours) {
//      draw hours only
      style = TextStyle(
          // style of hours port
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: customTheme.primaryColor);
      _radius = radius * 0.70;
      _spaceText = 30;    //distance Numbers to ring of hours
      numbersRange = 12;  // maximum number og range
    } else {
      style = TextStyle(
        // style of seconds/minutes port
        fontSize: 16,
        fontWeight: FontWeight.w900,
        color: customTheme.primaryColor,
      );
      _radius = radius;
      _spaceText = 33;
      numbersRange = 60;
    }

    canvas.save();
    canvas.translate(radius, radius); // Translate painter to center of circle
    //draw circles of seconds , hours..

//    canvas.drawCircle(Offset(0, 0), _radius * 1.02, circlesPaint);

    for (int i = 0; i < 60; i++) {
      // length of tick for fifths point or others.
      tickLength = i % 5 == 0
          ? 10  // fifths
          : 3;  // non fifths

      //ticks draw
      canvas.drawLine(Offset(0, -_radius), Offset(0, -_radius + tickLength),
          i % 5 != 0 ? nonFifthsTicksPaint : FifthsTicksPaint);

      bool isSecondNonFifths = type == faceType.Seconds && i % 5 != 0;
      bool isSecondAndFifths = type == faceType.Seconds && i % 5 == 0;
      bool isFifths = i % 5 == 0;

      // Paint Numbers ...

      if (isSecondNonFifths) {
        textPainter.text =
            TextSpan(text: '${i}', style: nonTheFifthsNumbersTextStyle);
      } else if (isFifths) {
        textPainter.text = TextSpan(
            text:
                '${i == 0 ? numbersRange : type == faceType.Hours ? i ~/ 5 : i}',
            style: fifthsNumberTextStyle);
      } else {}

      painting(i, _radius, _spaceText, type, textPainter, canvas, isFifths);
    }
    canvas.restore();
  }

  void painting(i, double _radius, double _spaceText, faceType type,
      TextPainter textPainter, Canvas canvas, bool isFifths) {
    canvas.save();
    if (type == faceType.Hours) {
      canvas.translate(0, -_radius + (isFifths ? _spaceText : 11));
    } else {
      canvas.translate(0, -_radius + (isFifths ? _spaceText : 15));
    }
    canvas.rotate(-angle * i);
    textPainter.layout();
    if (type == faceType.Hours) {
      if (i % 5 == 0) {
        textPainter.paint(canvas,
            Offset(-(textPainter.width / 2), -(textPainter.height / 2)));
      }
    } else {
      textPainter.paint(
          canvas, Offset(-(textPainter.width / 2), -(textPainter.height / 2)));
    }
    canvas.restore();
    canvas.rotate(angle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != oldDelegate;
  }

} // End of FacePainter class
