import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:klip/core/routes/app_router.dart';
import 'package:klip/gen/assets.gen.dart';
import 'package:klip/shared/style/text_style.dart';
import 'package:klip/shared/widget/liquid_glass_texture.dart';

/// Screen to input destination Stellar wallet address for transfer.
class DestinationInputView extends HookConsumerWidget {
  const DestinationInputView({super.key});

  static bool isValidStellarAddress(String address) {
    final trimmed = address.trim();
    // Standard Stellar public keys start with 'G' and are 56 characters long.
    return trimmed.startsWith('G') && trimmed.length == 56;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();
    final errorText = useState<String?>(null);

    void handleContinue() {
      final address = controller.text.trim();
      if (!isValidStellarAddress(address)) {
        errorText.value = 'Invalid Stellar public key. Must start with G (56 chars).';
        return;
      }
      errorText.value = null;
      context.go(AppRoutes.amountInput, extra: address);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Assets.svgIcons.backIcon.svg(width: 20, height: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.transactionWalletSelection);
            }
          },
        ),
        title: Text("Destination Address", style: AppTextStyle.b16),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter Recipient Address",
                style: AppTextStyle.sb16,
              ),
              SizedBox(height: 8.h),
              Text(
                "Enter the 56-character Stellar public key (starts with G)",
                style: AppTextStyle.r12.copyWith(color: Colors.white70),
              ),
              SizedBox(height: 24.h),

              TextField(
                controller: controller,
                maxLines: 2,
                style: AppTextStyle.m14,
                decoration: InputDecoration(
                  hintText: "G...",
                  hintStyle: AppTextStyle.r14.copyWith(color: Colors.white38),
                  errorText: errorText.value,
                  errorMaxLines: 2,
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFF057029)),
                  ),
                ),
                onChanged: (_) {
                  if (errorText.value != null) {
                    errorText.value = null;
                  }
                },
              ),

              const Spacer(),

              LiquidGlassButton(
                width: double.infinity,
                backgroundColor: const Color(0xFF057029),
                onTap: handleContinue,
                child: Text("Continue to Amount", style: AppTextStyle.sb16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
