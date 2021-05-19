import 'package:flutter/material.dart';

class PathBar extends StatelessWidget implements PreferredSizeWidget {
  final List? paths;
  final Function(int)? onChanged;
  final IconData? icon;

  PathBar({Key? key, @required this.paths, @required this.onChanged, this.icon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: paths!.length,
          itemBuilder: (context, index) {
            String i = paths![index];
            List splited = i.split("/");
            if (index == 0) {
              return IconButton(
                icon: Icon(
                  Icons.smartphone,
                  color: index == paths!.length - 1
                      ? Theme.of(context).accentColor
                      : Theme.of(context).textTheme.headline6!.color,
                ),
                onPressed: () => onChanged!(index),
              );
            }
            return InkWell(
              onTap: onChanged!(index),
              child: Container(
                height: 40.0,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      "${splited[splited.length - 1]}",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: index == paths!.length - 1
                            ? Theme.of(context).accentColor
                            : Theme.of(context).textTheme.headline6!.color,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Icon(Icons.chevron_right);
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(40.0);
}
