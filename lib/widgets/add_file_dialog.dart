import 'package:files_manager/setup/dialogs.dart';
import 'package:files_manager/widgets/custom_alert.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class AddFileDialog extends StatelessWidget {
  final String? path;

  AddFileDialog({this.path});

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomAlert(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 15.0),
            Text(
              "Add New Folder",
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 25.0),
            TextField(
              controller: _nameController,
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40.0,
                  width: 130.0,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Text(
                        "Create",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_nameController.text.isNotEmpty) {
                          if (!Directory(path! + "/${_nameController.text}")
                              .existsSync()) {
                            await Directory(path! + "/${_nameController.text}")
                                .create()
                                .catchError((e) {
                              if (e.toString().contains("Permission denied")) {
                                Dialogs.showToast(
                                    "Couldn't create folders on this device!");
                              }
                            });
                          } else {
                            Dialogs.showToast(
                                "A Folder with the same name already exists!");
                          }
                          Navigator.pop(context);
                        }
                      }),
                ),
                Container(
                  height: 40.0,
                  width: 130.0,
                  child: OutlinedButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      side: MaterialStateProperty.all(
                        BorderSide(color: Theme.of(context).accentColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
