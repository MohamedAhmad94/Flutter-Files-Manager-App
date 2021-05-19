import 'package:flutter/material.dart';

class Navigate {
  static Future pushPage(BuildContext context, Widget page) {
    var value = Navigator.push(
        context, MaterialPageRoute(builder: (BuildContext context) => page));

    return value;
  }

  static Future pushPageDialog(BuildContext context, Widget page) {
    var value = Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) => page, fullscreenDialog: true),
    );

    return value;
  }

  static pushPageReplacement(BuildContext context, Widget page) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => page));
  }
}
