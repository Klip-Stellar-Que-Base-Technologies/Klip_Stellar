import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

enum KlipTransactionType {
  credit, // Incoming payment
  debit,  // Outgoing payment
}

/// Data model representing a parsed Stellar payment transaction.
class KlipTransaction {
  final String id;
  final String hash;
  final KlipTransactionType type;
  final String amount;
  final String asset;
  final String counterparty;
  final String? memo;
  final DateTime timestamp;
  final String fee;
  final bool isSuccessful;

  const KlipTransaction({
    required this.id,
    required this.hash,
    required this.type,
    required this.amount,
    required this.asset,
    required this.counterparty,
    this.memo,
    required this.timestamp,
    required this.fee,
    this.isSuccessful = true,
  });

  /// Factory constructor to map Stellar SDK [PaymentOperationResponse] to [KlipTransaction].
  factory KlipTransaction.fromPaymentOperation({
    required PaymentOperationResponse operation,
    required String accountId,
    String? transactionMemo,
    int? maxFee,
  }) {
    final isDebit = operation.from == accountId || operation.sourceAccount == accountId;
    final counterparty = isDebit ? (operation.to ?? 'Unknown') : (operation.from ?? 'Unknown');
    final assetCode = operation.assetType == 'native'
        ? 'XLM'
        : (operation.assetCode ?? 'XLM');

    final createdAt = operation.createdAt != null
        ? DateTime.tryParse(operation.createdAt!) ?? DateTime.now()
        : DateTime.now();

    final feeXlm = maxFee != null
        ? '${(maxFee / 10000000.0).toStringAsFixed(5)} XLM'
        : '0.00001 XLM';

    return KlipTransaction(
      id: operation.id.toString(),
      hash: operation.transactionHash ?? operation.id.toString(),
      type: isDebit ? KlipTransactionType.debit : KlipTransactionType.credit,
      amount: operation.amount ?? '0.00',
      asset: assetCode,
      counterparty: counterparty,
      memo: transactionMemo,
      timestamp: createdAt,
      fee: feeXlm,
      isSuccessful: operation.transactionSuccessful ?? true,
    );
  }
}
