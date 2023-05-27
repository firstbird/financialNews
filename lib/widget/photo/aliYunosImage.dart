import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AliYunosImage extends StatelessWidget {
  final String imageUrl;
  final Widget placeholder;
  final Widget errorWidget;

  const AliYunosImage({
    Key? key,
    required this.imageUrl,
    this.placeholder = const CircularProgressIndicator(),
    this.errorWidget = const Icon(Icons.error),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => placeholder,
      errorWidget: (context, url, error) => errorWidget,
      imageBuilder: (context, imageProvider) => Image(image: imageProvider),
      // cacheManager: CustomCacheManager(aliyunOSS),
    );
  }
}
