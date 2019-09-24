import 'package:fill_memo/util/dimensions.dart';
import 'package:flutter/material.dart';

class IconLabel extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  final String text;
  final Color iconColor;

  IconLabel({
    Key key,
    this.backgroundColor,
    this.icon,
    this.text,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimensions.keylineXLarge,
      color: backgroundColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.keyline),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(icon, color: iconColor),
            SizedBox(width: Dimensions.keylineLarge),
            Expanded(child: Text(text)),
          ],
        ),
      ),
    );
  }
}
