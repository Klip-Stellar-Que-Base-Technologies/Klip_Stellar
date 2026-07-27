import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:klip/core/navigation/navigation_provider.dart';
import 'package:klip/core/routes/app_router.dart';
import 'package:klip/gen/assets.gen.dart';

class NavigationMenu extends ConsumerWidget {
  final Widget child;

  const NavigationMenu({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get current route to sync with bottom nav
    final currentRoute = GoRouterState.of(context).matchedLocation;
    final currentIndex = _getIndexFromRoute(currentRoute);

    // Update provider if route changed externally
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(navigationProvider) != currentIndex) {
        ref.read(navigationProvider.notifier).navigate(currentIndex);
      }
    });

    final indexNavigation = ref.watch(navigationProvider);

    return Scaffold(
      bottomNavigationBar: Container(
        height: 72.h,
        margin: EdgeInsets.only(bottom: 38.h, left: 16.w, right: 16.w),
        decoration: BoxDecoration(
          // color: textPrimary,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(
              context: context,
              ref: ref,
              index: 0,
              activeIcon: Assets.svgIcons.homeTabIcon.path,
              inactiveIcon: Assets.svgIcons.homeTabIcon.path,
              label: 'Home',
              isSelected: indexNavigation == 0,
              onTap: () {
                ref.read(navigationProvider.notifier).navigate(0);
                context.go(AppRoutes.homeRoute);
              },
            ),
            _buildNavItem(
              context: context,
              ref: ref,
              index: 1,
              activeIcon: Assets.svgIcons.savingTabIcon.path,
              inactiveIcon: Assets.svgIcons.savingTabIcon.path,
              label: 'Savings',
              isSelected: indexNavigation == 1,
              onTap: () {
                ref.read(navigationProvider.notifier).navigate(1);
                context.go(AppRoutes.savings);
              },
            ),
            _buildNavItem(
              context: context,
              ref: ref,
              index: 2,
              activeIcon: Assets.svgIcons.transactionTabIcon.path,
              inactiveIcon: Assets.svgIcons.transactionTabIcon.path,
              label: 'Transactions',
              isSelected: indexNavigation == 2,
              onTap: () {
                ref.read(navigationProvider.notifier).navigate(2);
                context.go(AppRoutes.transaction);
              },
            ),
            _buildNavItem(
              context: context,
              ref: ref,
              index: 3,
              activeIcon: Assets.svgIcons.settingTabIcon.path,
              inactiveIcon: Assets.svgIcons.settingTabIcon.path,
              label: 'Settings',
              isSelected: indexNavigation == 3,
              onTap: () {
                ref.read(navigationProvider.notifier).navigate(3);
                context.go(AppRoutes.settings);
              },
            ),
          ],
        ),
      ),
      body: child,
    );
  }

  int _getIndexFromRoute(String route) {
    if (route.contains('/main/home')) return 0;
    if (route.contains('/main/savings')) return 1;
    if (route.contains('/main/transaction')) return 2;
    if (route.contains('/main/settings')) return 3;
    return 0;
  }

  Widget _buildNavItem({
    required BuildContext context,
    required WidgetRef ref,
    required int index,
    required String activeIcon,
    required String inactiveIcon,
    required String label,
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap:
          onTap ??
          () {
            ref.read(navigationProvider.notifier).navigate(index);
          },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 24.h,
              width: 24.w,
              child: SvgPicture.asset(
                isSelected ? activeIcon : inactiveIcon,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 8.h),
            Text(label, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
