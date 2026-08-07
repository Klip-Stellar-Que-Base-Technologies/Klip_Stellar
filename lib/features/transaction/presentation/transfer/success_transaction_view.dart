import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:klip/core/routes/app_router.dart';
import 'package:klip/gen/assets.gen.dart';
import 'package:klip/shared/style/text_style.dart';
import 'package:klip/shared/widget/liquid_glass_texture.dart';
import 'package:share_plus/share_plus.dart';

/// Data class holding receipt information for completed transactions.
class TransactionReceipt {
  final String amount;
  final String asset;
  final String recipient;
  final String hash;
  final String fee;
  final DateTime timestamp;

  const TransactionReceipt({
    required this.amount,
    required this.asset,
    required this.recipient,
    required this.hash,
    required this.fee,
    required this.timestamp,
  });
}

class SuccessTransactionView extends StatelessWidget {
  final TransactionReceipt? receipt;

  const SuccessTransactionView({
    super.key,
    this.receipt,
  });

  @override
  Widget build(BuildContext context) {
    final displayAmount = receipt?.amount ?? "4000 USDT";
    final recipientStr = receipt?.recipient ?? "Activated";
    final truncatedRecipient = recipientStr.length > 12
        ? "${recipientStr.substring(0, 6)}...${recipientStr.substring(recipientStr.length - 6)}"
        : recipientStr;
    final assetStr = receipt?.asset ?? "Solana";
    final feeStr = receipt?.fee ?? "0.00001 XLM";
    final txHash = receipt?.hash ?? "N/A";

    void handleShareReceipt() {
      final shareText = '''
🧾 Klip Transaction Receipt
----------------------------
Status: Successful
Amount: $displayAmount
Recipient: $recipientStr
Asset: $assetStr
Fee: $feeStr
Transaction Hash: $txHash
Date: ${receipt?.timestamp ?? DateTime.now()}
----------------------------
Sent via Klip Wallet
''';
      Share.share(shareText, subject: 'Klip Transaction Receipt');
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Assets.png.bluredBackground.image(),
                  Assets.svgIcons.checkIcon.svg(),
                ],
              ),
              SizedBox(height: 10.h),
              Text("Successfully Sent", style: AppTextStyle.r18),
              SizedBox(height: 28.h),
              Text(displayAmount, style: AppTextStyle.b32),
              SizedBox(height: 28.h),
              LiquidGlassTexture(
                width: double.infinity,
                height: 140.h,
                borderRadius: 8,
                child: Padding(
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TipicalRow(
                        label: "Status",
                        seconderyLabel: "Confirmed",
                        color: const Color(0xFF057029),
                      ),

                      // ~ Divider
                      Container(height: 1, color: Colors.white30),

                      TipicalRow(
                        label: "Recipient",
                        seconderyLabel: truncatedRecipient,
                        color: const Color(0xFF114522),
                      ),

                      // ~ Divider
                      Container(height: 1, color: Colors.white30),

                      TipicalRow(
                        label: "Asset / Fee",
                        seconderyLabel: "$assetStr ($feeStr)",
                        color: const Color(0xFF551BF9),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 60.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ~ Done Button
                  LiquidGlassButton(
                    backgroundColor: const Color(0xFF057029),
                    height: 44.h,
                    width: 160.w,
                    onTap: () {
                      context.go(AppRoutes.homeRoute);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Done",
                          style: AppTextStyle.sb16,
                        ),
                      ],
                    ),
                  ),

                  // ~ Share Receipt Button
                  LiquidGlassButton(
                    height: 44.h,
                    width: 160.w,
                    onTap: handleShareReceipt,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.svgIcons.shareIcon.svg(),
                        SizedBox(width: 8.w),
                        Text(
                          "Share Receipt",
                          style: AppTextStyle.sb16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
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
          style: AppTextStyle.m12,
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(100.r),
          ),
          child: Text(
            seconderyLabel,
            style: AppTextStyle.m12,
          ),
        ),
      ],
    );
  }
}
