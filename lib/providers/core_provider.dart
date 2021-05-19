import 'package:files_manager/setup/file_utils.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:isolate_handler/isolate_handler.dart';
// import 'package:path_provider/path_provider.dart';

class CoreProvider extends ChangeNotifier {
  List<FileSystemEntity> availableStorageUnits = [];
  List<FileSystemEntity> recentFiles = [];
  final isolates = IsolateHandler();
  int totalSpace = 0;
  int freeSpace = 0;
  int totalSDSpace = 0;
  int freeSDSpace = 0;
  int usedSpace = 0;
  int usedSDSpace = 0;
  bool storageLoading = false;
  bool recentLoading = false;

  // checkSpace() async {
  //   setRecentLoading(true);
  //   setStorageLoading(true);

  //   recentFiles.clear();
  //   availableStorageUnits.clear();
  //   List<FileSystemEntity>? filesList = await getExternalStorageDirectories();
  //   availableStorageUnits.addAll(filesList!);
  //   notifyListeners();

  //   var free = await DiskSpace.getFreeDiskSpace;
  //   var total = await DiskSpace.getTotalDiskSpace;
  //   setFreeSpace(free);
  //   setTotalSpace(total);
  //   setUsedSpace(total! - free!);

  //   if (filesList.length > 1) {
  //     var freeSD = await DiskSpace.getFreeDiskSpace;
  //     var totalSD = await DiskSpace.getTotalDiskSpace;
  //     setFreeSDSpace(freeSD);
  //     setTotalSDSpace(totalSD);
  //     setUsedSDSpace(totalSD! - freeSD!);
  //     notifyListeners();
  //   }
  //   setStorageLoading(true);
  //   getRecentFiles();
  // }

  getRecentFiles() async {
    String isolateName = 'recent';
    isolates.spawn<String>(
      getFilesWithIsolate,
      name: isolateName,
      onReceive: (value) {
        isolates.kill(isolateName);
      },
      onInitialized: () => isolates.send("Hello", to: isolateName),
    );

    ReceivePort _port = ReceivePort();
    IsolateNameServer.registerPortWithName(_port.sendPort, '${isolateName}_2');
    _port.listen((message) {
      recentFiles.addAll(message);
      setRecentLoading(false);
      _port.close();
      IsolateNameServer.removePortNameMapping('${isolateName}_2');
    });
  }

  static getFilesWithIsolate(Map<String, dynamic> context) async {
    String isolateName = context['name'];
    List<FileSystemEntity> filesList =
        await FileUtils.getRecentFiles(showHidden: false);
    final messenger = HandledIsolate.initialize(context);
    final SendPort? send =
        IsolateNameServer.lookupPortByName('${isolateName}_2');
    send!.send(filesList);
    messenger.send('done');
  }

  void setFreeSpace(value) {
    freeSpace = value;
    notifyListeners();
  }

  void setTotalSpace(value) {
    totalSpace = value;
    notifyListeners();
  }

  void setFreeSDSpace(value) {
    freeSDSpace = value;
    notifyListeners();
  }

  void setTotalSDSpace(value) {
    totalSDSpace = value;
    notifyListeners();
  }

  void setUsedSpace(value) {
    usedSpace = value;
    notifyListeners();
  }

  void setUsedSDSpace(value) {
    usedSDSpace = value;
    notifyListeners();
  }

  void setStorageLoading(value) {
    storageLoading = value;
    notifyListeners();
  }

  void setRecentLoading(value) {
    recentLoading = value;
    notifyListeners();
  }
}
