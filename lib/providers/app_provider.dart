import 'package:files_manager/setup/theme_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppProvider extends ChangeNotifier {
  AppProvider() {
    checkTheme();
  }

  ThemeData theme = ThemeConfig.lightTheme;
  Key key = UniqueKey();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void setKey(value) {
    key = value;
    notifyListeners();
  }

  void setNavigatorKey(value) {
    navigatorKey = value;
    notifyListeners();
  }

  void setTheme(value, choice) {
    theme = value;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("theme", choice).then((val) {
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: choice == "dark"
              ? ThemeConfig.darkPrimary
              : ThemeConfig.lightPrimary,
          statusBarIconBrightness:
              choice == "dark" ? Brightness.light : Brightness.dark,
        ));
      });
    });
    notifyListeners();
  }

  ThemeData getTheme(value) {
    return theme;
  }

  Future<ThemeData> checkTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ThemeData? currentTheme;
    String? userPrefs =
        prefs.getString("theme") == null ? "light" : prefs.getString("theme");

    if (userPrefs == "light") {
      currentTheme = ThemeConfig.lightTheme;
      setTheme(ThemeConfig.lightTheme, "light");
    } else {
      currentTheme = ThemeConfig.darkTheme;
      setTheme(ThemeConfig.darkTheme, "dark");
    }

    return currentTheme;
  }
}
