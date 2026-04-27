import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (_, _, _) => Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: const Icon(Icons.broken_image, size: 48),
        ),
      ),
    );
  }
}
