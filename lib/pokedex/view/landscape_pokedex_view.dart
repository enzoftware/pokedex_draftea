import 'package:flutter/material.dart';
import 'package:pokedex_draftea/pokedex/view/pokedex_page.dart';
import 'package:pokedex_draftea/pokedex/view/widgets/pokedex_app_bar.dart';

class LandscapePokedexView extends StatelessWidget {
  const LandscapePokedexView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PokedexAppBar.landscape(),
      body: const SafeArea(child: PokedexBody()),
    );
  }
}
