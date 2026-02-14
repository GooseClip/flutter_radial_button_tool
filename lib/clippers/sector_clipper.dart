import 'package:flutter/widgets.dart';
import 'dart:math' as math;

class SectorClipper extends CustomClipper<Path> {
  SectorClipper({
    required this.sweepAngle,
    required this.innerRadius,
    required this.outerRadius,
    this.padding = 0,
    this.clipLinesWidth,
    this.outerCornerRadius = 0,
    this.innerCornerRadius = 0,
  });

  final double sweepAngle, innerRadius, outerRadius, padding;
  final double? clipLinesWidth;
  final double outerCornerRadius;
  final double innerCornerRadius;

  @override
  Path getClip(Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final center = Offset(centerX, centerY);

    // Use per-radius angular offsets so the gap is constant pixel-width
    // at both inner and outer edges (parallel-sided, not tapered).
    final halfGap = ((clipLinesWidth ?? 0) + padding) / 2;
    final halfGapOuter = outerRadius > 0 ? halfGap / outerRadius : 0.0;
    final halfGapInner = innerRadius > 0 ? halfGap / innerRadius : 0.0;

    final outerStart = -math.pi / 2 - sweepAngle / 2 + halfGapOuter;
    final outerSweep = sweepAngle - 2 * halfGapOuter;
    final innerEnd = -math.pi / 2 + sweepAngle / 2 - halfGapInner;
    final innerSweep = -(sweepAngle - 2 * halfGapInner);

    final outerRect = Rect.fromCircle(center: center, radius: outerRadius);
    final innerRect = Rect.fromCircle(center: center, radius: innerRadius);

    if (outerCornerRadius <= 0 && innerCornerRadius <= 0) {
      return Path()
        ..arcTo(outerRect, outerStart, outerSweep, true)
        ..arcTo(innerRect, innerEnd, innerSweep, false)
        ..close();
    }

    // Rounded corners via quadratic Bezier at each of the 4 junctions.
    final crO = outerCornerRadius;
    final crI = innerCornerRadius;
    final crOAngle = outerRadius > 0 ? crO / outerRadius : 0.0;
    final crIAngle = innerRadius > 0 ? crI / innerRadius : 0.0;

    Offset onCircle(double r, double a) =>
        Offset(centerX + r * math.cos(a), centerY + r * math.sin(a));

    // Corner angles
    final aAngle = outerStart; // outer-left
    final bAngle = outerStart + outerSweep; // outer-right
    final cAngle = innerEnd; // inner-right
    final dAngle = innerEnd + innerSweep; // inner-left

    // Corner points
    final a = onCircle(outerRadius, aAngle);
    final b = onCircle(outerRadius, bAngle);
    final c = onCircle(innerRadius, cAngle);
    final d = onCircle(innerRadius, dAngle);

    // Unit vectors along side edges
    final dirBC = (c - b) / (c - b).distance;
    final dirDA = (a - d) / (a - d).distance;

    // Points offset by corner radius along each edge from each corner
    final afterA = crO > 0 ? onCircle(outerRadius, aAngle + crOAngle) : a;
    final afterB = crO > 0 ? b + dirBC * crO : b;
    final beforeC = crI > 0 ? c - dirBC * crI : c;
    final afterC = crI > 0 ? onCircle(innerRadius, cAngle - crIAngle) : c;
    final afterD = crI > 0 ? d + dirDA * crI : d;
    final beforeA = crO > 0 ? a - dirDA * crO : a;

    final path = Path()..moveTo(afterA.dx, afterA.dy);

    // Outer arc
    path.arcTo(outerRect, aAngle + crOAngle, outerSweep - 2 * crOAngle, false);

    // Corner B (outer-right)
    if (crO > 0) {
      path.quadraticBezierTo(b.dx, b.dy, afterB.dx, afterB.dy);
    }

    // Right side edge
    path.lineTo(beforeC.dx, beforeC.dy);

    // Corner C (inner-right)
    if (crI > 0) {
      path.quadraticBezierTo(c.dx, c.dy, afterC.dx, afterC.dy);
    }

    // Inner arc
    path.arcTo(innerRect, cAngle - crIAngle, innerSweep + 2 * crIAngle, false);

    // Corner D (inner-left)
    if (crI > 0) {
      path.quadraticBezierTo(d.dx, d.dy, afterD.dx, afterD.dy);
    }

    // Left side edge
    path.lineTo(beforeA.dx, beforeA.dy);

    // Corner A (outer-left)
    if (crO > 0) {
      path.quadraticBezierTo(a.dx, a.dy, afterA.dx, afterA.dy);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(SectorClipper oldClipper) {
    return oldClipper.sweepAngle != sweepAngle ||
        oldClipper.innerRadius != innerRadius ||
        oldClipper.outerRadius != outerRadius ||
        oldClipper.padding != padding ||
        oldClipper.clipLinesWidth != clipLinesWidth ||
        oldClipper.outerCornerRadius != outerCornerRadius ||
        oldClipper.innerCornerRadius != innerCornerRadius;
  }
}
