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
    final fromAddress = operation.from;
    final toAddress = operation.to;

    final isDebit = fromAddress == accountId || operation.sourceAccount == accountId;
    final counterparty = isDebit ? toAddress : fromAddress;
    final assetCode = operation.assetType == 'native'
        ? 'XLM'
        : (operation.assetCode ?? 'XLM');

    final createdAtStr = operation.createdAt;
    final createdAt = DateTime.tryParse(createdAtStr) ?? DateTime.now();

    final feeXlm = maxFee != null
        ? '${(maxFee / 10000000.0).toStringAsFixed(5)} XLM'
        : '0.00001 XLM';

    final txHash = operation.transactionHash ?? operation.id.toString();

    return KlipTransaction(
      id: operation.id.toString(),
      hash: txHash,
      type: isDebit ? KlipTransactionType.debit : KlipTransactionType.credit,
      amount: operation.amount,
      asset: assetCode,
      counterparty: counterparty,
      memo: transactionMemo,
      timestamp: createdAt,
      fee: feeXlm,
      isSuccessful: operation.transactionSuccessful ?? true,
    );
  }
}
