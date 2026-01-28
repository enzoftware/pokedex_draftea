import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_draftea/pokedex/view/widgets/pokeball_spinner.dart';

class PokemonCacheImage extends StatelessWidget {
  const PokemonCacheImage({
    required this.imageUrl,
    this.size,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
    super.key,
  });

  final String imageUrl;
  final double? size;
  final double? height;
  final double? width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final imageHeight = size ?? height;
    final imageWidth = size ?? width;

    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: imageHeight,
      width: imageWidth,
      fit: fit,
      placeholder: (context, url) => SizedBox(
        height: imageHeight,
        width: imageWidth,
        child: const Center(child: PokeballSpinner()),
      ),
      errorWidget: (context, url, error) => SizedBox(
        height: imageHeight,
        width: imageWidth,
        child: const Center(
          child: Icon(
            Icons.error,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
