import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../generated/l10n.dart';
// import '../providers/navigator_provider.dart';
// import '../providers/settings_provider.dart';
import '../utils/platform_configuration.dart';
import 'common/material/app.dart';
import 'common/material/theme.dart';
// import 'desktop/home_window.dart';
import 'mobile/mobile_window.dart';
import 'mobile/widgets/hotkeys.dart';

class QuietApp extends ConsumerWidget {
  const QuietApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Widget home;
    // final platform = ref.watch(debugNavigatorPlatformProvider);
    // switch (platform) {
    //   case NavigationPlatform.desktop:
    //     home = const HomeWindow();
    //     break;
    //   case NavigationPlatform.mobile:
    //     home = const MobileWindow();
    //     break;
    // }
    home = const MobileWindow();
    return GlobalHotkeys(
      child: MaterialApp(
        title: 'Quiet',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              borderSide: BorderSide(width: 2, color: Colors.amberAccent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              borderSide: BorderSide(width: 2, color: Colors.amberAccent),
            ),
          ),
        ),
        supportedLocales: const [Locale('en'), Locale('zh')],
        localizationsDelegates: const [
          S.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // theme: lightTheme,
        darkTheme: quietDarkTheme,
        // themeMode: ref.watch(
          // settingStateProvider.select((value) => value.themeMode),
        // ),
        home: home,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return AppTheme(
            child: AppPlatformConfiguration(
              // child: null
              child: CopyRightOverlay(child: child),
            ),
          );
        },
      ),
    );
  }
}
