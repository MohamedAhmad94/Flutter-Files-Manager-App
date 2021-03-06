import 'package:flutter/material.dart';

class DirectoryPopup extends StatelessWidget {
  final String? path;
  final Function(int)? popTap;

  DirectoryPopup({Key? key, @required this.path, @required this.popTap})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      onSelected: popTap,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: Text("Rename"),
        ),
        PopupMenuItem(
          value: 1,
          child: Text("Delete"),
        ),
      ],
      icon: Icon(
        Icons.arrow_drop_down,
        color: Theme.of(context).textTheme.headline6!.color,
      ),
      color: Theme.of(context).scaffoldBackgroundColor,
      offset: Offset(0, 30),
    );
  }
}
