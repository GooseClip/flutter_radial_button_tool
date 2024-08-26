import 'package:flutter/widgets.dart';
import 'dart:math' as math;

class SectorClipper extends CustomClipper<Path> {
  SectorClipper({
    required this.sweepAngle,
    required this.innerRadius,
    required this.outerRadius,
  });

  final double sweepAngle, innerRadius, outerRadius;

  double halfDeltaY() {
    final halfAngle = sweepAngle / 2;
    return outerRadius * math.tan(halfAngle);
  }

  @override
  Path getClip(Size size) {
    var path = Path();
    final radius = outerRadius;
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Create inverted triangle
    final dy = halfDeltaY();
    path
      ..moveTo(centerX, centerY)
      ..lineTo(centerX - dy, centerY - radius)
      ..lineTo(centerX + dy, centerY - radius)
      ..close();

    // Clip ring
    Path innerCircle = Path()
      ..addOval(Rect.fromCircle(
          center: Offset(centerX, centerY), radius: innerRadius));
    Path outerCircle = Path()
      ..addOval(Rect.fromCircle(
          center: Offset(centerX, centerY), radius: outerRadius));

    // Combine paths to create a sector
    final ring =
        Path.combine(PathOperation.difference, outerCircle, innerCircle);
    path = Path.combine(PathOperation.intersect, path, ring);


    return path;
  }

  @override
  bool shouldReclip(SectorClipper oldClipper) {
    return oldClipper.sweepAngle != sweepAngle ||
        oldClipper.innerRadius != innerRadius ||
        oldClipper.outerRadius != outerRadius;
  }
}
