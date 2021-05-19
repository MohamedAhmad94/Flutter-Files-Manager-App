import 'dart:io';
import 'package:files_manager/providers/providers.dart';
import 'package:files_manager/setup/setup.dart';
import 'package:files_manager/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mime_type/mime_type.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';

class Images extends StatefulWidget {
  final String? title;

  Images({Key? key, @required this.title}) : super(key: key);

  @override
  _ImagesState createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      if (widget.title!.toLowerCase() == "images") {
        Provider.of<CategoryProvider>(context, listen: false).getImges("image");
      } else {
        Provider.of<CategoryProvider>(context, listen: false).getImges("video");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, CategoryProvider state, Widget? child) {
        if (state.loading) {
          return Scaffold(
            body: Loading(),
          );
        }
        return DefaultTabController(
          length: state.imageTabs.length,
          child: Scaffold(
            appBar: AppBar(
              title: Text("${widget.title}"),
              bottom: TabBar(
                indicatorColor: Theme.of(context).accentColor,
                labelColor: Theme.of(context).accentColor,
                unselectedLabelColor:
                    Theme.of(context).textTheme.caption!.color,
                isScrollable: state.imageTabs.length < 3 ? false : true,
                onTap: (value) => state.switchCurrentFiles(
                    state.images, state.imageTabs[value]),
                tabs: Constants.map(
                  state.imageTabs,
                  (index, label) {
                    return Tab(text: "$label");
                  },
                ),
              ),
            ),
            body: Visibility(
              visible: state.images.isNotEmpty,
              replacement: Center(child: Text("No Files Found")),
              child: TabBarView(
                children: Constants.map(state.imageTabs, (index, label) {
                  List list = state.currentFiles;
                  return CustomScrollView(
                    primary: false,
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.all(10.0),
                        sliver: SliverGrid.count(
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                          crossAxisCount: 2,
                          children: Constants.map(
                              index == 0
                                  ? state.images
                                  : list.reversed.toList(), (index, item) {
                            File file = File(item.path);
                            String path = file.path;
                            String? mimeType = mime(path);
                            return _MediaTile(file: file, mimeType: mimeType);
                          }),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MediaTile extends StatelessWidget {
  final File? file;
  final String? mimeType;

  _MediaTile({this.file, this.mimeType});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => OpenFile.open(file!.path),
      child: GridTile(
        header: Container(
          height: 50.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black54, Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: mimeType!.split("/")[0] == "video"
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${FileUtils.formatBytes(file!.lengthSync(), 1)}",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.play_circle_filled,
                          color: Colors.white,
                          size: 15.0,
                        ),
                      ],
                    )
                  : Text(
                      "${FileUtils.formatBytes(file!.lengthSync(), 1)}",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
            ),
          ),
        ),
        child: mimeType!.split("/")[0] == "video"
            ? FileIcon(currentFile: file)
            : Image(
                image: ResizeImage(FileImage(File(file!.path)),
                    height: 70, width: 100),
                fit: BoxFit.cover,
                errorBuilder: (b, o, c) {
                  return Icon(Icons.image);
                },
              ),
      ),
    );
  }
}
