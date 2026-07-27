// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:klip/features/onboarding/app/onboarding_root_view_provider.dart';
import 'package:klip/shared/style/text_style.dart';
import 'package:klip/shared/widget/liquid_glass_texture.dart';

class SignupView extends HookConsumerWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _username = useTextEditingController();
    final _password = useTextEditingController();
    final _repassword = useTextEditingController();

    void _goToLogin() {
      ref
          .read(onboardingRootViewProvider.notifier)
          .changeView(OnboardingRootViewPage.page4);
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
                padding:
                    EdgeInsets.symmetric(horizontal: 26.0) +
                    const EdgeInsets.only(top: 24),
                child: Column(
                  children: [
                    Text("Sign Up", style: AppTextStyle.b20),
                    SizedBox(height: 12.h),

                    Text("Create an account", style: AppTextStyle.r14),
                    SizedBox(height: 30.h),

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

                    // ~ Re-Password TextField
                    TextField(
                      controller: _repassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        hint: Text("Reconfirm Password"),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // ~ Sign Up Button — advances to LoginView page
                    LiquidGlassButton(
                      width: double.infinity,
                      onTap: _goToLogin,
                      child: Text("Sign Up", style: AppTextStyle.sb16),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Already have an account?", style: AppTextStyle.r12),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: _goToLogin,
                          child: Text("Sign In", style: AppTextStyle.sb12),
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
