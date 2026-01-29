# Pokedex Draftea

Flutter application that consumes the [PokeAPI](https://pokeapi.co/) to display Pokemon information. Supports offline mode through local storage with a No-SQL database (Hive).

## Features

- Pokemon list with infinite scroll
- Pokemon detail view (types, stats, sprites)
- Support for landscape and portrait modes
- Local storage for offline functionality
- Clean architecture with BLoC pattern
- Web support
- Unit tests

## Project Structure

```
lib/
├── app/                    # App configuration and router
├── pokedex/                # Feature: Pokemon list
├── pokemon_detail/         # Feature: Pokemon detail
├── bootstrap.dart          # Dependency initialization
└── main.dart               # Entry point

packages/
├── pokedex_api_service/    # HTTP client for PokeAPI
├── pokedex_models/         # Data models (Pokemon, Types, Sprites)
├── pokemon_repository/     # Repository with business logic and cache
└── pokemon_storage_service/# Local storage with Hive
```

## Running the Project

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test
```

## Required Questions

**What architecture/pattern did you use and why is it suitable for scaling to a real product (including Web)?**

I used a layered separation pattern to keep data sources separated, whether remote or local, and unified them using the repository pattern which allows managing data sources in a centralized way. I handled the different modules as separate Dart packages since it facilitates code reuse and improves software scalability. If for some reason the mobile project needs to be separated from the web, the business logic and data layer could be reused.

---

**What trade-offs did you make due to the 1-day timebox?**

Personally, I like to apply clean architecture in my projects as it allows managing information layers in an orderly manner, but it also requires more implementation time. Creating use case classes adds value when the logic is more complex and can be reused in multiple places. Creating abstractions for connectivity detection (connectivity_plus) was another trade-off I had to accept; usually creating abstractions is more efficient when looking to switch packages that implement certain behavior.

---

**Describe your "UI → state → data" flow and how you avoid coupling between layers.**

I used the BLoC pattern to manage the application state, which allows maintaining state in a centralized way and avoiding coupling between layers. The flow is as follows: UI calls BLoC, BLoC calls the repository, repository detects if there is an internet connection and decides whether to invoke the API or the database. I use DI to avoid coupling between layers, making the code easier to test.

---

**Explain your persistence strategy: what do you store, how do you version/invalidate, how do you resolve conflicts between "cached data" and "remote data"?**

I used a NoSQL database (Hive) to persist Pokemon information. The strategy consists of storing information iteratively so that users can access Pokemon details without needing to be connected to the internet, even when they haven't seen the detail previously. The way to avoid conflicts between cached and remote data is through implementing a versioning mechanism that allows identifying if the cached data is more recent than the remote data (not implemented). In this case, data is handled so that when remote data is received, the database is updated and cached data is invalidated.

---

**What decisions did you make to ensure a good Web experience (responsive, navigation, performance, desktop-type interaction)? What limitations did you have/anticipate and how would you mitigate them?**

I implemented a specific view for landscape (web) and portrait (mobile). This way, interactions would be simpler; likewise, I created widgets with factory constructors for landscape versions. Navigation is designed to work the same way on both platforms using URL paths, which are easily extendable for deep links. Limitations will be associated with how much you want to bring elements closer to a traditional web experience, for example optimizing the web's SEO or integrating some libraries that only have support for web ecosystems will start to create bottlenecks.

---

**Mention 3 "clean code" decisions applied (with specific example from the repo).**

I use dependency injection which allows keeping the code easily testable and scalable. 


```dart

// packages/pokemon_repository/lib/src/pokemon_repository.dart

class PokemonRepository {
  const PokemonRepository({
    required PokedexApiService apiService,
    required PokemonStorageService storageService,
    required Connectivity connectivity,
  }) : _apiService = apiService,
       _storageService = storageService,
       _connectivity = connectivity;

  final PokemonStorageService _storageService;
  final PokedexApiService _apiService;
  final Connectivity _connectivity;

```


I implement separate widgets for view elements, which helps have reusable components and also keeps the widget tree easy to read. 

```dart
class LandscapePokedexView extends StatelessWidget {
  const LandscapePokedexView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PokedexAppBar.landscape(
        onRefresh: () {
          unawaited(context.read<PokedexCubit>().refreshPokemons());
        },
      ),
      body: const SafeArea(
        child: Column(
          children: [
            OfflineModeBanner(),
            Expanded(child: _LandscapePokedexBody()),
          ],
        ),
      ),
    );
  }
}

class _LandscapePokedexBody extends StatelessWidget {

class _LoadMoreCard extends StatelessWidget {

```

Creating custom exceptions to handle errors in a controlled manner in the repository layer.
```dart
// packages/pokemon_repository/lib/src/exceptions/get_pokemons_failure.dart
import 'package:pokedex_models/pokedex_models.dart';

class GetPokemonsFailure implements Exception {
  const GetPokemonsFailure(
    this.error,
    this.stackTrace, [
    this.cachedPokemons,
  ]);

  final Object error;
  final StackTrace stackTrace;
  final List<Pokemon>? cachedPokemons;
}

```


---


**What did you test and why? If you didn't have time, what tests would you add first (priority) and what would they ensure?**

I mainly tested the data layers to validate that data obtained from the API and database is retrieved and parsed correctly. Then I made sure the repository layer works correctly in case of errors either from the API side or the local database. Finally, I implemented tests for state managers (cubits) which allows validating that scenarios are displayed to users correctly. Similarly, at the UI level, app loading validations were implemented.

---


**How did you structure your commits (granularity, messages, convention) to facilitate review and maintenance?**

I used the conventional commits format, which allows easily identifying commit types and their meaning. Usually in larger-scale projects I use squash-merge to maintain a cleaner history.

---

**What did you leave out? Prioritized list (top 3-5) with how you would implement it.**

1. **Integration tests**: I would use Patrol to run integration tests that validate the complete functionality of the application. This way we can ensure that flows don't break over time.

2. **Design system development**: Implement custom themes that implement the application components, this way visual consistency can be maintained throughout the application. Components can also be reused in the web project if separated.

3. **Abstract class for connectivity**: Create a `ConnectivityService` class that abstracts the behavior of `connectivity_plus`. This way the package can be changed without affecting the rest of the application.
