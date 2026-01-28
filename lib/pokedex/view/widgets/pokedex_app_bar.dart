import 'package:flutter/material.dart';
import 'package:pokedex_draftea/pokedex/view/pokeball_image.dart';

class PokedexAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PokedexAppBar({
    super.key,
    this.isLandscape = false,
  });

  factory PokedexAppBar.landscape() {
    return const PokedexAppBar(isLandscape: true);
  }

  final bool isLandscape;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: isLandscape
          ? const Row(
              children: [
                PokeballImage(),
                SizedBox(width: 8),
                Text('Pokedex'),
              ],
            )
          : const PokeballImage(),
      centerTitle: !isLandscape,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
