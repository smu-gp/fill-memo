import 'package:flutter/material.dart';

class SubHeader extends StatelessWidget {
  final String content;
  final Color color;
  final bool bold;
  final double padding;

  const SubHeader(
    this.content, {
    Key key,
    this.color,
    this.padding = 16.0,
    this.bold = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.0,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: padding,
            vertical: 0.0,
          ),
          child: Text(
            content,
            style: Theme.of(context).textTheme.subhead.copyWith(
                  color: color ?? Theme.of(context).accentColor,
                  fontWeight: bold ? FontWeight.bold : null,
                ),
          ),
        ),
      ),
    );
  }
}
