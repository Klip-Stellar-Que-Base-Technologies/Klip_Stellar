import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:klip/core/routes/app_router.dart';
import 'package:klip/features/transaction/data/transaction_model.dart';
import 'package:klip/gen/assets.gen.dart';
import 'package:klip/shared/style/text_style.dart';
import 'package:klip/shared/widget/liquid_glass_texture.dart';

/// Screen displaying complete details for a single Stellar transaction.
class TransactionDetailView extends StatelessWidget {
  final KlipTransaction transaction;

  const TransactionDetailView({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type == KlipTransactionType.credit;
    final amountColor = isCredit ? const Color(0xFF057029) : Colors.redAccent;
    final amountPrefix = isCredit ? '+' : '-';

    void copyToClipboard(String text, String label) {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$label copied to clipboard')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Assets.svgIcons.backIcon.svg(width: 20, height: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.transaction);
            }
          },
        ),
        title: Text("Transaction Detail", style: AppTextStyle.b16),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Icon(
                isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                size: 48.r,
                color: amountColor,
              ),
              SizedBox(height: 12.h),
              Text(
                '$amountPrefix${transaction.amount} ${transaction.asset}',
                style: AppTextStyle.b32.copyWith(color: amountColor),
              ),
              SizedBox(height: 8.h),
              Text(
                isCredit ? "Received Payment" : "Sent Payment",
                style: AppTextStyle.m14.copyWith(color: Colors.white70),
              ),
              SizedBox(height: 32.h),

              LiquidGlassTexture(
                width: double.infinity,
                borderRadius: 12.r,
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    children: [
                      _DetailRow(
                        label: "Status",
                        value: transaction.isSuccessful ? "Confirmed" : "Failed",
                        valueColor: transaction.isSuccessful ? const Color(0xFF057029) : Colors.redAccent,
                      ),
                      const Divider(color: Colors.white24, height: 24),
                      _DetailRow(
                        label: isCredit ? "Sender" : "Recipient",
                        value: transaction.counterparty,
                        isCopyable: true,
                        onCopy: () => copyToClipboard(transaction.counterparty, "Address"),
                      ),
                      const Divider(color: Colors.white24, height: 24),
                      _DetailRow(
                        label: "Network Fee",
                        value: transaction.fee,
                      ),
                      const Divider(color: Colors.white24, height: 24),
                      _DetailRow(
                        label: "Memo",
                        value: transaction.memo ?? "None",
                      ),
                      const Divider(color: Colors.white24, height: 24),
                      _DetailRow(
                        label: "Transaction Hash",
                        value: transaction.hash,
                        isCopyable: true,
                        onCopy: () => copyToClipboard(transaction.hash, "Transaction Hash"),
                      ),
                      const Divider(color: Colors.white24, height: 24),
                      _DetailRow(
                        label: "Timestamp",
                        value: transaction.timestamp.toLocal().toString(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isCopyable;
  final VoidCallback? onCopy;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isCopyable = false,
    this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110.w,
          child: Text(
            label,
            style: AppTextStyle.r12.copyWith(color: Colors.white60),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: isCopyable ? onCopy : null,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: AppTextStyle.m14.copyWith(
                      color: valueColor ?? Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isCopyable) ...[
                  SizedBox(width: 4.w),
                  Icon(Icons.copy_rounded, size: 14.r, color: Colors.white54),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
