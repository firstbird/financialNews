import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:recipe/providers/repository_provider.dart';
import 'package:recipe/repository/data/user.dart';
import 'package:recipe/repository/netease.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'package:path/path.dart' as p;
import 'repository/app_dir.dart';
import 'package:mixin_logger/mixin_logger.dart';
import 'package:overlay_support/overlay_support.dart';

import 'providers/preference_provider.dart';

import 'repository/data/news_detail.dart';
import 'repository/network_repository.dart';
import 'utils/callback_window_listener.dart';
import 'utils/platform_configuration.dart';

import 'navigation/common/page_splash.dart';
import 'navigation/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await loadFallbackFonts();
  await NetworkRepository.initialize();
  await initAppDir();
  final preferences = await SharedPreferences.getInstance();
  unawaited(_initialDesktop(preferences));
  initLogger(p.join(appDir.path, 'logs'));
  await _initHive();
  // runApp(const MyApp());
  runZonedGuarded(() {
    runApp(
      ProviderScope(
        overrides: [
          sharedPreferenceProvider.overrideWithValue(preferences),
          neteaseRepositoryProvider.overrideWithValue(neteaseRepository!),
        ],
        child: PageSplash(
          futures: const [],
          builder: (BuildContext context, List<dynamic> data) {
            return const MyApp();
          },
        ),
      ),
    );
  }, (error, stack) {
    debugPrint('uncaught error : $error $stack');
  });
}

Future<void> _initHive() async {
  await Hive.initFlutter(p.join(appDir.path, 'hive'));
  Hive.registerAdapter(NewsDetailAdapter());
  // Hive.registerAdapter(TrackTypeAdapter());
  // Hive.registerAdapter(TrackAdapter());
  // Hive.registerAdapter(ArtistMiniAdapter());
  // Hive.registerAdapter(AlbumMiniAdapter());
  // Hive.registerAdapter(DurationAdapter());
  Hive.registerAdapter(UserAdapter());
}

Future<void> _initialDesktop(SharedPreferences preferences) async {
  if (!(Platform.isMacOS || Platform.isLinux || Platform.isWindows)) {
    return;
  }
  await WindowManager.instance.ensureInitialized();
  if (Platform.isWindows) {
    final size = preferences.getWindowSize();
    final windowOptions = WindowOptions(
      size: size ?? const Size(1080, 720),
      minimumSize: windowMinSize,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  } else if (Platform.isLinux) {
    final size = preferences.getWindowSize();
    await windowManager.setSize(size ?? const Size(1080, 720));
    await windowManager.center();
  }

  if (Platform.isWindows || Platform.isLinux) {
    windowManager.addListener(
      CallbackWindowListener(
        onWindowResizeCallback: () async {
          final size = await windowManager.getSize();
          await preferences.setWindowSize(size);
        },
      ),
    );
  }

  assert(
      () {
    scheduleMicrotask(() async {
      final size = await WindowManager.instance.getSize();
      if (size.width < 960 || size.height < 720) {
        await WindowManager.instance
            .setSize(const Size(960, 720), animate: true);
      }
    });

    return true;
  }(),
  );
}

// app负责主题配置
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   theme: ThemeData(
    //     // This is the theme of your application.
    //     //
    //     // Try running your application with "flutter run". You'll see the
    //     // application has a blue toolbar. Then, without quitting the app, try
    //     // changing the primarySwatch below to Colors.green and then invoke
    //     // "hot reload" (press "r" in the console where you ran "flutter run",
    //     // or simply save your changes to "hot reload" in a Flutter IDE).
    //     // Notice that the counter didn't reset back to zero; the application
    //     // is not restarted.
    //     primarySwatch: Colors.blue,
    //   ),
    //   home: const MyHomePage(title: 'Flutter Demo Home Page'),
    // );
    return const OverlaySupport(
      child: QuietApp(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
