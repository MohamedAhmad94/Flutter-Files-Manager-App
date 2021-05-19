import 'package:files_manager/setup/setup.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:isolate_handler/isolate_handler.dart';
import 'package:mime_type/mime_type.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class CategoryProvider extends ChangeNotifier {
  CategoryProvider() {
    getHidden();
    getSort();
  }
  bool loading = false;
  bool showHidden = false;
  int sort = 0;
  final isolates = IsolateHandler();

  List<FileSystemEntity> downloads = [];
  List<String> downloadTabs = [];

  List<FileSystemEntity> images = [];
  List<String> imageTabs = [];

  List<FileSystemEntity> audioFiles = [];
  List<String> audioTabs = [];
  List<FileSystemEntity> currentFiles = [];

  getDownloads() async {
    setLoading(true);

    downloadTabs.clear();
    downloads.clear();
    downloadTabs.add("All");

    List<Directory> storageUnits = await FileUtils.getStorageList();
    storageUnits.forEach((dir) {
      if (Directory(dir.path + "Download").existsSync()) {
        List<FileSystemEntity> files =
            Directory(dir.path + "Download").listSync();
        files.forEach((file) {
          if (FileSystemEntity.isFileSync(file.path)) {
            downloads.add(file);
            downloadTabs
                .add(file.path.split("/")[file.path.split("/").length - 2]);
            downloadTabs = downloadTabs.toSet().toList();
            notifyListeners();
          }
        });
      }
    });
    setLoading(false);
  }

  getImges(String? type) async {
    setLoading(true);

    imageTabs.clear();
    images.clear();
    imageTabs.add("All");

    String isolateName = type!;
    isolates.spawn<String>(
      getAllFilesWithIsolate,
      name: isolateName,
      onReceive: (val) {
        isolates.kill(isolateName);
      },
      onInitialized: () => isolates.send("Hello", to: isolateName),
    );
    ReceivePort _port = ReceivePort();
    IsolateNameServer.registerPortWithName(_port.sendPort, '${isolateName}_2');
    _port.listen((files) {
      files.forEach((file) {
        String? mimeType = mime(file.path) == null ? "" : mime(file.path);
        if (mimeType!.split("/")[0] == type) {
          images.add(file);
          imageTabs
              .add("${file.path.split("/")[file.path.split("/").length - 2]}");
          imageTabs = imageTabs.toSet().toList();
        }
        notifyListeners();
      });

      currentFiles = images;
      setLoading(false);
      _port.close();
      IsolateNameServer.removePortNameMapping('${isolateName}_2');
    });
  }

  static getAllFilesWithIsolate(Map<String, dynamic> context) async {
    String isolateName = context['name'];
    List<FileSystemEntity> files =
        await FileUtils.getAllFiles(showHidden: false);
    final messenger = HandledIsolate.initialize(context);
    try {
      final SendPort? send =
          IsolateNameServer.lookupPortByName('${isolateName}_2');
      send!.send(files);
    } catch (e) {
      print(e);
    }
    messenger.send('done');
  }

  getAudios(String type) async {
    setLoading(true);

    audioTabs.clear();
    audioFiles.clear();
    audioTabs.add("All");
    String isolateName = type;
    isolates.spawn<String>(
      getAllFilesWithIsolate,
      name: isolateName,
      onReceive: (val) {
        isolates.kill(isolateName);
      },
      onInitialized: () => isolates.send('Hello', to: isolateName),
    );
    ReceivePort _port = ReceivePort();
    IsolateNameServer.registerPortWithName(_port.sendPort, '${isolateName}_2');
    _port.listen((files) async {
      List tabs = await compute(separateAudios, {'files': files, 'type': type});
      audioFiles = tabs[0];
      audioTabs = tabs[1];

      setLoading(false);
      _port.close();
      IsolateNameServer.removePortNameMapping('${isolateName}_2');
    });
  }

  switchCurrentFiles(List? list, String? label) async {
    List<FileSystemEntity> filesList =
        await compute(getTabImages, [list, label]);
    currentFiles = filesList;
    notifyListeners();
  }

  static Future<List<FileSystemEntity>> getTabImages(List? item) async {
    List items = item![0];
    String label = item[1];
    List<FileSystemEntity> files = [];
    items.forEach((file) {
      if ("${file.path.split("/")[file.path.split("/").length - 2]}" == label) {
        files.add(file);
      }
    });
    return files;
  }

  static Future<List> separateAudios(Map? body) async {
    List files = body!['files'];
    String type = body['type'];
    List<FileSystemEntity> audioFiles = [];
    List<String> audioTabs = [];
    for (File file in files) {
      String? mimeType = mime(file.path);
      if (type == 'text' && docExtensions.contains(extension(file.path))) {
        audioFiles.add(file);
      }
      if (mimeType != null) {
        if (mimeType.split("/")[0] == type) {
          audioFiles.add(file);
          audioTabs
              .add("${file.path.split("/")[file.path.split("/").length - 2]}");
          audioTabs = audioTabs.toSet().toList();
        }
      }
    }
    return [audioFiles, audioTabs];
  }

  static List docExtensions = [
    '.pdf',
    '.epub',
    '.mobi',
    '.doc',
  ];

  setHidden(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hidden', value);
    showHidden = value;
    notifyListeners();
  }

  getHidden() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? val =
        prefs.getBool('hidden') == null ? false : prefs.getBool('hidden');
    setHidden(val);
  }

  Future setSort(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sort', value);
    sort = value;
    notifyListeners();
  }

  getSort() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? val = prefs.getInt("sort") == null ? 0 : prefs.getInt("sort");
    setSort(val);
  }

  void setLoading(value) {
    loading = value;
    notifyListeners();
  }
}
