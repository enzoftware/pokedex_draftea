import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_ce/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pokedex_api_service/pokedex_api_service.dart';
import 'package:pokemon_storage_service/hive_registrar.g.dart';
import 'package:pokemon_storage_service/pokemon_storage_service.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(
  FutureOr<Widget> Function({
    required PokedexApiService apiService,
    required PokemonStorageService storageService,
    required Connectivity connectivity,
  })
  builder,
) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const AppBlocObserver();

  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
  Hive
    ..init(path)
    ..registerAdapters();

  final dio = Dio(BaseOptions(baseUrl: 'https://pokeapi.co/api/v2'));

  final apiService = PokedexApiService(dio: dio);
  final pokemonBox = await Hive.openBox<PokemonEntity>('pokemons');
  final storageService = PokemonHiveStorageService(pokemonBox: pokemonBox);
  final connectivity = Connectivity();

  runApp(
    await builder(
      apiService: apiService,
      storageService: storageService,
      connectivity: connectivity,
    ),
  );
}
