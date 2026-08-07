import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:klip/core/routes/app_router.dart';
import 'package:klip/features/transaction/app/transaction_history_provider.dart';
import 'package:klip/features/transaction/presentation/widgets/transaction_list_item.dart';
import 'package:klip/gen/assets.gen.dart';
import 'package:klip/gen/colors.gen.dart';
import 'package:klip/shared/style/text_style.dart';
import 'package:klip/shared/widget/liquid_glass_texture.dart';

enum SomeDropDown { newToOld, oldToNew }

enum TransactionFilter { all, deposit, withdrawals }

class TransactionListView extends HookConsumerWidget {
  const TransactionListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyState = ref.watch(transactionHistoryProvider);
    final historyNotifier = ref.read(transactionHistoryProvider.notifier);
    final scrollController = useScrollController();

    useEffect(() {
      void onScroll() {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          historyNotifier.loadMore();
        }
      }

      scrollController.addListener(onScroll);
      return () => scrollController.removeListener(onScroll);
    }, [scrollController]);

    final filteredList = historyState.filteredTransactions;

    return Scaffold(
      appBar: AppBar(
        title: Text("My Transactions", style: AppTextStyle.b16),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        child: Column(
          children: [
            // ~ Filter Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LiquidGlassButton(
                  backgroundColor: _returnColorAtValue(
                    historyState.filter,
                    TransactionFilter.all,
                  ),
                  onTap: () => historyNotifier.setFilter(TransactionFilter.all),
                  child: Text("All", style: AppTextStyle.sb16),
                ),
                SizedBox(width: 8.w),
                LiquidGlassButton(
                  backgroundColor: _returnColorAtValue(
                    historyState.filter,
                    TransactionFilter.deposit,
                  ),
                  onTap: () => historyNotifier.setFilter(TransactionFilter.deposit),
                  child: Text("Deposits", style: AppTextStyle.sb16),
                ),
                SizedBox(width: 8.w),
                LiquidGlassButton(
                  backgroundColor: _returnColorAtValue(
                    historyState.filter,
                    TransactionFilter.withdrawals,
                  ),
                  onTap: () => historyNotifier.setFilter(TransactionFilter.withdrawals),
                  child: Text("Withdrawals", style: AppTextStyle.sb16),
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // ~ Header Row
            Row(
              children: [
                SizedBox(width: 4.w),
                Text("Recent Activities", style: AppTextStyle.b16),
                const Spacer(),
              ],
            ),

            SizedBox(height: 12.h),

            // ~ Transactions List
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => historyNotifier.fetchInitial(),
                child: historyState.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : filteredList.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Assets.svgIcons.waitingIcon.svg(),
                                SizedBox(height: 12.h),
                                Text(
                                  "No Transactions Found",
                                  style: AppTextStyle.l12.copyWith(color: Colors.white70),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: filteredList.length +
                                (historyState.isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == filteredList.length) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }

                              final tx = filteredList[index];
                              return TransactionListItem(
                                transaction: tx,
                                onTap: () {
                                  context.push(
                                    AppRoutes.transactionDetail,
                                    extra: tx,
                                  );
                                },
                              );
                            },
                          ),
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
