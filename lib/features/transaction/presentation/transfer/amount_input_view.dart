import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:klip/core/routes/app_router.dart';
import 'package:klip/core/stellar/stellar_provider.dart';
import 'package:klip/features/transaction/presentation/transfer/success_transaction_view.dart';
import 'package:klip/gen/assets.gen.dart';
import 'package:klip/shared/style/text_style.dart';
import 'package:klip/shared/widget/liquid_glass_texture.dart';

/// Screen to select asset, enter transfer amount, preview fee, and execute transaction.
class AmountInputView extends HookConsumerWidget {
  final String destinationAddress;

  const AmountInputView({
    super.key,
    required this.destinationAddress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final amountController = useTextEditingController();
    final memoController = useTextEditingController();
    final selectedAsset = useState<String>('XLM');
    final isSubmitting = useState<bool>(false);
    final errorMessage = useState<String?>(null);

    final xlmBalanceAsync = ref.watch(xlmBalanceProvider);
    final availableBalanceStr = xlmBalanceAsync.value ?? '0.00';
    final availableBalance = double.tryParse(availableBalanceStr) ?? 0.0;
    const baseFeeXlm = '0.00001 XLM'; // 100 Stroops standard base fee

    Future<void> handleSend() async {
      final inputStr = amountController.text.trim();
      final amount = double.tryParse(inputStr);

      if (amount == null || amount <= 0) {
        errorMessage.value = 'Please enter a valid amount greater than 0';
        return;
      }

      if (amount > availableBalance) {
        errorMessage.value = 'Insufficient balance. Max available: $availableBalanceStr XLM';
        return;
      }

      errorMessage.value = null;
      isSubmitting.value = true;

      try {
        final service = ref.read(stellarServiceProvider);
        final memoText = memoController.text.trim();
        final response = await service.sendPayment(
          destinationId: destinationAddress,
          amount: inputStr,
          memo: memoText.isNotEmpty ? memoText : null,
        );

        ref.invalidate(xlmBalanceProvider);

        final receipt = TransactionReceipt(
          amount: '$inputStr ${selectedAsset.value}',
          asset: selectedAsset.value,
          recipient: destinationAddress,
          hash: response.hash ?? 'N/A',
          fee: baseFeeXlm,
          timestamp: DateTime.now(),
        );

        if (context.mounted) {
          context.go(AppRoutes.transactionSuccessful, extra: receipt);
        }
      } catch (e) {
        errorMessage.value = 'Transaction failed: ${e.toString().replaceAll("Exception: ", "")}';
      } finally {
        isSubmitting.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Assets.svgIcons.backIcon.svg(width: 20, height: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.destinationInput);
            }
          },
        ),
        title: Text("Transfer Amount", style: AppTextStyle.b16),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipient summary
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Recipient Address", style: AppTextStyle.r12.copyWith(color: Colors.white70)),
                    SizedBox(height: 4.h),
                    Text(
                      destinationAddress,
                      style: AppTextStyle.m14.copyWith(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Asset Selector & Balance
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: selectedAsset.value,
                    dropdownColor: const Color(0xFF114522),
                    style: AppTextStyle.b16,
                    items: const [
                      DropdownMenuItem(
                        value: 'XLM',
                        child: Text('XLM (Stellar Lumens)'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) selectedAsset.value = val;
                    },
                  ),
                  Text(
                    "Balance: $availableBalanceStr XLM",
                    style: AppTextStyle.r12.copyWith(color: Colors.white70),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              // Amount input
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: AppTextStyle.b20,
                decoration: InputDecoration(
                  labelText: "Amount",
                  hintText: "0.00",
                  suffixText: selectedAsset.value,
                  suffixStyle: AppTextStyle.sb16,
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                onChanged: (_) {
                  if (errorMessage.value != null) errorMessage.value = null;
                },
              ),

              SizedBox(height: 16.h),

              // Optional Memo input
              TextField(
                controller: memoController,
                style: AppTextStyle.m14,
                decoration: InputDecoration(
                  labelText: "Memo (Optional)",
                  hintText: "Payment note",
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Fee Preview Section (Sub-issue 4.3)
              Container(
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: const Color(0xFF114522).withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Network Fee", style: AppTextStyle.r12),
                        Text(baseFeeXlm, style: AppTextStyle.sb12.copyWith(color: Colors.amber)),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Network", style: AppTextStyle.r12),
                        Text("Stellar Testnet", style: AppTextStyle.m12),
                      ],
                    ),
                  ],
                ),
              ),

              if (errorMessage.value != null) ...[
                SizedBox(height: 16.h),
                Text(
                  errorMessage.value!,
                  style: AppTextStyle.r12.copyWith(color: Colors.redAccent),
                ),
              ],

              SizedBox(height: 36.h),

              LiquidGlassButton(
                width: double.infinity,
                backgroundColor: const Color(0xFF057029),
                onTap: isSubmitting.value ? () {} : handleSend,
                child: isSubmitting.value
                    ? SizedBox(
                        width: 20.r,
                        height: 20.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text("Confirm & Send", style: AppTextStyle.sb16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
