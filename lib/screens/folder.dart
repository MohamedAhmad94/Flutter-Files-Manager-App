import 'package:flutter/material.dart';
import 'dart:io';
import 'package:files_manager/providers/providers.dart';
import 'package:files_manager/setup/setup.dart';
import 'package:files_manager/widgets/widgets.dart';
import 'package:path/path.dart' as pathlib;
import 'package:provider/provider.dart';

class Folder extends StatefulWidget {
  final String? title;
  final String? path;

  Folder({Key? key, @required this.title, @required this.path})
      : super(key: key);

  @override
  _FolderState createState() => _FolderState();
}

class _FolderState extends State<Folder> with WidgetsBindingObserver {
  String? path;
  List<String> paths = [];

  List<FileSystemEntity> files = [];
  bool showHidden = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState appLifecycleState) {
    if (appLifecycleState == AppLifecycleState.resumed) {
      getFiles();
    }
  }

  getFiles() async {
    try {
      var state = Provider.of<CategoryProvider>(context, listen: false);
      Directory directory = Directory(path!);
      List<FileSystemEntity> directoryFiles = directory.listSync();
      files.clear();
      showHidden = state.showHidden;
      setState(() {});
      for (FileSystemEntity file in directoryFiles) {
        if (!showHidden) {
          if (!pathlib.basename(file.path).startsWith(".")) {
            files.add(file);
            setState(() {});
          }
        } else {
          files.add(file);
          setState(() {});
        }
      }
      files = FileUtils.sortList(files, state.sort);
    } catch (e) {
      if (e.toString().contains("Permission denied")) {
        Dialogs.showToast("Access Permission to this Directory is Denied!");
        navigateBack();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    path = widget.path;
    getFiles();
    paths.add(widget.path!);
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  navigateBack() {
    paths.removeLast();
    path = paths.last;
    setState(() {});
    getFiles();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (paths.length == 1) {
          return true;
        } else {
          paths.removeLast();
          setState(() {
            path = paths.last;
          });
          getFiles();
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (paths.length == 1) {
                Navigator.pop(context);
              } else {
                navigateBack();
              }
            },
          ),
          elevation: 4.0,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${widget.title}"),
              Text(
                "$path",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          bottom: PathBar(
            paths: paths,
            icon: widget.path.toString().contains("emulated")
                ? Icons.smartphone
                : Icons.sd_card,
            onChanged: (index) {
              path = paths[index];
              paths.removeRange(index + 1, paths.length);
              setState(() {});
              getFiles();
            },
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await showModalBottomSheet(
                  context: context,
                  builder: (context) => SortSheet(),
                );
                getFiles();
              },
              tooltip: "Sort By",
              icon: Icon(Icons.sort),
            ),
          ],
        ),
        body: Visibility(
          visible: files.isNotEmpty,
          replacement: Center(child: Text("There's Nothing Here")),
          child: ListView.separated(
            padding: EdgeInsets.only(left: 20.0),
            itemCount: files.length,
            itemBuilder: (context, index) {
              FileSystemEntity file = files[index];
              if (file.toString().split(":")[0] == "Directory") {
                return DirectoryItem(
                  popTap: (value) async {
                    if (value == 0) {
                      renameDialog(context, file.path, "dir");
                    } else if (value == 1) {
                      deleteFile(true, file);
                    }
                  },
                  file: file,
                  tap: () {
                    paths.add(file.path);
                    path = file.path;
                    setState(() {});
                    getFiles();
                  },
                );
              }
              return FileItem(
                file: file,
                popTap: (v) async {
                  if (v == 0) {
                    renameDialog(context, file.path, "file");
                  } else if (v == 1) {
                    deleteFile(false, file);
                  }
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return CustomDivider();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => addDialog(context, path!),
          child: Icon(Icons.add),
          tooltip: "Add Folder",
        ),
      ),
    );
  }

  deleteFile(bool directory, var file) async {
    try {
      if (directory) {
        await Directory(file.path).delete(recursive: true);
      } else {
        await File(file.path).delete(recursive: true);
      }
      Dialogs.showToast('Deleted Successfully');
    } catch (e) {
      if (e.toString().contains('Permission denied')) {
        Dialogs.showToast("Couldn't delete items on your device!");
      }
    }
    getFiles();
  }

  addDialog(BuildContext context, String path) async {
    await showDialog(
      context: context,
      builder: (context) => AddFileDialog(path: path),
    );
    getFiles();
  }

  renameDialog(BuildContext context, String path, String type) async {
    await showDialog(
      context: context,
      builder: (context) => RenameFileDialog(path: path, type: type),
    );
    getFiles();
  }
}
