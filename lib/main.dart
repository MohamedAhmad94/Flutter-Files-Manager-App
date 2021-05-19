import 'package:files_manager/providers/core_provider.dart';
import 'package:files_manager/providers/providers.dart';
import 'package:files_manager/screens/ios_error.dart';
import 'package:files_manager/screens/splash.dart';
import 'package:files_manager/setup/theme_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppProvider()),
      ChangeNotifierProvider(create: (_) => CoreProvider()),
      ChangeNotifierProvider(create: (_) => CategoryProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder:
        (BuildContext context, AppProvider appProvider, Widget? child) {
      return MaterialApp(
        title: 'Files Manager',
        key: appProvider.key,
        theme: appProvider.theme,
        darkTheme: ThemeConfig.darkTheme,
        navigatorKey: appProvider.navigatorKey,
        debugShowCheckedModeBanner: false,
        home: Platform.isIOS ? IOSError() : Splash(),
      );
    });
  }
}
