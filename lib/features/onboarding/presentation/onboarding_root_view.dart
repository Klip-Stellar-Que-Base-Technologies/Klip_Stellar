import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klip/features/onboarding/app/onboarding_root_view_provider.dart';
import 'package:klip/features/onboarding/presentation/onboarding_page_1.dart';
import 'package:klip/features/onboarding/presentation/onboarding_page_2.dart';
import 'package:klip/features/profile/auth/presentation/login_view.dart';
import 'package:klip/features/profile/auth/presentation/signup_view.dart';
import 'package:klip/shared/widget/liquid_glass_texture.dart';

class OnboardingRootPage extends ConsumerStatefulWidget {
  const OnboardingRootPage({super.key});

  @override
  ConsumerState<OnboardingRootPage> createState() => _OnboardingRootPageState();
}

class _OnboardingRootPageState extends ConsumerState<OnboardingRootPage> {
  final PageController _pageController = PageController();
  // ignore: unused_field
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  // int _currentStep = 1;

  // @override
  // void initState() {
  //   super.initState();
  //   _updateStep();
  // }

  // @override
  // void didUpdateWidget(OnboardingRootPage oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   _updateStep();
  // }

  // void _updateStep() {
  //   final location = GoRouterState.of(context).uri.path;
  //   if (location.contains('page_1')) {
  //     _currentStep = 1;
  //   } else if (location.contains('page_2')) {
  //     _currentStep = 2;
  //   } else if (location.contains('login')) {
  //     _currentStep = 3;
  //   } else if (location.contains('sign_up')) {
  //     _currentStep = 4;
  //   }
  // }

  // void _nextStep() {
  //   if (_currentStep < 3) {
  //     switch (_currentStep) {
  //       case 1:
  //         context.goNamed('onboarding_step2');
  //         break;
  //       case 2:
  //         context.goNamed('onboarding_step3');
  //         break;
  //     }
  //   }
  // }

  // void _previousStep() {
  //   if (_currentStep > 1) {
  //     switch (_currentStep) {
  //       case 2:
  //         context.goNamed(AppRoutes.onboardingPage_2);
  //         break;
  //       case 3:
  //         context.goNamed(AppRoutes.onboardingPage_2);
  //         break;
  //     }
  //   }
  // }

  // Future<void> _completeOnboarding() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('onboarding_complete', true);
  //   if (mounted) {
  //     context.goNamed('tab1');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final pageView = ref.watch(onboardingRootViewProvider);

    return Scaffold(
      body: Stack(
        alignment: AlignmentGeometry.topCenter,
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              ref
                  .read(onboardingRootViewProvider.notifier)
                  .changeView(OnboardingRootViewPage.values[index]);
            },
            children: [
              OnboardingPage1(),
              OnboardingPage2(),
              SignupView(),
              LoginView(),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 92.h),
            child: Row(
              spacing: 4,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                LiquidGlassTexture(
                  width: pageView == OnboardingRootViewPage.page1 ? 14.w : 62.w,
                  height: 12.h,
                  child: SizedBox.shrink(),
                ),
                LiquidGlassTexture(
                  width: pageView == OnboardingRootViewPage.page2 ? 14.w : 62.w,
                  height: 12.h,
                  child: SizedBox.shrink(),
                ),
                LiquidGlassTexture(
                  width: pageView == OnboardingRootViewPage.page3 ? 14.w : 62.w,
                  height: 12.h,
                  child: SizedBox.shrink(),
                ),
                LiquidGlassTexture(
                  width: pageView == OnboardingRootViewPage.page4 ? 14.w : 62.w,
                  height: 12.h,
                  child: SizedBox.shrink(),
                ),
              ],
            ),
          ),

          /** 
          Positioned(
            bottom: 20,
            right: 20,
            child: SizedBox(
              width: 34,
              height: 34,

              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                label: SizedBox.shrink(),
                icon: Assets.svgIcons.caretDownIcon.svg(),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: SizedBox(
              width: 34,
              height: 34,

              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                label: SizedBox.shrink(),
                icon: Assets.svgIcons.caretDownIcon.svg(),
              ),
            ),
          ), 
        **/
        ],
      ),
    );
  }
}
