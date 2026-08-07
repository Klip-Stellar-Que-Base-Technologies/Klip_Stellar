import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klip/features/transaction/data/transaction_model.dart';
import 'package:klip/gen/colors.gen.dart';
import 'package:klip/shared/style/text_style.dart';

/// Widget to display a single transaction item in the list.
class TransactionListItem extends StatelessWidget {
  final KlipTransaction transaction;
  final VoidCallback? onTap;

  const TransactionListItem({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type == KlipTransactionType.credit;
    final amountPrefix = isCredit ? '+' : '-';
    final amountColor = isCredit
        ? const Color(0xFF057029)
        : ColorName.balanceNegative;

    final counterpartyStr = transaction.counterparty;
    final truncatedAddr = counterpartyStr.length > 12
        ? '${counterpartyStr.substring(0, 6)}...${counterpartyStr.substring(counterpartyStr.length - 6)}'
        : counterpartyStr;

    final titleStr = isCredit
        ? 'Received ${transaction.asset}'
        : 'Sent ${transaction.asset} to $truncatedAddr';

    final dateStr = '${transaction.timestamp.year}-${_twoDigits(transaction.timestamp.month)}-${_twoDigits(transaction.timestamp.day)} ${_twoDigits(transaction.timestamp.hour)}:${_twoDigits(transaction.timestamp.minute)}';

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        leading: Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: amountColor.withValues(alpha: 0.2),
          ),
          child: Icon(
            isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
            color: amountColor,
            size: 20.r,
          ),
        ),
        title: Text(
          titleStr,
          style: AppTextStyle.m14,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          dateStr,
          style: AppTextStyle.l12.copyWith(color: Colors.white60),
        ),
        trailing: Text(
          '$amountPrefix${transaction.amount} ${transaction.asset}',
          style: AppTextStyle.sb16.copyWith(color: amountColor),
        ),
      ),
    );
  }

  static String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
