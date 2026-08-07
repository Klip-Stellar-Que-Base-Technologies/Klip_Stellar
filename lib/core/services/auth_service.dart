import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

/// Service providing biometric and device PIN/passcode authentication via [LocalAuthentication].
class AuthService {
  final LocalAuthentication _auth;

  AuthService({LocalAuthentication? auth})
      : _auth = auth ?? LocalAuthentication();

  /// Returns true if biometrics hardware is present and enrolled.
  Future<bool> canCheckBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Returns true if the device supports biometric auth or device PIN.
  Future<bool> isDeviceSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Returns list of available biometrics (face, fingerprint, iris).
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (_) {
      return <BiometricType>[];
    }
  }

  /// Prompts the user to authenticate using biometrics or device PIN/passcode.
  /// Returns true if authentication succeeded.
  Future<bool> authenticate({
    required String localizedReason,
    bool stickyAuth = true,
    bool useErrorDialogs = true,
    bool biometricOnly = false,
  }) async {
    try {
      final isSupported = await isDeviceSupported();
      if (!isSupported) {
        // If device has no passcode/biometrics configured or supported, return true to avoid locking out.
        return true;
      }
      return await _auth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          stickyAuth: stickyAuth,
          useErrorDialogs: useErrorDialogs,
          biometricOnly: biometricOnly,
        ),
      );
    } on PlatformException catch (_) {
      return false;
    }
  }
}

/// Provides the single [AuthService] instance across the app.
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Manages app lock state (locked when app resumes from background).
class AppLockNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void lock() => state = true;
  void unlock() => state = false;
}

final appLockNotifierProvider =
    NotifierProvider<AppLockNotifier, bool>(AppLockNotifier.new);
