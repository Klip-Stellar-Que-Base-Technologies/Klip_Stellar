import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:klip/gen/assets.gen.dart';
import 'package:klip/shared/widget/liquid_glass_texture.dart';

class SuccessTransactionView extends StatelessWidget {
  const SuccessTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    final r18 = TextStyle(color: Colors.white, fontSize: 18);
    final b32 = TextStyle(
      color: Colors.white,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: AlignmentGeometry.center,
              children: [
                Assets.png.bluredBackground.image(),
                Assets.svgIcons.checkIcon.svg(),
              ],
            ),
            const SizedBox(height: 10),
            Text("Successful Sent", style: r18),
            const SizedBox(height: 28),
            Text("4000 USDT", style: b32),
            const SizedBox(height: 28),
            LiquidGlassTexture(
              width: double.infinity,
              height: 131,
              borderRadius: 8,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TipicalRow(
                      label: "Recipient",
                      seconderyLabel: "Activated",
                      color: Color(0xFF057029),
                    ),

                    // ~ Divider
                    Container(height: 1, color: Colors.white30),

                    TipicalRow(
                      label: "Recipient",
                      seconderyLabel: "0.00 Sol",
                      color: Color(0xFF551BF9),
                    ),

                    // ~ Divider
                    Container(height: 1, color: Colors.white30),

                    TipicalRow(
                      label: "Recipient",
                      seconderyLabel: "Solana",
                      color: Color(0xFF551BF9),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ~ Transfer Button
                LiquidGlassButton(
                  backgroundColor: Color(0xFF057029),
                  height: 44,
                  width: 165,
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Done",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // ~ Withdraw Button
                LiquidGlassButton(
                  height: 44,
                  width: 165,
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Assets.svgIcons.shareIcon.svg(),
                      const SizedBox(width: 10),
                      Text(
                        "Share Recipt",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TipicalRow extends StatelessWidget {
  final Color color;
  final String label;
  final String seconderyLabel;
  const TipicalRow({
    super.key,
    required this.color,
    required this.label,
    required this.seconderyLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Spacer(),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(100),
          ), // ~ fix color
          child: Text(
            seconderyLabel,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class BlurredGradientContainer extends StatelessWidget {
  final double sigmaX;
  final double sigmaY;
  final List<Color> colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final BorderRadius? borderRadius;
  final Widget? child;

  const BlurredGradientContainer({
    super.key,
    this.sigmaX = 10,
    this.sigmaY = 10,
    this.colors = const [Colors.purple, Colors.blue],
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
    this.borderRadius,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: Container(
          width: 226,
          height: 226,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: begin,
              end: end,
              colors: colors, //.map((c) => c.withOpacity(0.7)).toList(),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
