// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_root_view_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OnboardingRootView)
const onboardingRootViewProvider = OnboardingRootViewProvider._();

final class OnboardingRootViewProvider
    extends $NotifierProvider<OnboardingRootView, OnboardingRootViewPage> {
  const OnboardingRootViewProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingRootViewProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingRootViewHash();

  @$internal
  @override
  OnboardingRootView create() => OnboardingRootView();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardingRootViewPage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnboardingRootViewPage>(value),
    );
  }
}

String _$onboardingRootViewHash() =>
    r'0d608f51cc38ca8e71ba8ffe6349861e2f2a9cad';

abstract class _$OnboardingRootView extends $Notifier<OnboardingRootViewPage> {
  OnboardingRootViewPage build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<OnboardingRootViewPage, OnboardingRootViewPage>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OnboardingRootViewPage, OnboardingRootViewPage>,
              OnboardingRootViewPage,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
