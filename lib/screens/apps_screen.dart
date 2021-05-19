import 'package:files_manager/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:device_apps/device_apps.dart';

class AppsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Installed Apps"),
      ),
      body: FutureBuilder<List<Application>>(
          future: DeviceApps.getInstalledApplications(
            onlyAppsWithLaunchIntent: true,
            includeSystemApps: true,
            includeAppIcons: true,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Application>? data = snapshot.data;

              data!
                ..sort((app1, app2) => app1.appName
                    .toLowerCase()
                    .compareTo(app2.appName.toLowerCase()));
              return ListView.separated(
                padding: EdgeInsets.only(left: 10.0),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  Application app = data[index];
                  return ListTile(
                    leading: app is ApplicationWithIcon
                        ? Image.memory(app.icon, height: 40, width: 40)
                        : null,
                    title: Text(app.appName),
                    subtitle: Text("${app.packageName}"),
                    onTap: () => DeviceApps.openApp(app.packageName),
                  );
                },
                separatorBuilder: (context, index) {
                  return CustomDivider();
                },
              );
            }
            return Loading();
          }),
    );
  }
}
