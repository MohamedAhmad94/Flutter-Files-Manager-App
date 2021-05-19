import 'package:files_manager/screens/folder.dart';
import 'package:files_manager/setup/setup.dart';
import 'package:flutter/material.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';

class StorageItem extends StatelessWidget {
  final double? percent;
  final String? title;
  final String? path;
  final Color? color;
  final IconData? icon;
  final int? usedSpace;
  final int? totalSpace;

  StorageItem(
      {Key? key,
      this.percent,
      this.title,
      this.path,
      this.color,
      this.icon,
      this.usedSpace,
      this.totalSpace})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigate.pushPage(context, Folder(title: title, path: path)),
      contentPadding: EdgeInsets.only(right: 20.0),
      leading: Container(
        height: 40.0,
        width: 40.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).dividerColor, width: 2.0),
        ),
        child: Center(
          child: Icon(icon, color: color),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title!),
          // Text(
          //   "${FileUtils.formatBytes(usedSpace, 2)} "
          //   "used of ${FileUtils.formatBytes(totalSpace, 2)}",
          //   style: TextStyle(
          //     fontSize: 15.0,
          //     fontWeight: FontWeight.w300,
          //     color: Theme.of(context).textTheme.headline1!.color,
          //   ),
          // ),
        ],
      ),
      // subtitle: Container(
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
      //   ),
      //   child: LinearPercentIndicator(
      //     padding: EdgeInsets.all(0),
      //     backgroundColor: Colors.grey[300],
      //     percent: percent!,
      //     progressColor: color,
      //   ),
      // ),
    );
  }
}
