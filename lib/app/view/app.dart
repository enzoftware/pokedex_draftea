import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_api_service/pokedex_api_service.dart';
import 'package:pokedex_draftea/app/cubit/app_cubit.dart';
import 'package:pokedex_draftea/l10n/l10n.dart';
import 'package:pokedex_draftea/pokedex/pokedex.dart';
import 'package:pokemon_repository/pokemon_repository.dart';
import 'package:pokemon_storage_service/pokemon_storage_service.dart';

class PokedexApp extends StatelessWidget {
  const PokedexApp({
    required this.apiService,
    required this.storageService,
    required this.connectivity,
    super.key,
  });

  final PokedexApiService apiService;
  final PokemonStorageService storageService;
  final Connectivity connectivity;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => PokemonRepository(
            apiService: apiService,
            storageService: storageService,
            connectivity: connectivity,
          ),
        ),
      ],
      child: BlocProvider(
        create: (context) => AppCubit(connectivity: connectivity),
        child: MaterialApp(
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            useMaterial3: true,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const PokedexPage(),
        ),
      ),
    );
  }
}
