import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:klip/core/routes/app_router.dart';
import 'package:klip/core/services/onboarding_service.dart';
import 'package:klip/features/onboarding/app/onboarding_root_view_provider.dart';
import 'package:klip/shared/style/text_style.dart';
import 'package:klip/shared/widget/liquid_glass_texture.dart';

class LoginView extends HookConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _username = useTextEditingController();
    final _password = useTextEditingController();

    void _goToSignUp() {
      ref
          .read(onboardingRootViewProvider.notifier)
          .changeView(OnboardingRootViewPage.page3);
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LiquidGlassTexture(
              width: double.infinity,
              height: .5.sh,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 26.0,
                  vertical: 28,
                ),
                child: Column(
                  children: [
                    Text("Login", style: AppTextStyle.b20),
                    SizedBox(height: 12.h),

                    Text("Welcome back", style: AppTextStyle.r14),
                    SizedBox(height: 46.h),

                    // ~ Email TextField
                    TextField(
                      controller: _username,
                      decoration: InputDecoration(
                        hint: Text("Email"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // ~ Password TextField
                    TextField(
                      controller: _password,
                      obscureText: true,
                      decoration: InputDecoration(
                        hint: Text("Password"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // ~ Login Button — marks onboarding complete then navigates to home
                    LiquidGlassButton(
                      width: double.infinity,
                      onTap: () async {
                        await ref
                            .read(onboardingServiceProvider)
                            .markComplete();
                        if (context.mounted) {
                          context.go(AppRoutes.homeRoute);
                        }
                      },
                      child: Text("Sign In", style: AppTextStyle.sb16),
                    ),
                    SizedBox(height: 14.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Don't have an account?", style: AppTextStyle.r12),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: _goToSignUp,
                          child: Text("Sign Up", style: AppTextStyle.sb12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
