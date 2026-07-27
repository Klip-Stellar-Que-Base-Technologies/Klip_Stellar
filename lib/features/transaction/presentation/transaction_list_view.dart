import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klip/features/transaction/app/transaction_provider.dart';
import 'package:klip/gen/colors.gen.dart';
import 'package:klip/shared/style/text_style.dart';
import 'package:klip/shared/widget/liquid_glass_texture.dart';



class TransactionListView extends ConsumerWidget {
  const TransactionListView({super.key});

  @override
  Widget build(BuildContext context, ref) {
    var filterState = ref.watch(transactionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("My Transactions", style: AppTextStyle.b16),
        centerTitle: false,
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 18) +
            const EdgeInsets.only(top: 29),
        child: Column(
          children: [
            // ~ Filter
            Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                LiquidGlassButton(
                  backgroundColor: _returnColorAtValue(
                    filterState,
                    TransactionFilter.all,
                  ),
                  onTap: () {
                    ref
                        .read(transactionProvider.notifier)
                        .updateState(TransactionFilter.all);
                  },
                  child: Text("All", style: AppTextStyle.sb16),
                ),

                LiquidGlassButton(
                  backgroundColor: _returnColorAtValue(
                    filterState,
                    TransactionFilter.deposit,
                  ),
                  onTap: () {
                    ref
                        .read(transactionProvider.notifier)
                        .updateState(TransactionFilter.deposit);
                  },
                  child: Text("Deposits", style: AppTextStyle.sb16),
                ),

                LiquidGlassButton(
                  backgroundColor: _returnColorAtValue(
                    filterState,
                    TransactionFilter.withdrawals,
                  ),
                  onTap: () {
                    ref
                        .read(transactionProvider.notifier)
                        .updateState(TransactionFilter.withdrawals);
                  },
                  child: Text("Withdrawals", style: AppTextStyle.sb16),
                ),
              ],
            ),

            SizedBox(height: 50.h),

            // ~ View Styling
            Row(
              children: [
                const SizedBox(width: 10),
                Text("Recent Activities", style: AppTextStyle.b16),
                Spacer(),
                DropdownMenu(
                  enableSearch: false,
                  label: Text("View", style: AppTextStyle.r16),
                  dropdownMenuEntries: [
                    DropdownMenuEntry<SomeDropDown>(
                      value: SomeDropDown.newToOld,
                      label: "New to old",
                    ),
                    DropdownMenuEntry<SomeDropDown>(
                      value: SomeDropDown.oldToNew,
                      label: "Old to new",
                    ),
                  ],
                ),
              ],
            ),

            // ~
            SingleChildScrollView(
              child: Column(
                children: [
                  // ~Fix to use class to create a model class for the build
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    minVerticalPadding: 23,

                    title: Text(
                      "Withdrawal to wallet",
                      style: AppTextStyle.m14,
                    ),
                    subtitle: Text(
                      "Sep 19 2025 13:58:24",
                      style: AppTextStyle.l12,
                    ),
                    trailing: Text(
                      "- \$13,000",
                      style: AppTextStyle.r16.copyWith(
                        color: ColorName.balanceNegative,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _returnColorAtValue(
    TransactionFilter inTransaction,
    TransactionFilter matchTransaction,
  ) {
    return inTransaction == matchTransaction
        ? ColorName.greenBackground.withValues(alpha: .3)
        : Colors.transparent;
  }
}

enum SomeDropDown { newToOld, oldToNew }

enum TransactionFilter { all, deposit, withdrawals }
