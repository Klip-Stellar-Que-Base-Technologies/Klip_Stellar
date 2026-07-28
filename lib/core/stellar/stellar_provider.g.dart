// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stellar_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the single [StellarService] instance for the app.
/// Defaults to testnet. Swap to [StellarNetwork.mainnet] before release.

@ProviderFor(stellarService)
const stellarServiceProvider = StellarServiceProvider._();

/// Provides the single [StellarService] instance for the app.
/// Defaults to testnet. Swap to [StellarNetwork.mainnet] before release.

final class StellarServiceProvider
    extends $FunctionalProvider<StellarService, StellarService, StellarService>
    with $Provider<StellarService> {
  /// Provides the single [StellarService] instance for the app.
  /// Defaults to testnet. Swap to [StellarNetwork.mainnet] before release.
  const StellarServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stellarServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stellarServiceHash();

  @$internal
  @override
  $ProviderElement<StellarService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StellarService create(Ref ref) {
    return stellarService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StellarService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StellarService>(value),
    );
  }
}

String _$stellarServiceHash() => r'47022e17a157fa361a604803635cf309cef20fca';

/// Loads the stored keypair on first access.
/// If none exists (first launch) it creates one automatically.
/// Exposes [AsyncValue<KeyPair>] so callers can handle loading / error states.

@ProviderFor(WalletKeypair)
const walletKeypairProvider = WalletKeypairProvider._();

/// Loads the stored keypair on first access.
/// If none exists (first launch) it creates one automatically.
/// Exposes [AsyncValue<KeyPair>] so callers can handle loading / error states.
final class WalletKeypairProvider
    extends $AsyncNotifierProvider<WalletKeypair, KeyPair> {
  /// Loads the stored keypair on first access.
  /// If none exists (first launch) it creates one automatically.
  /// Exposes [AsyncValue<KeyPair>] so callers can handle loading / error states.
  const WalletKeypairProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletKeypairProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletKeypairHash();

  @$internal
  @override
  WalletKeypair create() => WalletKeypair();
}

String _$walletKeypairHash() => r'70847f63c36cc6aaee5ce1df9b50e10676652b78';

/// Loads the stored keypair on first access.
/// If none exists (first launch) it creates one automatically.
/// Exposes [AsyncValue<KeyPair>] so callers can handle loading / error states.

abstract class _$WalletKeypair extends $AsyncNotifier<KeyPair> {
  FutureOr<KeyPair> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<KeyPair>, KeyPair>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<KeyPair>, KeyPair>,
              AsyncValue<KeyPair>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Fetches the XLM balance string for the current keypair.
/// Returns null if the account is not yet funded on-chain.

@ProviderFor(xlmBalance)
const xlmBalanceProvider = XlmBalanceProvider._();

/// Fetches the XLM balance string for the current keypair.
/// Returns null if the account is not yet funded on-chain.

final class XlmBalanceProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// Fetches the XLM balance string for the current keypair.
  /// Returns null if the account is not yet funded on-chain.
  const XlmBalanceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'xlmBalanceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$xlmBalanceHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return xlmBalance(ref);
  }
}

String _$xlmBalanceHash() => r'0e3c300b33a887ef132658d34e184b7c0fd7b06c';
