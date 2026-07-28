import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'onboarding_service.g.dart';

// ── Key ──────────────────────────────────────────────────────────────────────

const _kOnboardingComplete = 'onboarding_complete';

// ── Service ──────────────────────────────────────────────────────────────────

class OnboardingService {
  const OnboardingService(this._prefs);

  final SharedPreferences _prefs;

  bool get isComplete => _prefs.getBool(_kOnboardingComplete) ?? false;

  Future<void> markComplete() =>
      _prefs.setBool(_kOnboardingComplete, true);

  Future<void> reset() =>
      _prefs.remove(_kOnboardingComplete);
}

// ── Providers ────────────────────────────────────────────────────────────────

/// Provides the [SharedPreferences] instance.
/// Must be overridden in main() before the app runs.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) {
  // Overridden in main.dart via ProviderScope overrides.
  throw UnimplementedError('sharedPreferences provider was not initialised');
}

/// Provides the [OnboardingService] backed by [SharedPreferences].
@Riverpod(keepAlive: true)
OnboardingService onboardingService(Ref ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return OnboardingService(prefs);
}

/// Convenience bool provider — true when the user has completed onboarding.
@Riverpod(keepAlive: true)
bool onboardingComplete(Ref ref) {
  return ref.watch(onboardingServiceProvider).isComplete;
}
