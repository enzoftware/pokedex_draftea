import 'package:go_router/go_router.dart';
import 'package:pokedex_draftea/pokedex/view/pokedex_page.dart';
import 'package:pokedex_draftea/pokemon_detail/view/pokemon_detail_page.dart';

class PokedexRouter {
  static final router = GoRouter(
    initialLocation: PokedexPage.route,
    routes: [
      GoRoute(
        path: PokedexPage.route,
        builder: (context, state) => const PokedexPage(),
        routes: [
          GoRoute(
            path: 'pokemon/:id',
            builder: (context, state) {
              final pokemonId = state.pathParameters['id']!;
              return PokemonDetailPage(pokemonId: pokemonId);
            },
          ),
        ],
      ),
    ],
  );
}
