import 'package:files_manager/providers/providers.dart';
import 'package:files_manager/setup/setup.dart';
import 'package:files_manager/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class Downloads extends StatefulWidget {
  final String? title;

  Downloads({Key? key, @required this.title}) : super(key: key);

  @override
  _DownloadsState createState() => _DownloadsState();
}

class _DownloadsState extends State<Downloads> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).getDownloads();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, CategoryProvider state, Widget? child) {
        return DefaultTabController(
          length: state.downloadTabs.length,
          child: Scaffold(
            appBar: AppBar(
              title: Text("${widget.title}"),
              bottom: TabBar(
                indicatorColor: Theme.of(context).accentColor,
                labelColor: Theme.of(context).accentColor,
                unselectedLabelColor:
                    Theme.of(context).textTheme.caption!.color,
                isScrollable: false,
                tabs: Constants.map(state.downloadTabs, (index, label) {
                  return Tab(text: "$label");
                }),
              ),
            ),
            body: Visibility(
              visible: state.downloads.isNotEmpty,
              replacement: Center(
                child: Text("No Files Found"),
              ),
              child: TabBarView(
                  children: Constants.map(state.downloadTabs, (index, label) {
                return ListView.separated(
                  padding: EdgeInsets.only(left: 20.0),
                  itemCount: state.downloads.length,
                  itemBuilder: (context, index) {
                    return FileItem(file: state.downloads[index]);
                  },
                  separatorBuilder: (context, index) {
                    return CustomDivider();
                  },
                );
              })),
            ),
          ),
        );
      },
    );
  }
}
