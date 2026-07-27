import 'dart:ui';

import 'package:flutter/material.dart';

class LiquidGlassButton extends StatefulWidget {
  final VoidCallback onTap;
  final EdgeInsets padding;
  final Color backgroundColor;
  final Widget child;
  final double width;
  final double height;
  final double borderRadius;

  const LiquidGlassButton({
    super.key,
    required this.onTap,
    required this.child,
    this.padding = const EdgeInsets.all(10),
    this.backgroundColor = Colors.transparent,
    this.width = 180,
    this.height = 56,
    this.borderRadius = 28,
  });

  @override
  State<LiquidGlassButton> createState() => _LiquidGlassButtonState();
}

class _LiquidGlassButtonState extends State<LiquidGlassButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        // width: widget.width,
        // height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40, sigmaY: 10),
            child: Container(
              padding: widget.padding,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                // color: Colors.blueAccent,
                // gradient: LinearGradient(
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                //   colors: [
                //     Colors.white.withValues(alpha: 0.1),
                //     Colors.black.withValues(alpha: 0.1),
                //   ],
                // ),
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1.2,
                ),
              ),
              child: Stack(
                children: [
                  // Shine effect
                  /* Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 56 * 0.4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0),
                            Colors.white.withOpacity(0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(widget.borderRadius),
                        ),
                      ),
                    ),
                  ), */
                  // Content
                  Center(child: widget.child),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LiquidGlassTexture extends StatefulWidget {
  final Color backgroundColor;
  final Widget child;
  final double width;
  final double height;
  final double borderRadius;

  const LiquidGlassTexture({
    super.key,
    required this.child,
    this.backgroundColor = Colors.transparent,
    this.width = 180,
    this.height = 56,
    this.borderRadius = 28,
  });

  @override
  State<LiquidGlassTexture> createState() => _LiquidGlassTextureState();
}

class _LiquidGlassTextureState extends State<LiquidGlassTexture> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          // :
          // [
          //     BoxShadow(
          //       color: Colors.black.withOpacity(0.1),
          //       blurRadius: 20,
          //       offset: const Offset(0, 10),
          //     ),
          //     BoxShadow(
          //       color: Colors.white.withOpacity(0.1),
          //       blurRadius: 10,
          //       offset: const Offset(0, -5),
          //     ),
          //   ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                // gradient: LinearGradient(
                //   begin: Alignment.center,
                //   end: Alignment.bottomRight,
                //   colors: [
                //     Colors.white.withValues(alpha: .1),
                //     Colors.white.withValues(alpha: .1),
                //   ],
                // ),
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1.5,
                ),
              ),
              child: Stack(
                children: [
                  // Shine effect
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: widget.height,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          // begin: Alignment.topLeft,
                          begin: AlignmentGeometry.xy(-1, -2.5),
                          end: AlignmentGeometry.xy(1, 2.5),
                          colors: [
                            Colors.black.withValues(alpha: .1),
                            Colors.white.withValues(alpha: .1),
                          ],
                        ),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(widget.borderRadius),
                        ),
                      ),
                    ),
                  ),
                  // Content
                  Center(child: widget.child),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
