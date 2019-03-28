import 'package:flutter/material.dart';

class SubHeader extends StatelessWidget {
  final String content;
  final Color color;
  final bool bold;

  const SubHeader(
    this.content, {
    Key key,
    this.color,
    this.bold = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48.0,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          child: Text(
            content,
            style: Theme.of(context).textTheme.subhead.copyWith(
                  color: color ?? null,
                  fontWeight: bold ? FontWeight.bold : null,
                ),
          ),
        ),
      ),
    );
  }
}
