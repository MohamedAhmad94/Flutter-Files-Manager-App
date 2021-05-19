import 'package:files_manager/widgets/custom_alert.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as pathlib;
import 'dart:io';
import 'package:files_manager/setup/dialogs.dart';

class RenameFileDialog extends StatefulWidget {
  final String? path;
  final String? type;

  RenameFileDialog({this.path, this.type});
  @override
  _RenameFileDialogState createState() => _RenameFileDialogState();
}

class _RenameFileDialogState extends State<RenameFileDialog> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = pathlib.basename(widget.path!);
  }

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
              "Rename",
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
                      "Confirm",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_nameController.text.isNotEmpty) {
                        if (widget.type == "file") {
                          if (!File(widget.path!.replaceAll(
                                      pathlib.basename(widget.path!), "") +
                                  "${_nameController.text}")
                              .existsSync()) {
                            await File(widget.path!)
                                .rename(widget.path!.replaceAll(
                                        pathlib.basename(widget.path!), "") +
                                    "${_nameController.text}")
                                .catchError((e) {
                              if (e.toString().contains("Permission denied")) {
                                Dialogs.showToast(
                                    "Couldn't rename items on this device");
                              }
                            });
                          } else {
                            Dialogs.showToast(
                                "A File with the same name already exists!");
                          }
                        } else {
                          if (Directory(widget.path!.replaceAll(
                                      pathlib.basename(widget.path!), "") +
                                  "${_nameController.text}")
                              .existsSync()) {
                            Dialogs.showToast(
                                "A Folder with the same name already exists!");
                          } else {
                            await Directory(widget.path!)
                                .rename(widget.path!.replaceAll(
                                        pathlib.basename(widget.path!), "") +
                                    "${_nameController.text}")
                                .catchError((e) {
                              if (e.toString().contains("Permission denied")) {
                                Dialogs.showToast(
                                    "Couldn't rename items on this device!");
                              }
                            });
                          }
                        }
                        Navigator.pop(context);
                      }
                    },
                  ),
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
