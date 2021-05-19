import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  static String whatsAppPath = "/storage/emulated/0/WhatsApp/Media/.Statuses";

// Converting Bytes to KB, MB, GB...etc
  static String formatBytes(bytes, decimals) {
    if (bytes == 0) return "0.0 KB";

    var k = 1024;
    var dm = decimals <= 0 ? 0 : decimals;
    var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
    var i = (log(bytes) / log(k)).floor();

    return (((bytes / pow(k, i)).toStringAsFixed(dm)) + ' ' + sizes[i]);
  }

  // Get file information
  static String getMime(String? path) {
    File file = File(path!);
    String? mimeType = mime(file.path);

    return mimeType!;
  }

  // Return a list of available storage paths
  static Future<List<Directory>> getStorageList() async {
    List<Directory>? paths = await getExternalStorageDirectories();
    List<Directory>? filteredPaths = [];

    for (Directory dir in paths!) {
      filteredPaths.add(removeDataDirectory(dir.path));
    }

    return filteredPaths;
  }

  static Directory removeDataDirectory(String? path) {
    return Directory(path!.split("Android")[0]);
  }

  // Return all files & directories in a directory
  static Future<List<FileSystemEntity>> getFilesInPath(String? path) async {
    Directory directory = Directory(path!);

    return directory.listSync();
  }

  // Return all files on the device
  static Future<List<FileSystemEntity>> getAllFiles({bool? showHidden}) async {
    List<Directory> storageUnits = await getStorageList();
    List<FileSystemEntity> files = [];

    for (Directory dir in storageUnits) {
      List<FileSystemEntity> allFilesInPath = [];

      try {
        allFilesInPath =
            await getAllFilesInPath(dir.path, showHidden: showHidden);
      } catch (e) {
        allFilesInPath = [];
        print(e);
      }
      files.addAll(allFilesInPath);
    }
    return files;
  }

  // Return all files
  static Future<List<FileSystemEntity>> getAllFilesInPath(String path,
      {bool? showHidden}) async {
    List<FileSystemEntity> files = [];
    Directory directory = Directory(path);
    List<FileSystemEntity> subDirectoriesList = directory.listSync();

    for (FileSystemEntity file in subDirectoriesList) {
      if (FileSystemEntity.isFileSync(file.path)) {
        if (!showHidden!) {
          if (!basename(file.path).startsWith(".")) {
            files.add(file);
          }
        } else {
          files.add(file);
        }
      } else {
        if (!file.path.contains("/storage/emulated/0/Android")) {
          if (!showHidden!) {
            if (!basename(file.path).startsWith(".")) {
              files.addAll(
                  await getAllFilesInPath(file.path, showHidden: showHidden));
            }
          } else {
            files.addAll(
                await getAllFilesInPath(file.path, showHidden: showHidden));
          }
        }
      }
    }
    return files;
  }

  static Future<List<FileSystemEntity>> getRecentFiles(
      {bool? showHidden}) async {
    List<FileSystemEntity> files = await getAllFiles(showHidden: showHidden);

    files.sort((a, b) => File(a.path)
        .lastAccessedSync()
        .compareTo(File(b.path).lastAccessedSync()));

    return files.reversed.toList();
  }

  static Future<List<FileSystemEntity>> searchFiles(String? query,
      {bool? showHidden}) async {
    List<Directory> storageUnits = await getStorageList();
    List<FileSystemEntity> files = [];

    for (Directory dir in storageUnits) {
      List searchedFiles =
          await getAllFilesInPath(dir.path, showHidden: showHidden);
      for (FileSystemEntity searchedFile in searchedFiles) {
        if (basename(searchedFile.path)
            .toLowerCase()
            .contains(query!.toLowerCase())) {
          files.add(searchedFile);
        }
      }
    }
    return files;
  }

  static String formatTime(String iso) {
    DateTime date = DateTime.parse(iso);
    DateTime now = DateTime.now();
    DateTime previousDay = DateTime.now().subtract(Duration(days: 1));
    DateTime dateFormat = DateTime.parse(
        "${date.year}-${date.month.toString().padLeft(2, "0")}-${date.day.toString().padLeft(2, "0")}T00:00:00.000Z");
    DateTime today = DateTime.parse(
        "${now.year}-${now.month.toString().padLeft(2, "0")}-${now.day.toString().padLeft(2, "0")}T00:00:00.000Z");
    DateTime yesterday = DateTime.parse(
        "${previousDay.year}-${previousDay.month.toString().padLeft(2, "0")}-${previousDay.day.toString().padLeft(2, "0")}T00:00:00.000Z");

    if (dateFormat == today) {
      return "Today ${DateFormat("HH:mm").format(DateTime.parse(iso))}";
    } else if (dateFormat == yesterday) {
      return "Yesterday ${DateFormat("HH:mm").format(DateTime.parse(iso))}";
    } else {
      return "${DateFormat("MMM dd, HH:mm").format(DateTime.parse(iso))}";
    }
  }

  static List<FileSystemEntity> sortList(
      List<FileSystemEntity>? list, int? sort) {
    switch (sort) {
      case 0:
        if (list!.toString().contains("Directory")) {
          list
            ..sort((a, b) => basename(a.path)
                .toLowerCase()
                .compareTo(basename(b.path).toLowerCase()));

          return list
            ..sort((a, b) => a
                .toString()
                .split(":")[0]
                .toLowerCase()
                .compareTo(b.toString().split(":")[0].toLowerCase()));
        } else {
          return list
            ..sort((a, b) => basename(a.path)
                .toLowerCase()
                .compareTo(basename(b.path).toLowerCase()));
        }

      case 1:
        list!.sort((a, b) => basename(a.path)
            .toLowerCase()
            .compareTo(basename(b.path).toLowerCase()));
        if (list.toString().contains("Directory")) {
          list
            ..sort((a, b) => a
                .toString()
                .split(":")[0]
                .toLowerCase()
                .compareTo(b.toString().split(":")[0].toLowerCase()));
        }
        return list.reversed.toList();

      case 2:
        return list!
          ..sort((a, b) => FileSystemEntity.isFileSync(a.path) &&
                  FileSystemEntity.isFileSync(b.path)
              ? File(a.path)
                  .lastModifiedSync()
                  .compareTo(File(b.path).lastModifiedSync())
              : 1);

      case 3:
        list!
          ..sort((a, b) => FileSystemEntity.isFileSync(a.path) &&
                  FileSystemEntity.isFileSync(b.path)
              ? File(a.path)
                  .lastModifiedSync()
                  .compareTo(File(b.path).lastModifiedSync())
              : 1);
        return list.reversed.toList();

      case 4:
        list!
          ..sort((a, b) => FileSystemEntity.isFileSync(a.path) &&
                  FileSystemEntity.isFileSync(b.path)
              ? File(a.path).lengthSync().compareTo(File(b.path).lengthSync())
              : 0);
        return list.reversed.toList();

      case 5:
        return list!
          ..sort((a, b) => FileSystemEntity.isFileSync(a.path) &&
                  FileSystemEntity.isFileSync(b.path)
              ? File(a.path).lengthSync().compareTo(File(b.path).lengthSync())
              : 0);

      default:
        return list!..sort();
    }
  }
}
