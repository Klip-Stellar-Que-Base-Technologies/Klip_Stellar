import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klip/gen/assets.gen.dart';
import 'package:klip/gen/colors.gen.dart';
import 'package:klip/shared/style/text_style.dart';
import 'package:klip/shared/widget/klip_app_bar.dart';
import 'package:klip/shared/widget/liquid_glass_texture.dart';

class SavingsView extends ConsumerWidget {
  const SavingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: klipsAppBar(),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 18) +
            const EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // ~ Top box texture
            LiquidGlassTexture(
              backgroundColor: ColorName.greenBackground.withValues(alpha: .3),
              width: double.infinity,
              height: 349.h,
              child: Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ~ Wallet address
                    Row(
                      spacing: 10,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Assets.svgIcons.walletIcon.svg(),
                        Text(
                          "0X45690Qws59957865REkn.....",
                          style: AppTextStyle.m14,
                        ),
                      ],
                    ),

                    // ~ Saving CHart
                    Center(
                      child: SizedBox(width: 171.w, height: 171.h),
                      
                    ),

                    SizedBox(height: 10.h),

                    // ~ Saving Witdrawal button
                    SizedBox(
                      width: 275.w,
                      child: LiquidGlassButton(
                        width: 257.w,
                        onTap: () {},
                        child: Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Assets.svgIcons.walletIcon.svg(),
                            Text(
                              "Withdrawal to Main Wallet",
                              style: AppTextStyle.sb16,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 28.h),

                    tag("Total Amount Locked", Color(0xFF551BF9)),
                    tag("Total amount Saved ", ColorName.checkLinear2),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            LiquidGlassTexture(
              backgroundColor: Color(0xFF8D5D33).withValues(alpha: .2),
              borderRadius: 8,
              width: 291.w,
              height: 60.h,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Text(
                  "Stake up to \$2000 in your  Savings wallet to earn 0.3% of your stock",
                  style: AppTextStyle.m12,
                  textAlign: TextAlign.center,
                ),
              ),
            ),

            const SizedBox(height: 50),
            // TODO(5.2): replace with real data from transaction history provider
            _transctionBlock(false),
          ],
        ),
      ),
    );
  }

  Widget tag(String label, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 13,
      children: [
        Container(
          width: 17,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        Text(label),
      ],
    );
  }

  Widget _transctionBlock(bool withTransaction) {
    return !withTransaction
        ? Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 12,
            children: [
              Assets.svgIcons.waitingIcon.svg(),
              Text(
                "No Transactions Yet",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          )
        : Column(children: []);
  }
}
