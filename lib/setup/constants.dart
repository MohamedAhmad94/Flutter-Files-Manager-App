import 'package:flutter/material.dart';

class Constants {
  static List<T> map<T>(List? list, Function? handler) {
    List<T> result = [];
    for (var i = 0; i < list!.length; i++) {
      result.add(handler!(i, list[i]));
    }

    return result;
  }

  static List categories = [
    {
      "title": "Downloads",
      "icon": Icons.download_sharp,
      "path": "",
      "color": Colors.purple,
    },
    {
      "title": "Images",
      "icon": Icons.image_rounded,
      "path": "",
      "color": Colors.blue,
    },
    {
      "title": "Videos",
      "icon": Icons.video_label,
      "path": "",
      "color": Colors.red,
    },
    {
      "title": "Audio",
      "icon": Icons.headset,
      "path": "",
      "color": Colors.teal,
    },
    {
      "title": "Documents & Others",
      "icon": Icons.file_present,
      "path": "",
      "color": Colors.pink,
    },
    {
      "title": "Apps",
      "icon": Icons.android_outlined,
      "path": "",
      "color": Colors.green,
    },
    {
      "title": "WhatsApp Statuses",
      "icon": Icons.chat_bubble,
      "path": "",
      "color": Colors.green,
    },
  ];

  static List<String> sortList = [
    "File Name (A to Z)",
    "File Name (Z to A)",
    "Date (Oldest First)",
    "Date (Newest First)",
    "Size (Largest First)",
    "Size (Smallest First)",
  ];
}
