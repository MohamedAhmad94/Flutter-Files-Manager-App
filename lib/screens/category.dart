import 'dart:io';
import 'package:files_manager/providers/providers.dart';
import 'package:files_manager/setup/setup.dart';
import 'package:files_manager/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class Category extends StatefulWidget {
  final String? title;

  Category({Key? key, @required this.title}) : super(key: key);
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      switch (widget.title!.toLowerCase()) {
        case 'audio':
          Provider.of<CategoryProvider>(context, listen: false)
              .getAudios('audio');
          break;

        case 'documents & others':
          Provider.of<CategoryProvider>(context, listen: false)
              .getAudios('text');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, CategoryProvider state, Widget? child) {
        return state.loading
            ? Scaffold(body: Loading())
            : DefaultTabController(
                length: state.audioTabs.length,
                child: Scaffold(
                  appBar: AppBar(
                    title: Text("${widget.title}"),
                    bottom: TabBar(
                      indicatorColor: Theme.of(context).accentColor,
                      labelColor: Theme.of(context).accentColor,
                      unselectedLabelColor:
                          Theme.of(context).textTheme.caption!.color,
                      isScrollable: state.audioTabs.length < 3 ? false : true,
                      tabs: Constants.map(state.audioTabs, (index, label) {
                        return Tab(text: "$label");
                      }),
                    ),
                  ),
                  body: state.audioFiles.isEmpty
                      ? Center(child: Text("No Files Found"))
                      : TabBarView(
                          children: Constants.map(
                            state.audioTabs,
                            (index, label) {
                              List list = [];
                              List items = state.audioFiles;
                              items.forEach((file) {
                                if ("${file.path.split("/")[file.path.split("/").length - 2]}" ==
                                    label) {
                                  list.add(file);
                                }
                              });
                              return ListView.separated(
                                padding: EdgeInsets.only(left: 20),
                                itemCount: index == 0
                                    ? state.audioFiles.length
                                    : list.length,
                                itemBuilder: (context, index) {
                                  FileSystemEntity file = index == 0
                                      ? state.audioFiles[index]
                                      : list[index];
                                  return FileItem(file: file);
                                },
                                separatorBuilder: (context, index) {
                                  return CustomDivider();
                                },
                              );
                            },
                          ),
                        ),
                ),
              );
      },
    );
  }
}
