import 'dart:io';
import 'package:files_manager/setup/setup.dart';
import 'package:files_manager/widgets/video_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:mime_type/mime_type.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';

class WhatsAppStatus extends StatelessWidget {
  final String? title;

  WhatsAppStatus({Key? key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<FileSystemEntity> files = Directory(FileUtils.whatsAppPath).listSync()
      ..removeWhere((i) => basename(i.path).split("")[0] == ".");
    return Scaffold(
      appBar: AppBar(
        title: Text("$title"),
      ),
      body: CustomScrollView(
        primary: false,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(10.0),
            sliver: SliverGrid.count(
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
              crossAxisCount: 2,
              children: Constants.map(files, (index, item) {
                FileSystemEntity systemFile = files[index];
                String path = systemFile.path;
                File file = File(path);
                String? mimeType = mime(path);

                return mimeType == null
                    ? SizedBox()
                    : _WhatsAppItem(
                        file: file,
                        path: path,
                        mimeType: mimeType,
                      );
              }),
            ),
          )
        ],
      ),
    );
  }
}

class _WhatsAppItem extends StatelessWidget {
  final File? file;
  final String? path;
  final String? mimeType;

  _WhatsAppItem({this.file, this.path, this.mimeType});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => OpenFile.open(file!.path),
      child: GridTile(
        header: Container(
          height: 50.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black54,
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.download_sharp,
                      color: Colors.white,
                      size: 15.0,
                    ),
                    onPressed: () => saveMedia(),
                  ),
                  mimeType!.split("/")[0] == "video"
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${FileUtils.formatBytes(file!.lengthSync(), 1)}",
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 5.0),
                            Icon(
                              Icons.play_circle_filled,
                              color: Colors.white,
                              size: 15.0,
                            )
                          ],
                        )
                      : Text(
                          "${FileUtils.formatBytes(file!.lengthSync(), 1)}",
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.white,
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
        child: mimeType!.split("/")[0] == "video"
            ? VideoThumbnail(path: path)
            : Image(
                image: ResizeImage(
                  FileImage(
                    File(file!.path),
                  ),
                  height: 70,
                  width: 100,
                ),
                fit: BoxFit.cover,
                errorBuilder: (b, o, c) {
                  return Icon(Icons.image);
                },
              ),
      ),
    );
  }

  saveMedia() async {
    String rootPath = '/storage/emulated/0/';
    await Directory("${rootPath}files_manager").create();
    await Directory("${rootPath}files_manager/Whatsapp Status").create();
    await file!
        .copy("${rootPath}files_manager/Whatsapp Status/${basename(path!)}");

    Dialogs.showToast("Saved");
  }
}
