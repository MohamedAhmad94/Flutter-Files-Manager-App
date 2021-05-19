import 'dart:io' show Platform;
import 'package:device_info/device_info.dart';
import 'package:files_manager/providers/providers.dart';
import 'package:files_manager/screens/about.dart';
import 'package:files_manager/setup/setup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  void initState() {
    super.initState();
    checkPaltform();
  }

  int sdkVersion = 0;

  checkPaltform() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin? deviceInfo;
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo!.androidInfo;
      sdkVersion = androidDeviceInfo.version.sdkInt;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        physics: NeverScrollableScrollPhysics(),
        children: [
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.all(0),
            title: Text("View Hidden Files"),
            secondary: Icon(Icons.remove_red_eye),
            value: Provider.of<CategoryProvider>(context).showHidden,
            onChanged: (value) {
              Provider.of<CategoryProvider>(context, listen: false)
                  .setHidden(value);
            },
            activeColor: Theme.of(context).accentColor,
          ),
          Container(
            height: 1.0,
            color: Theme.of(context).accentColor,
          ),
          MediaQuery.of(context).platformBrightness !=
                  ThemeConfig.darkTheme.brightness
              ? SwitchListTile.adaptive(
                  contentPadding: EdgeInsets.all(0),
                  title: Text("Dark Mode"),
                  secondary: Icon(Icons.brightness_low),
                  value: Provider.of<AppProvider>(context).theme ==
                          ThemeConfig.lightTheme
                      ? false
                      : true,
                  onChanged: (value) {
                    if (value) {
                      Provider.of<AppProvider>(context, listen: false)
                          .setTheme(ThemeConfig.darkTheme, "dark");
                    } else {
                      Provider.of<AppProvider>(context, listen: false)
                          .setTheme(ThemeConfig.lightTheme, "light");
                    }
                  },
                  activeColor: Theme.of(context).accentColor,
                )
              : SizedBox(),
          MediaQuery.of(context).platformBrightness !=
                  ThemeConfig.darkTheme.brightness
              ? Container(
                  height: 1.0,
                  color: Theme.of(context).dividerColor,
                )
              : SizedBox(),
          ListTile(
            contentPadding: EdgeInsets.all(0),
            onTap: () => showLicensePage(context: context),
            leading: Icon(Icons.file_present),
            title: Text("View Source Licences"),
          ),
          Container(
            height: 1.0,
            color: Theme.of(context).dividerColor,
          ),
          ListTile(
            contentPadding: EdgeInsets.all(0),
            onTap: () => Navigate.pushPage(context, About()),
            leading: Icon(Icons.info),
            title: Text("About"),
          ),
          Container(
            height: 1.0,
            color: Theme.of(context).dividerColor,
          ),
        ],
      ),
    );
  }
}
