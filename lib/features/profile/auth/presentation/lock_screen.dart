import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:klip/core/routes/app_router.dart';
import 'package:klip/core/services/auth_service.dart';
import 'package:klip/shared/style/text_style.dart';
import 'package:klip/shared/widget/liquid_glass_texture.dart';

/// Screen displayed when the app is locked by biometrics / passcode on resume.
class LockScreen extends HookConsumerWidget {
  const LockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authenticating = useState(false);

    Future<void> handleAuthenticate() async {
      if (authenticating.value) return;
      authenticating.value = true;

      try {
        final authService = ref.read(authServiceProvider);
        final success = await authService.authenticate(
          localizedReason: 'Authenticate to unlock Klip wallet',
        );

        if (success) {
          ref.read(appLockNotifierProvider.notifier).unlock();
          if (context.mounted) {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.homeRoute);
            }
          }
        }
      } finally {
        authenticating.value = false;
      }
    }

    // Trigger biometric prompt automatically when screen mounts
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        handleAuthenticate();
      });
      return null;
    }, const []);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LiquidGlassTexture(
                width: double.infinity,
                height: 380.h,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 32.h,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 72.r,
                        height: 72.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                        child: Icon(
                          Icons.fingerprint_rounded,
                          size: 44.r,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        "Klip Locked",
                        style: AppTextStyle.b20,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "Authenticate using Face ID / Biometrics or Passcode to continue",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.r14.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 36.h),
                      LiquidGlassButton(
                        width: double.infinity,
                        onTap: handleAuthenticate,
                        child: authenticating.value
                            ? SizedBox(
                                width: 20.r,
                                height: 20.r,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text("Unlock App", style: AppTextStyle.sb16),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
