import 'package:fill_memo/util/dimensions.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget leading;
  final Widget trailing;
  final VoidCallback onTap;
  final bool enabled;
  final bool threeLine;

  const ListItem({
    Key key,
    @required this.title,
    this.leading,
    this.trailing,
    this.subtitle,
    this.onTap,
    this.enabled = true,
    this.threeLine = false,
  });

  @override
  Widget build(BuildContext context) {
    bool twoLine = subtitle != null;
    ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        height: twoLine ? threeLine ? 88.0 : 64.0 : 48.0,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: <Widget>[
            if (leading != null) leading,
            if (leading != null) SizedBox(width: 32.0),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: theme.textTheme.subhead.copyWith(
                        fontSize: 16.0,
                        color: !enabled ? theme.disabledColor : null),
                  ),
                  if (twoLine)
                    Text(
                      subtitle,
                      style: theme.textTheme.caption.copyWith(
                        fontSize: 14.0,
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) SizedBox(width: 16.0),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }
}

class SwitchListItem extends StatefulWidget {
  final String title;
  final String subtitle;
  final Widget leading;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  const SwitchListItem({
    Key key,
    @required this.title,
    this.subtitle,
    this.leading,
    @required this.value,
    @required this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  _SwitchListItemState createState() => _SwitchListItemState();
}

class _SwitchListItemState extends State<SwitchListItem> {
  bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return ListItem(
      title: widget.title,
      subtitle: widget.subtitle,
      leading: widget.leading,
      enabled: widget.enabled,
      onTap: () => _handleOnChange(!_value),
      trailing: Switch(
        value: _value,
        onChanged: widget.enabled ? _handleOnChange : null,
      ),
    );
  }

  void _handleOnChange(bool value) {
    setState(() {
      _value = value;
    });
    widget.onChanged(_value);
  }
}

class SelectableListItem extends StatefulWidget {
  final String title;
  final Widget icon;
  final bool selectable;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final ValueChanged<bool> onCheckboxChanged;
  final Widget tralling;

  SelectableListItem({
    Key key,
    @required this.title,
    this.icon,
    this.selectable = false,
    this.selected = false,
    @required this.onTap,
    @required this.onLongPress,
    @required this.onCheckboxChanged,
    this.tralling,
  }) : super(key: key);

  @override
  _SelectableListItemState createState() => _SelectableListItemState();
}

class _SelectableListItemState extends State<SelectableListItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Padding(
        padding: EdgeInsets.only(
          left: widget.selectable ? Dimensions.keylineMini : Dimensions.keyline,
          right: Dimensions.keyline,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: Dimensions.listOneLineHeight,
          ),
          child: Row(
            children: <Widget>[
              if (widget.selectable)
                Checkbox(
                  value: widget.selected,
                  onChanged: widget.onCheckboxChanged,
                ),
              if (!widget.selectable && widget.icon != null) widget.icon,
              SizedBox(width: widget.selectable ? 20.0 : 32.0),
              Expanded(
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.subhead.copyWith(
                        fontSize: 16.0,
                      ),
                ),
              ),
              if (widget.tralling != null) widget.tralling,
            ],
          ),
        ),
      ),
    );
  }
}
