import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final bool outline;
  final VoidCallback onPressed;

  CircularButton({
    Key key,
    @required this.child,
    this.color,
    this.outline = false,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);

    return FlatButton(
      child: child,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: outline
            ? BorderSide(
                color: themeData.colorScheme.onSurface.withOpacity(0.12),
              )
            : BorderSide.none,
      ),
      color: color ?? !outline ? themeData.accentColor : null,
      onPressed: onPressed,
    );
  }
}
