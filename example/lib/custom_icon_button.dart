import 'dart:math';

import 'package:flutter/material.dart';

class CustomIconButton extends StatefulWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.onStartPress,
    this.padding,
    this.size,
    this.enabled = true,
    this.rotation,
    this.keyboardHint,
    this.iconColor,
  });

  final IconData? icon;
  final ValueSetter<BuildContext> onPressed;
  final VoidCallback? onStartPress;
  final double? size;
  final EdgeInsets? padding;
  final bool enabled;
  final String? keyboardHint;
  final double? rotation;
  final Color? iconColor;

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController anim;

  @override
  void initState() {
    super.initState();
    anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    anim.stop(canceled: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (!widget.enabled) {
          return;
        }
        widget.onStartPress?.call();
      },
      onTap: widget.enabled
          ? () async {
              anim.duration = const Duration(milliseconds: 120);
              anim.reset();
              await anim.forward();
              widget.onPressed(context);
              await anim.reverse();
            }
          : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Colors.transparent,
            // Transparency allows gesture detection on padding
            child: Padding(
              padding: widget.padding ?? const EdgeInsets.all(8),
              child: AnimatedBuilder(
                animation: anim,
                builder: (BuildContext context, Widget? child) {
                  final scale = anim.value / 3;
                  return Transform.scale(
                    scale: 1 - Curves.easeOutQuad.transform(scale),
                    child: Opacity(opacity: 1 - anim.value / 3, child: child),
                  );
                },
                child: widget.rotation == null
                    ? Icon(widget.icon,
                        size: widget.size,
                        color: widget.enabled
                            ? (widget.iconColor ?? Colors.white)
                            : Colors.white38)
                    : Transform.rotate(
                        angle: widget.rotation! * (pi / 180),
                        child: Icon(widget.icon,
                            size: widget.size,
                            color: widget.enabled
                                ? (widget.iconColor ?? Colors.white)
                                : Colors.white38)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
