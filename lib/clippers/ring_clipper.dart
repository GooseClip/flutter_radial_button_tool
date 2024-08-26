import 'package:flutter/widgets.dart';

class RingClipper extends CustomClipper<Path> {
  final double innerRadius, outerRadius;

  RingClipper({required this.innerRadius, required this.outerRadius});

  @override
  Path getClip(Size size) {
    Path path = Path();
    double centerX = size.width / 2;
    double centerY = size.height / 2;

    // Inner circle
    Path innerCircle = Path()
      ..addOval(Rect.fromCircle(
          center: Offset(centerX, centerY), radius: innerRadius));

    // Outer circle
    Path outerCircle = Path()
      ..addOval(Rect.fromCircle(
          center: Offset(centerX, centerY), radius: outerRadius));

    // Combine paths to create a ring
    path = Path.combine(PathOperation.difference, outerCircle, innerCircle);
    return path;
  }

  @override
  bool shouldReclip(RingClipper oldClipper) =>
      oldClipper.innerRadius != innerRadius ||
      oldClipper.outerRadius != outerRadius;
}
