import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgWrapper {
  final String rawSvg;

  SvgWrapper(this.rawSvg);

  Future<DrawableRoot?> generateLogo() async {
    assert(rawSvg != null);
    try {
      return await svg.fromSvgString(rawSvg, rawSvg);
    } catch (e) {
      print(e);
      return null;
    }
  }
}

class MyPainter extends CustomPainter {
  MyPainter(this.svg, this.size);

  final DrawableRoot svg;
  final Size size;
  @override
  void paint(Canvas canvas, Size size) {
    svg.scaleCanvasToViewBox(canvas, Size(180.0, 180.0));
    svg.clipCanvasToViewBox(canvas);
    svg.draw(canvas, Rect.zero);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
