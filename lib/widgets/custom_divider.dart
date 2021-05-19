import 'package:flutter/material.dart';

class CustomDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: size.width - 70.0,
            height: 1.0,
            color: Theme.of(context).dividerColor,
          ),
        )
      ],
    );
  }
}
