import 'package:flutter/material.dart';
import 'package:pokedex_draftea/pokedex/view/pokeball_image.dart';
import 'package:pokedex_draftea/pokedex/view/widgets/pokedex_refresh_button.dart';

class PokedexAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PokedexAppBar({
    required this.onRefresh,
    super.key,
    this.isLandscape = false,
  });

  factory PokedexAppBar.landscape({required VoidCallback onRefresh}) {
    return PokedexAppBar(
      onRefresh: onRefresh,
      isLandscape: true,
    );
  }

  final bool isLandscape;
  final VoidCallback onRefresh;

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
      actions: [
        PokedexRefreshButton(
          onRefresh: onRefresh,
          isLandscape: isLandscape,
        ),
      ],
      centerTitle: !isLandscape,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
