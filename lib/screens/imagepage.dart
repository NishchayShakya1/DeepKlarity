import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:velocity_x/velocity_x.dart';

class CatalogImage extends StatelessWidget {
  final String image;

  const CatalogImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      placeholder: (context,url) => const CircularProgressIndicator(),

      // errorWidget: (context, url, error) =>
      // Image(image : AssetImage("assets/images/rolling.gif")),
      // Image.asset(
      //   "assets/images/rolling.gif",
      //   height: 100.0,
      //   width: 50.0,
      // ),
      // Image.asset(circularProgressIndicator, scale: 4),
      height: 100,
      width: 50,
      fit: BoxFit.cover,
    ).box.rounded.p8.color(context.canvasColor).make().p16().w40(context);
  }
}
