import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:product_browser_app/core/theming/colors.dart';

class ProductHeroImage extends StatelessWidget {
  const ProductHeroImage({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      background: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (_, _) => Container(
          color: ColorsManager.moreLighterGray,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (_, _, _) => Container(
          color: ColorsManager.moreLighterGray,
          child: const Icon(Icons.broken_image, size: 48),
        ),
      ),
    );
  }
}
