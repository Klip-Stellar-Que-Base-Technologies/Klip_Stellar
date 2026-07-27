import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:klip/core/routes/app_router.dart';
import 'package:klip/gen/colors.gen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final appbarTheme = AppBarTheme(
      backgroundColor: Colors.transparent,
    ); // ~ Appbar Theme

    final app = ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: false, // Changed from true
      splitScreenMode: false, // Changed from true
      rebuildFactor:
          RebuildFactors.orientation, // Only rebuild on orientation changes
      builder: (context, child) {
        return MaterialApp.router(
          theme: ThemeData(
            brightness: Brightness.dark,

            scaffoldBackgroundColor: ColorName.backgroundDark,
            appBarTheme: appbarTheme,
            // Configure the textTheme to have white as the default color
            textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
          ),
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
        );
      },
    );

    return app;

    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     scaffoldBackgroundColor: ColorName.backgroundDark,
    //     appBarTheme: appbarTheme,
    //   ),
    //   home: const App(),
    // );
  }
}
