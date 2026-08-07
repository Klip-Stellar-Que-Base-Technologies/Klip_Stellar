import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

enum StellarNetwork { testnet, mainnet }

class StellarService {
  StellarService({StellarNetwork network = StellarNetwork.testnet})
      : _sdk = network == StellarNetwork.testnet
            ? StellarSDK.TESTNET
            : StellarSDK.PUBLIC,
        _network =
            network == StellarNetwork.testnet ? Network.TESTNET : Network.PUBLIC;

  final StellarSDK _sdk;
  final Network _network;
  final _storage = const FlutterSecureStorage();

  static const _secretKey = 'stellar_secret_key';

  // ── Key management ──────────────────────────────────────────────────────────

  Future<KeyPair> createKeyPair() async {
    final keyPair = KeyPair.random();
    await _storage.write(key: _secretKey, value: keyPair.secretSeed);
    return keyPair;
  }

  Future<KeyPair?> loadKeyPair() async {
    final seed = await _storage.read(key: _secretKey);
    if (seed == null) return null;
    return KeyPair.fromSecretSeed(seed);
  }

  Future<void> importKeyPair(String secretSeed) async {
    // Validate by constructing — throws if invalid
    KeyPair.fromSecretSeed(secretSeed);
    await _storage.write(key: _secretKey, value: secretSeed);
  }

  Future<void> deleteKeyPair() => _storage.delete(key: _secretKey);

  // ── Account ─────────────────────────────────────────────────────────────────

  Future<AccountResponse> getAccount(String accountId) =>
      _sdk.accounts.account(accountId);

  Future<List<Balance>> getBalances(String accountId) async {
    final account = await getAccount(accountId);
    return account.balances;
  }

  // ── Transactions ─────────────────────────────────────────────────────────────

  /// Send [amount] XLM from the loaded keypair to [destinationId].
  Future<SubmitTransactionResponse> sendPayment({
    required String destinationId,
    required String amount,
    String? memo,
  }) async {
    final keyPair = await loadKeyPair();
    if (keyPair == null) throw StateError('No keypair loaded');

    final sender = await getAccount(keyPair.accountId);
    final builder = TransactionBuilder(sender)
      ..addOperation(
        PaymentOperationBuilder(destinationId, Asset.NATIVE, amount).build(),
      );

    if (memo != null) builder.addMemo(Memo.text(memo));

    final tx = builder.build()..sign(keyPair, _network);
    return _sdk.submitTransaction(tx);
  }

  /// Fetch payment history operations for [accountId] with optional cursor.
  Future<Page<OperationResponse>> getPayments({
    required String accountId,
    String? cursor,
    int limit = 15,
    Order order = Order.DESC,
  }) async {
    final builder = _sdk.payments.forAccount(accountId).order(order).limit(limit);
    if (cursor != null) {
      builder.cursor(cursor);
    }
    return builder.execute();
  }

  // ── Testnet helpers ──────────────────────────────────────────────────────────

  /// Fund an account on testnet via Friendbot.
  Future<bool> fundTestnetAccount(String accountId) async {
    final response = await FriendBot.fundTestAccount(accountId);
    return response;
  }
}
