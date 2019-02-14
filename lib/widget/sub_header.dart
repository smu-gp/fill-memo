import 'package:flutter/material.dart';

class SubHeader extends StatelessWidget {
  final String content;

  const SubHeader(
    this.content, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          content,
          style: Theme.of(context).textTheme.subtitle,
        ),
      ),
    );
  }
}
