// Ignore for testing purposes

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pokedex_api_service/pokedex_api_service.dart';
import 'package:pokedex_draftea/app/app.dart';
import 'package:pokedex_draftea/pokedex/pokedex.dart';
import 'package:pokemon_storage_service/pokemon_storage_service.dart';

class MockPokedexApiService extends Mock implements PokedexApiService {}

class MockPokemonStorageService extends Mock implements PokemonStorageService {}

class MockConnectivity extends Mock implements Connectivity {}

void main() {
  group('App', () {
    late PokedexApiService apiService;
    late PokemonStorageService storageService;
    late Connectivity connectivity;

    setUp(() {
      apiService = MockPokedexApiService();
      storageService = MockPokemonStorageService();
      connectivity = MockConnectivity();
    });

    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(
        PokedexApp(
          apiService: apiService,
          storageService: storageService,
          connectivity: connectivity,
        ),
      );
      expect(find.byType(PokedexPage), findsOneWidget);
    });
  });
}
