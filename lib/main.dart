import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klip/core/routes/app_router.dart';
import 'package:klip/core/services/auth_service.dart';
import 'package:klip/core/services/onboarding_service.dart';
import 'package:klip/gen/colors.gen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // Inject the real SharedPreferences instance before any provider reads it.
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late final AppLifecycleListener _lifecycleListener;

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(
      onStateChange: (state) {
        if (state == AppLifecycleState.paused ||
            state == AppLifecycleState.inactive ||
            state == AppLifecycleState.hidden) {
          ref.read(appLockNotifierProvider.notifier).lock();
        }
      },
    );
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build the router once with access to the provider container so the
    // redirect can read onboardingCompleteProvider synchronously.
    final router = AppRouter.buildRouter(
      ProviderScope.containerOf(context),
    );

    const appBarTheme = AppBarTheme(backgroundColor: Colors.transparent);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: false,
      splitScreenMode: false,
      rebuildFactor: RebuildFactors.orientation,
      builder: (context, child) {
        return MaterialApp.router(
          theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: ColorName.backgroundDark,
            appBarTheme: appBarTheme,
            textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
          ),
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
