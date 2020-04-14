import 'dart:io';

import 'package:HFM/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final Widget childText;
  final VoidCallback onPressed;

  Button({@required this.onPressed, this.text, this.childText})
      : assert(childText != null || text != null);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton.filled(
            child: childText == null ? Text(text) : childText,
            pressedOpacity: 0.5,
            onPressed: onPressed,
          )
        : RaisedButton(
            onPressed: onPressed,
            color: colortheme.accentColor,
            child: childText == null
                ? Text(
                    text.toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  )
                : childText,
          );
  }
}
