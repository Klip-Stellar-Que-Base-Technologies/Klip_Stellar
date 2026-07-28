import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:klip/core/routes/app_router.dart';
import 'package:klip/core/stellar/stellar_provider.dart';
import 'package:klip/gen/assets.gen.dart';
import 'package:klip/gen/colors.gen.dart';
import 'package:klip/shared/style/text_style.dart';
import 'package:klip/shared/widget/klip_app_bar.dart';
import 'package:klip/shared/widget/liquid_glass_texture.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const hasTransactions = false;

    final keypairAsync = ref.watch(walletKeypairProvider);
    final address = keypairAsync.when(
      data: (kp) {
        final id = kp.accountId;
        // Show first 6 … last 6 chars
        return '${id.substring(0, 6)}...${id.substring(id.length - 6)}';
      },
      loading: () => 'Loading...',
      error: (_, __) => 'Error',
    );

    final balanceAsync = ref.watch(xlmBalanceProvider);
    final balanceLabel = balanceAsync.when(
      data: (bal) => bal != null ? '$bal XLM' : 'Unfunded',
      loading: () => '...',
      error: (_, __) => 'Error',
    );

    return Scaffold(
      appBar: klipsAppBar(),

      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: 19) + EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ~ Action Card
              LiquidGlassTexture(
                backgroundColor: ColorName.greenBackground.withValues(
                  alpha: .3,
                ),
                width: double.infinity,
                height: 224,
                borderRadius: 16,
                child: Container(
                  width: double.infinity,
                  height: 224,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 9) +
                      const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    // color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ~  Wallet Address
                      GestureDetector(
                        onTap: () {
                          final full = keypairAsync.value?.accountId;
                          if (full != null) {
                            Clipboard.setData(ClipboardData(text: full));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Address copied'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Assets.svgIcons.walletIcon.svg(),
                            Text(address, style: AppTextStyle.m14),
                          ],
                        ),
                      ),

                      const SizedBox(height: 19),

                      // ~ Wallet balance
                      Text(balanceLabel, style: AppTextStyle.b32),

                      const Spacer(),
                      // ~ Card Action
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ~ Transfer Button
                          LiquidGlassButton(
                            height: 44.h,
                            width: 120.w,
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Assets.svgIcons.walletIcon.svg(),
                                const SizedBox(width: 10),
                                Text("Transfer", style: AppTextStyle.sb16),
                              ],
                            ),
                          ),

                          // ~ Withdraw Button
                          LiquidGlassButton(
                            height: 44.h,
                            width: 143.w,
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Assets.svgIcons.walletIcon.svg(),
                                const SizedBox(width: 10),
                                Text("Withdrawal", style: AppTextStyle.sb16),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ~ Left regulation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ~ Import Wallet Button
                  LiquidGlassButton(
                    backgroundColor: ColorName.greenBackground.withValues(
                      alpha: .3,
                    ),
                    height: 44.h,
                    width: 165.w,
                    onTap: () => context.push(AppRoutes.importWallet),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.svgIcons.downloadIcon.svg(),
                        const SizedBox(width: 10),
                        Text("Import Wallet", style: AppTextStyle.sb16),
                      ],
                    ),
                  ),

                  // ~ Withdraw Button
                  LiquidGlassButton(
                    padding: const EdgeInsets.all(10),
                    height: 44.h,
                    width: 165.w,
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.svgIcons.walletIcon.svg(),
                        const SizedBox(width: 10),
                        Text("View Wallet", style: AppTextStyle.sb16),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 21),

              // ~ Funding pattern
              LiquidGlassTexture(
                borderRadius: 8.r,
                width: double.infinity,
                height: 95,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Save 100% after each payment",
                            style: AppTextStyle.m12,
                          ),
                          Spacer(),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: ColorName.greenBackground.withValues(
                                alpha: .3,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ), // ~ fix color
                            child: Text("Activated", style: AppTextStyle.m12),
                          ),
                        ],
                      ),

                      Spacer(),

                      // ~ Divider
                      Container(height: 1, color: Colors.white30),

                      Spacer(),

                      Row(
                        children: [
                          Text("Funding Sources", style: AppTextStyle.m12),
                          Spacer(),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Color(0xFF551BF9),
                              borderRadius: BorderRadius.circular(100),
                            ), // ~ fix color
                            child: Text(
                              "Funding Sources",
                              style: AppTextStyle.m12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // ~ Empty Transaction state
              const SizedBox(
                height: 50,
              ), // ~ Would not be availible on transaction
              _transctionBlock(hasTransactions),
            ],
          ),
        ),
      ),
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
              Text("No Transactions Yet", style: AppTextStyle.l12),
            ],
          )
        : Column(children: []);
  }
}
