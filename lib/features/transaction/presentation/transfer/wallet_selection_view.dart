import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:klip/core/routes/app_router.dart';
import 'package:klip/gen/assets.gen.dart';

class WalletSelectionView extends StatelessWidget {
  const WalletSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final b16 = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    final m14 = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 14,
    );

    final l12 = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w300,
      fontSize: 12,
    );

    return Scaffold(
      appBar: AppBar(
        leading: Assets.svgIcons.backIcon.svg(width: 20, height: 20),
        centerTitle: false,
        title: Text("Transfer", style: b16),
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 18.0) +
            const EdgeInsets.only(top: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 11,
          children: [
            Text("Choose  how to transfer crypto", style: b16),
            const SizedBox(height: 51),

            // ~ Savings Wallet option
            // TODO(4.4): wire to savings-wallet transfer flow (Group 4)
            GestureDetector(
              onTap: () {
                context.go(AppRoutes.transactionSuccessful);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(0xFF114522),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Your Savings Wallet", style: m14),
                    Text("Your self custody wallet", style: l12),
                  ],
                ),
              ),
            ),

            // ~ External Wallet option
            GestureDetector(
              onTap: () {
                context.go(AppRoutes.destinationInput);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  color: Color(0xFF114522),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("External Wallet", style: m14),
                    Text("Crypto address is required ", style: l12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
