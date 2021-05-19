import 'dart:io';
import 'package:files_manager/widgets/directory_popup.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class DirectoryItem extends StatelessWidget {
  final FileSystemEntity? file;
  final VoidCallback? tap;
  final Function(int)? popTap;

  DirectoryItem(
      {Key? key,
      @required this.file,
      @required this.tap,
      @required this.popTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: tap,
      contentPadding: EdgeInsets.all(0),
      leading: Container(
        height: 40.0,
        width: 40.0,
        child: Center(
          child: Icon(Icons.folder),
        ),
      ),
      title: Text(
        '${basename(file!.path)}',
        style: TextStyle(
          fontSize: 15.0,
        ),
        maxLines: 2,
      ),
      trailing: popTap == null
          ? null
          : DirectoryPopup(path: file!.path, popTap: popTap),
    );
  }
}
