import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:klip/core/routes/app_router.dart';
import 'package:klip/core/stellar/stellar_provider.dart';
import 'package:klip/gen/assets.gen.dart';
import 'package:klip/shared/style/text_style.dart';
import 'package:klip/shared/widget/liquid_glass_texture.dart';

class ImportWalletView extends ConsumerStatefulWidget {
  const ImportWalletView({super.key});

  @override
  ConsumerState<ImportWalletView> createState() => _ImportWalletViewState();
}

class _ImportWalletViewState extends ConsumerState<ImportWalletView> {
  final _seedController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _seedController.dispose();
    super.dispose();
  }

  Future<void> _import() async {
    final seed = _seedController.text.trim();
    if (seed.isEmpty) {
      setState(() => _errorMessage = 'Please enter a secret seed.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ref.read(walletKeypairProvider.notifier).importFromSeed(seed);
      // Invalidate balance so it refreshes for the new keypair.
      ref.invalidate(xlmBalanceProvider);
      if (mounted) context.go(AppRoutes.homeRoute);
    } catch (e) {
      setState(() {
        _errorMessage = 'Invalid secret seed. Please check and try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Assets.svgIcons.backIcon.svg(width: 20, height: 20),
        ),
        centerTitle: false,
        title: Text('Import Wallet', style: AppTextStyle.b16),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w)
            .add(EdgeInsets.only(top: 32.h)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter your secret seed', style: AppTextStyle.b16),
            SizedBox(height: 8.h),
            Text(
              'Your 56-character Stellar secret key starting with "S".',
              style: AppTextStyle.l12,
            ),
            SizedBox(height: 24.h),

            // ~ Seed input
            LiquidGlassTexture(
              width: double.infinity,
              height: 70.h,
              borderRadius: 12,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                child: TextField(
                  controller: _seedController,
                  obscureText: true,
                  maxLines: 1,
                  style: AppTextStyle.m14,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'S...',
                    hintStyle: TextStyle(color: Colors.white38),
                  ),
                ),
              ),
            ),

            if (_errorMessage != null) ...[
              SizedBox(height: 10.h),
              Text(
                _errorMessage!,
                style: AppTextStyle.l12.copyWith(color: Colors.redAccent),
              ),
            ],

            SizedBox(height: 32.h),

            // ~ Import button
            LiquidGlassButton(
              width: double.infinity,
              onTap: _isLoading ? () {} : _import,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text('Import Wallet', style: AppTextStyle.sb16),
            ),

            SizedBox(height: 16.h),

            Center(
              child: Text(
                '⚠️  Never share your secret seed with anyone.',
                style: AppTextStyle.l12.copyWith(color: Colors.orange),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
