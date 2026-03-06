import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/core/utils/constants/assets_data.dart';

class CachedNetworkImg extends StatelessWidget {
  const CachedNetworkImg({
    super.key,
    required this.width,
    required this.height,
    required this.img,
    required this.placeHolder,
  });

  final double width, height;
  final String img, placeHolder;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width,
      height: height,
      imageUrl: img,
      fit: BoxFit.fill,
      placeholder: (context, url) => Image.asset(placeHolder, fit: BoxFit.fill),
      errorWidget: (context, url, error) {
        return Image.asset(
          AssetsData.placeHolderImg,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        );
      },
    );
  }
}
