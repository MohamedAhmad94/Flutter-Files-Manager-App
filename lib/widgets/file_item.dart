import 'dart:io';
import 'package:files_manager/setup/setup.dart';
import 'package:files_manager/widgets/file_icon.dart';
import 'package:files_manager/widgets/file_popup.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';

class FileItem extends StatelessWidget {
  final FileSystemEntity? file;
  final Function(int)? popTap;

  FileItem({Key? key, @required this.file, this.popTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => OpenFile.open(file!.path),
      contentPadding: EdgeInsets.all(0),
      leading: FileIcon(currentFile: file),
      title: Text(
        "${basename(file!.path)}",
        style: TextStyle(fontSize: 15.0),
        maxLines: 2,
      ),
      subtitle: Text(
          "${FileUtils.formatBytes(file == null ? 678476 : File(file!.path).lengthSync(), 2)},"
          "${file == null ? "Test" : FileUtils.formatTime(File(file!.path).lastModifiedSync().toIso8601String())}"),
      trailing:
          popTap == null ? null : FilePop(path: file!.path, popTap: popTap),
    );
  }
}
