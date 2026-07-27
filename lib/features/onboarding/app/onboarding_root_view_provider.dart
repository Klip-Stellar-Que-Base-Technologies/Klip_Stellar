// ignore_for_file: constant_identifier_names

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_root_view_provider.g.dart';

enum OnboardingRootViewPage { page1, page2, page3, page4 }

@riverpod
class OnboardingRootView extends _$OnboardingRootView {
  @override
  OnboardingRootViewPage build() => OnboardingRootViewPage.page1;

  void changeView(OnboardingRootViewPage view) {
    state = view;
  }

  void nextView() {
    final views = OnboardingRootViewPage.values;
    final currentIndex = views.indexOf(state);
    final hasNext = currentIndex != -1 && currentIndex < views.length - 1;

    if (hasNext) {
      state = views[currentIndex + 1];
    }
  }

  void prevView() {
    final views = OnboardingRootViewPage.values;
    final currentIndex = views.indexOf(state);
    final hasPrevious = currentIndex > 0;

    if (hasPrevious) {
      state = views[currentIndex - 1];
    }
  }
}
