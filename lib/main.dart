import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:pokedex_api_service/pokedex_api_service.dart';
import 'package:pokedex_draftea/app/app.dart';
import 'package:pokedex_draftea/bootstrap.dart';
import 'package:pokemon_storage_service/pokemon_storage_service.dart';

Future<void> main() async {
  await bootstrap(
    ({
      required PokedexApiService apiService,
      required PokemonStorageService storageService,
      required Connectivity connectivity,
    }) => PokedexApp(
      apiService: apiService,
      storageService: storageService,
      connectivity: connectivity,
    ),
  );
}
