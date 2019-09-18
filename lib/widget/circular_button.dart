import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final Widget child;
  final Widget icon;
  final Color color;
  final bool outline;
  final VoidCallback onPressed;

  CircularButton({
    Key key,
    @required this.child,
    this.icon,
    this.color,
    this.outline = false,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);

    var backgroundColor = color ?? !outline ? themeData.accentColor : null;
    var borderColor = themeData.colorScheme.onSurface.withOpacity(0.12);
    var shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
      side: outline || onPressed == null
          ? BorderSide(color: borderColor, width: kIsWeb ? 4.0 : 1.0)
          : BorderSide.none,
    );

    if (icon != null) {
      return FlatButton.icon(
        icon: icon,
        label: child,
        shape: shape,
        color: backgroundColor,
        onPressed: onPressed,
      );
    } else {
      return FlatButton(
        child: child,
        shape: shape,
        color: backgroundColor,
        onPressed: onPressed,
      );
    }
  }
}
