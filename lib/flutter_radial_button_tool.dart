library flutter_radial_button_tool;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_radial_button_tool/clippers/radiating_lines_clipper.dart';
import 'package:flutter_radial_button_tool/clippers/ring_clipper.dart';
import 'dart:math' as math;

import 'package:flutter_radial_button_tool/clippers/sector_clipper.dart';

extension XRadialButton on Widget {
  RadialButton get radialButton => RadialButton(child: this);
  RadialButton get rotatedRadialButton => RadialButton(child: this, rotate: true);
}

class RadialButton {
  RadialButton({
    required this.child,
    this.rotate = false,
  });

  final Widget child;
  final bool rotate;
}

class RadialButtonTool extends StatelessWidget {
  const RadialButtonTool({
    super.key,
    required this.foregroundColors,
    required this.backgroundColors,
    required this.children,
    this.backgroundGradient,
    this.foregroundGradient,
    this.innerBorder = 2,
    this.outerBorder = 2,
    this.sideBorder = 2,
    this.thickness = 1,
    this.spacing = 2,
    this.glow = 10,
    this.centerButton,
    this.clipBehavior = Clip.antiAliasWithSaveLayer,
    this.clipChildren = true,
    this.rotateChildren = false,
    this.clampCenterButton = true,
  }) : assert(thickness >= 0.1 && thickness <= 1,
            "Thickness must be between 0 and 1");

  /// The colors to be used for the foreground sectors of the tool.
  /// Colors will be repeated if there are more sectors than colors.
  final List<Color> foregroundColors;

  /// The colors to be used for the background sectors of the tool.
  /// Colors will be repeated if there are more sectors than colors.
  final List<Color> backgroundColors;

  /// The gradient to be used for the background of the tool.
  /// const exampleGradient = RadialGradient(
  ///   colors: [
  ///     Colors.transparent,
  ///     Colors.white,
  ///   ],
  ///   radius: .5,
  /// );
  final RadialGradient? backgroundGradient;

  /// The gradient to be used for the foreground of the tool.
  final RadialGradient? foregroundGradient;

  /// The thickness of the inner border - reveals the background color.
  final double innerBorder;

  /// The thickness of the outer border - reveals the background color.
  final double outerBorder;

  /// The thickness of the side border - reveals the background color.
  final double sideBorder;

  /// The thickness of the sectors.
  final double thickness;

  /// The spacing between the sectors.
  final double spacing;

  /// Glow effect for the sectors.
  final double glow;

  /// Whether to clip the children of the sectors to the ring
  final bool clipChildren;

  /// Rotate the children to match the sectors rotation.
  final bool rotateChildren;

  /// Whether to clamp the center button to within the ring.
  final bool clampCenterButton;

  /// The the center button.
  final Widget? centerButton;

  /// The clip behavior for the sectors.
  final Clip clipBehavior;

  /// The children to be displayed in the sectors.
  final List<RadialButton> children;

  int get toolSegments => children.length;

  double get sectorAngleRad => 2 * math.pi / toolSegments;

  List<Widget> _buildChildren(double outerRadius, double thicknessPx) {
    List<Widget> icons = [];
    final innerRadius = outerRadius - thicknessPx;
    for (int i = 0; i < toolSegments; i++) {
      final angle = i * sectorAngleRad;
      icons.add(
        Transform.rotate(
          angle: children.length % 2 != 0 ? angle + sectorAngleRad * .5 : angle,
          child: ClipPath(
            clipBehavior: clipBehavior,
            clipper: RadiatingLinesClipper(
                radius: outerRadius * 2,
                lines: toolSegments,
                width: clipChildren ? spacing : spacing - sideBorder * 2,
                offsetAngle: children.length % 2 != 0 ? 0 : sectorAngleRad / 2),
            child: ClipPath(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              clipper: SectorClipper(
                sweepAngle: sectorAngleRad,
                innerRadius: clipChildren ? innerRadius + innerBorder : 0,
                outerRadius:
                    clipChildren ? outerRadius - outerBorder : outerRadius,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: clipChildren ? outerBorder : 0, bottom: clipChildren ? outerRadius * 2 - thicknessPx - innerBorder * 2 - 1: 0), // -1 as otherwise tips show unrendered
                  child: children[i].rotate
                      ? children[i].child
                      : Transform.rotate(
                          angle: (children.length % 2 != 0
                              ? angle + sectorAngleRad * .5
                              : angle) * -1,
                          child: children[i].child,
                        ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return icons;
  }

  List<Widget> _buildSectors(
      double outerRadius, double innerRadius, List<Color> colors) {
    List<Widget> sectorWidgets = [];
    for (int i = 0; i < toolSegments; i++) {
      final color = colors[i % colors.length];
      double angle = i * sectorAngleRad;
      sectorWidgets.add(
        Transform.rotate(
          angle: children.length % 2 != 0 ? angle + sectorAngleRad * .5 : angle,
          child: ClipPath(
            clipBehavior: clipBehavior,
            clipper: SectorClipper(
              sweepAngle: sectorAngleRad,
              innerRadius: innerRadius,
              outerRadius: outerRadius,
            ),
            child: Container(color: color),
          ),
        ),
      );
    }

    return sectorWidgets;
  }

  Widget _buildCenterButton(double maxRadius) {
    if (maxRadius <= 0) {
      return const SizedBox.shrink();
    }
    return Center(
      child: SizedBox(
        height: clampCenterButton ? maxRadius : double.infinity,
        width: clampCenterButton ? maxRadius : double.infinity,
        child: ClipOval(
          child: centerButton,
        ),
      ),
    );
  }

  Widget _buildGradient(
      RadialGradient gradient, double outerRadius, double innerRadius) {
    return ClipPath(
      clipBehavior: clipBehavior,
      clipper: RingClipper(
        outerRadius: outerRadius,
        innerRadius: innerRadius,
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final diameter = constraints.maxWidth;
      final radius = diameter / 2;
      final thicknessPx = radius * thickness;
      return Material(
        color: Colors.transparent,
        clipBehavior: Clip.none,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            ClipPath(
              clipBehavior: clipBehavior,
              clipper: RadiatingLinesClipper(
                  radius: diameter / 2,
                  lines: toolSegments,
                  width: spacing - sideBorder * 2,
                  offsetAngle: sectorAngleRad / 2),
              child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    ..._buildSectors(
                      radius,
                      radius - thicknessPx,
                      backgroundColors,
                    ),
                    if (backgroundGradient != null)
                      _buildGradient(
                        backgroundGradient!,
                        radius,
                        radius - thicknessPx,
                      ),
                  ]),
            ),
            if (glow > 0)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: glow, sigmaY: glow),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ClipPath(
              clipBehavior: clipBehavior,
              clipper: RadiatingLinesClipper(
                  radius: diameter / 2,
                  lines: toolSegments,
                  width: spacing,
                  offsetAngle: sectorAngleRad / 2),
              child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    ..._buildSectors(
                      radius - outerBorder,
                      radius - thicknessPx + innerBorder,
                      foregroundColors,
                    ),
                    if (foregroundGradient != null)
                      _buildGradient(
                        foregroundGradient!,
                        radius - outerBorder,
                        radius - thicknessPx + innerBorder,
                      ),
                  ]),
            ),
            ..._buildChildren(
              radius,
              thicknessPx,
            ),
            if (centerButton != null)
              _buildCenterButton(
                diameter - thicknessPx * 2 - spacing * 2 - innerBorder * 2,
              ),
          ],
        ),
      );
    });
  }
}
