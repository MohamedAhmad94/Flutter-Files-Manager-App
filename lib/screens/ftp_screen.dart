import 'package:flutter/material.dart';

class FTP extends StatefulWidget {
  @override
  _FTPState createState() => _FTPState();
}

class _FTPState extends State<FTP> {
  start() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FTP File Sharing"),
        actions: [
          IconButton(
            icon: Icon(
              Icons.print,
              size: 20.0,
            ),
            onPressed: () {
              start();
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        children: [],
      ),
    );
  }
}
