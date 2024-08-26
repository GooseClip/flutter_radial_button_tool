import 'package:flutter/widgets.dart';
import 'dart:math' as math;

class RadiatingLinesClipper extends CustomClipper<Path> {
  RadiatingLinesClipper({
    required this.lines,
    required this.width,
    required this.offsetAngle,
    required this.radius,
  });

  final int lines;
  final double width;
  final double offsetAngle;
  final double radius;

  @override
  Path getClip(Size size) {
    Path path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Add the circular path
    path.addOval(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius));

    // Subtract the radial line paths
    for (int i = 0; i < lines; i++) {
      final linePath = Path()
        ..moveTo(centerX, centerX)
        ..relativeLineTo(-width / 2, 0)
        ..relativeLineTo(0, radius)
        ..relativeLineTo(width, 0)
        ..relativeLineTo(0, -radius)
        ..lineTo(centerX, centerY);
      final angle = (2 * math.pi / lines) * i + offsetAngle;
      final matrix = Matrix4.identity()
        ..translate(centerX, centerY)
        ..rotateZ(angle)
        ..translate(-centerX, -centerY);
      final rotatedLinePath = linePath.transform(matrix.storage);
      // Subtract the line path from the main path
      path = Path.combine(PathOperation.difference, path, rotatedLinePath);
    }

    return path;
  }

  @override
  bool shouldReclip(RadiatingLinesClipper oldClipper) =>
      oldClipper.lines != lines || oldClipper.width != width;
}
