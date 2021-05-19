import 'dart:io';
import 'package:files_manager/widgets/video_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';

class FileIcon extends StatelessWidget {
  final FileSystemEntity? currentFile;

  FileIcon({Key? key, @required this.currentFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    File file = File(currentFile!.path);
    String _extension = extension(file.path).toLowerCase();
    String? mimeType = mime(basename(currentFile!.path).toLowerCase());
    String type = mimeType == null ? "" : mimeType.split("/")[0];

    if (_extension == ".apk") {
      return Icon(Icons.android, color: Colors.green);
    } else if (_extension == ".crdownload") {
      return Icon(Icons.download_rounded, color: Colors.lightBlue);
    } else if (_extension == ".zip" || _extension.contains("tar")) {
      return Icon(Icons.archive);
    } else if (_extension == ".epub" ||
        _extension == ".pdf" ||
        _extension == ".mobi") {
      return Icon(Icons.file_present, color: Colors.orangeAccent);
    } else {
      switch (type) {
        case "image":
          return Container(
            width: 50,
            height: 50,
            child: Image(
              errorBuilder: (b, o, c) {
                return Icon(Icons.image);
              },
              image: ResizeImage(FileImage(File(file.path)),
                  width: 50, height: 50),
            ),
          );
        case "video":
          return Container(
            height: 40,
            width: 40,
            child: VideoThumbnail(
              path: file.path,
            ),
          );

        case "audio":
          return Icon(Icons.audiotrack, color: Colors.blue);

        case "text":
          return Icon(Icons.file_present, color: Colors.orangeAccent);

        default:
          return Icon(Icons.file_copy);
      }
    }
  }
}
