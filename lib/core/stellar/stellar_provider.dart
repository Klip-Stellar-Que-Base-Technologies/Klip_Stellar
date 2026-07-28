import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:klip/core/stellar/stellar_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stellar_flutter_sdk/stellar_flutter_sdk.dart';

part 'stellar_provider.g.dart';

// ── StellarService singleton ─────────────────────────────────────────────────

/// Provides the single [StellarService] instance for the app.
/// Defaults to testnet. Swap to [StellarNetwork.mainnet] before release.
@Riverpod(keepAlive: true)
StellarService stellarService(Ref ref) {
  return StellarService(network: StellarNetwork.testnet);
}

// ── Wallet keypair ───────────────────────────────────────────────────────────

/// Loads the stored keypair on first access.
/// If none exists (first launch) it creates one automatically.
/// Exposes [AsyncValue<KeyPair>] so callers can handle loading / error states.
@Riverpod(keepAlive: true)
class WalletKeypair extends _$WalletKeypair {
  @override
  Future<KeyPair> build() async {
    final service = ref.read(stellarServiceProvider);
    final existing = await service.loadKeyPair();
    if (existing != null) return existing;
    // First launch — generate and persist a new keypair.
    return service.createKeyPair();
  }

  /// Replaces the current keypair with one imported from [secretSeed].
  Future<void> importFromSeed(String secretSeed) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(stellarServiceProvider);
      await service.importKeyPair(secretSeed);
      return KeyPair.fromSecretSeed(secretSeed);
    });
  }

  /// Clears the stored keypair (used by disconnect in settings).
  Future<void> clear() async {
    final service = ref.read(stellarServiceProvider);
    await service.deleteKeyPair();
    // Invalidate so next read triggers a fresh build (which will create a new key).
    ref.invalidateSelf();
  }
}

// ── XLM balance ─────────────────────────────────────────────────────────────

/// Fetches the XLM balance string for the current keypair.
/// Returns null if the account is not yet funded on-chain.
@riverpod
Future<String?> xlmBalance(Ref ref) async {
  final keypairAsync = ref.watch(walletKeypairProvider);
  return keypairAsync.when(
    data: (keypair) async {
      try {
        final service = ref.read(stellarServiceProvider);
        final balances = await service.getBalances(keypair.accountId);
        final native = balances.firstWhere(
          (b) => b.assetType == 'native',
          orElse: () => throw StateError('No native balance'),
        );
        return native.balance;
      } catch (_) {
        // Account not funded yet — return null so UI shows a placeholder.
        return null;
      }
    },
    loading: () => null,
    error: (_, __) => null,
  );
}
