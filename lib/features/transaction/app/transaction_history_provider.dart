import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klip/core/stellar/stellar_provider.dart';
import 'package:klip/features/transaction/data/transaction_model.dart';
import 'package:klip/features/transaction/presentation/transaction_list_view.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

class TransactionHistoryState {
  final List<KlipTransaction> transactions;
  final TransactionFilter filter;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? nextCursor;
  final String? error;

  const TransactionHistoryState({
    this.transactions = const [],
    this.filter = TransactionFilter.all,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.nextCursor,
    this.error,
  });

  TransactionHistoryState copyWith({
    List<KlipTransaction>? transactions,
    TransactionFilter? filter,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? nextCursor,
    String? error,
  }) {
    return TransactionHistoryState(
      transactions: transactions ?? this.transactions,
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: nextCursor ?? this.nextCursor,
      error: error,
    );
  }

  /// Returns filtered list based on current [filter].
  List<KlipTransaction> get filteredTransactions {
    switch (filter) {
      case TransactionFilter.deposit:
        return transactions
            .where((tx) => tx.type == KlipTransactionType.credit)
            .toList();
      case TransactionFilter.withdrawals:
        return transactions
            .where((tx) => tx.type == KlipTransactionType.debit)
            .toList();
      case TransactionFilter.all:
      default:
        return transactions;
    }
  }
}

class TransactionHistoryNotifier extends Notifier<TransactionHistoryState> {
  @override
  TransactionHistoryState build() {
    // Initial fetch on creation
    Future.microtask(() => fetchInitial());
    return const TransactionHistoryState(isLoading: true);
  }

  Future<void> fetchInitial() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final keypairAsync = ref.read(walletKeypairProvider);
      final keypair = keypairAsync.asData?.value;
      if (keypair == null) {
        state = state.copyWith(isLoading: false, transactions: []);
        return;
      }

      final service = ref.read(stellarServiceProvider);
      final page = await service.getPayments(
        accountId: keypair.accountId,
        limit: 15,
        order: Order.DESC,
      );

      final List<KlipTransaction> fetched = [];
      for (final records in page.records ?? []) {
        if (records is PaymentOperationResponse) {
          fetched.add(
            KlipTransaction.fromPaymentOperation(
              operation: records,
              accountId: keypair.accountId,
            ),
          );
        }
      }

      final records = page.records;
      final nextCursor = records != null && records.isNotEmpty
          ? records.last.pagingToken
          : null;
      final hasMore = records != null && records.length >= 15;

      state = state.copyWith(
        isLoading: false,
        transactions: fetched,
        nextCursor: nextCursor,
        hasMore: hasMore,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void setFilter(TransactionFilter filter) {
    state = state.copyWith(filter: filter);
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.nextCursor == null) {
      return;
    }

    state = state.copyWith(isLoadingMore: true);

    try {
      final keypairAsync = ref.read(walletKeypairProvider);
      final keypair = keypairAsync.asData?.value;
      if (keypair == null) return;

      final service = ref.read(stellarServiceProvider);
      final page = await service.getPayments(
        accountId: keypair.accountId,
        cursor: state.nextCursor,
        limit: 15,
        order: Order.DESC,
      );

      final List<KlipTransaction> fetched = [];
      for (final records in page.records ?? []) {
        if (records is PaymentOperationResponse) {
          fetched.add(
            KlipTransaction.fromPaymentOperation(
              operation: records,
              accountId: keypair.accountId,
            ),
          );
        }
      }

      final records = page.records;
      final nextCursor = records != null && records.isNotEmpty
          ? records.last.pagingToken
          : null;
      final hasMore = records != null && records.length >= 15;

      state = state.copyWith(
        isLoadingMore: false,
        transactions: [...state.transactions, ...fetched],
        nextCursor: nextCursor,
        hasMore: hasMore,
      );
    } catch (_) {
      state = state.copyWith(isLoadingMore: false);
    }
  }
}

final transactionHistoryProvider = NotifierProvider<
    TransactionHistoryNotifier, TransactionHistoryState>(
  TransactionHistoryNotifier.new,
);
