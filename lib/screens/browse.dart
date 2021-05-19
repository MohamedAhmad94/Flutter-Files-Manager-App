import 'package:files_manager/providers/providers.dart';
import 'package:files_manager/screens/whatsApp_status.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:files_manager/screens/apps_screen.dart';
import 'package:files_manager/screens/category.dart';
import 'package:files_manager/screens/downloads.dart';
import 'package:files_manager/screens/images.dart';
import 'package:files_manager/screens/search.dart';
import 'package:files_manager/setup/setup.dart';
import 'package:files_manager/widgets/widgets.dart';
import 'package:provider/provider.dart';

class Browse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Files Manager"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            tooltip: "Search",
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: Search(themeData: Theme.of(context)));
            },
          ),
        ],
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(left: 20.0),
        children: [
          SizedBox(height: 20.0),
          sectionTitle("Storge Devices"),
          _StorageSection(),
          CustomDivider(),
          SizedBox(height: 20.0),
          sectionTitle('Categories'),
          SizedBox(height: 20.0),
          _CategoriesSection(),
          CustomDivider(),
          SizedBox(height: 20.0),
          sectionTitle('Recent Files'),
          _RecentFiles(),
        ],
      ),
    );
  }

  // refresh(BuildContext context) async {
  //   await Provider.of<CoreProvider>(context, listen: false).checkSpace();
  // }

  sectionTitle(String? title) {
    return Text(
      title!,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
    );
  }
}

class _StorageSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CoreProvider>(
      builder: (BuildContext context, state, Widget? child) {
        if (state.storageLoading) {
          return Container(
            height: 100.0,
            child: Loading(),
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: state.availableStorageUnits.length,
          itemBuilder: (context, index) {
            FileSystemEntity item = state.availableStorageUnits[index];
            String path = item.path.split("Android")[0];
            // double percent = 0.0;

            // if (index == 0) {
            //   percent = calPercent(state.usedSpace, state.totalSpace);
            // } else {
            //   percent = calPercent(state.usedSDSpace, state.totalSDSpace);
            // }
            return StorageItem(
              //percent: percent,
              path: path,
              title: index == 0 ? "Device" : "SD Card",
              icon: index == 0 ? Icons.smartphone : Icons.sd_card,
              color: index == 0 ? Colors.lightBlue : Colors.orange,
              //usedSpace: index == 0 ? state.usedSpace : state.usedSDSpace,
              // totalSpace: index == 0 ? state.totalSpace : state.totalSDSpace,
            );
          },
          separatorBuilder: (context, index) {
            return CustomDivider();
          },
        );
      },
    );
  }

  // calPercent(int? usedSpace, int? totalSpace) {
  //   return double.parse((usedSpace! / totalSpace! * 100).toStringAsFixed(0)) /
  //       100;
  // }
}

class _CategoriesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: Constants.categories.length,
      itemBuilder: (context, index) {
        Map category = Constants.categories[index];
        return ListTile(
          onTap: () {
            if (index == Constants.categories.length - 1) {
              if (Directory(FileUtils.whatsAppPath).existsSync()) {
                Navigate.pushPage(
                    context, WhatsAppStatus(title: "${category["title"]}"));
              } else {
                Dialogs.showToast("Install WhatsApp to use this feature");
              }
            } else if (index == 0) {
              Navigate.pushPage(
                  context, Downloads(title: "${category["title"]}"));
            } else if (index == 5) {
              Navigate.pushPage(context, AppsScreen());
            } else {
              Navigate.pushPage(
                context,
                index == 1 || index == 2
                    ? Images(title: "${category["title"]}")
                    : Category(title: "${category["title"]}"),
              );
            }
          },
          contentPadding: EdgeInsets.all(0),
          leading: Container(
            height: 40.0,
            width: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: 2.0,
              ),
            ),
            child: Icon(category["icon"], size: 18, color: category["color"]),
          ),
          title: Text("${category["title"]}"),
        );
      },
      separatorBuilder: (context, index) {
        return CustomDivider();
      },
    );
  }
}

class _RecentFiles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CoreProvider>(
      builder: (BuildContext context, state, Widget? child) {
        if (state.recentLoading) {
          return Container(
            height: 150.0,
            child: Loading(),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.only(right: 20),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount:
              state.recentFiles.length > 5 ? 5 : state.recentFiles.length,
          itemBuilder: (context, index) {
            FileSystemEntity file = state.recentFiles[index];
            return file.existsSync() ? FileItem(file: file) : SizedBox();
          },
          separatorBuilder: (context, index) {
            return Container(
              height: 1.0,
              color: Theme.of(context).dividerColor,
            );
          },
        );
      },
    );
  }
}
