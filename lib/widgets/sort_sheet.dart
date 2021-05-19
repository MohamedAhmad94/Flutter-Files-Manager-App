import 'package:files_manager/providers/category_provider.dart';
import 'package:files_manager/setup/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SortSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<CategoryProvider>(context, listen: false);
    return FractionallySizedBox(
      heightFactor: 0.85,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15.0),
            Text(
              "Sort By",
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
            SizedBox(height: 10.0),
            Flexible(
              child: ListView.builder(
                  itemCount: Constants.sortList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () async {
                        state.setSort(index);
                        Navigator.pop(context);
                      },
                      contentPadding: EdgeInsets.all(0),
                      trailing: index == state.sort
                          ? Icon(Icons.check, color: Colors.blue, size: 16.0)
                          : SizedBox(),
                      title: Text(
                        "${Constants.sortList[index]}",
                        style: TextStyle(
                          fontSize: 15.0,
                          color: index == state.sort
                              ? Colors.blue
                              : Theme.of(context).textTheme.headline6!.color,
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
