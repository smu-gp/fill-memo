import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PlatformNetworkImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final Widget placeholder;

  PlatformNetworkImage({
    Key key,
    this.url,
    this.fit,
    this.placeholder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Image.network(
        url,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder;
        },
      );
    } else {
      return CachedNetworkImage(
        imageUrl: url,
        fit: fit,
        placeholder: (context, url) => placeholder,
        errorWidget: (context, url, error) => Icon(Icons.error),
      );
    }
  }
}
