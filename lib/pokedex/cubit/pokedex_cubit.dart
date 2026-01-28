import 'package:bloc/bloc.dart';
import 'package:pokedex_draftea/pokedex/cubit/pokedex_state.dart';
import 'package:pokemon_repository/pokemon_repository.dart';

class PokedexCubit extends Cubit<PokedexState> {
  PokedexCubit({
    required PokemonRepository repository,
  }) : _repository = repository,
       super(const PokedexState());

  final PokemonRepository _repository;
  bool _isLoading = false;

  Future<void> loadPokemons({
    int limit = 10,
  }) async {
    if (_isLoading) return;
    _isLoading = true;

    final isInitialLoad = state.pokemons.isEmpty;
    final status = isInitialLoad
        ? PokedexStatus.loading
        : PokedexStatus.loadingMore;
    emit(state.copyWith(status: status));

    try {
      final offset = state.pokemons.length;
      final newPokemons = await _repository.getPokemons(
        offset: offset,
        limit: limit,
      );

      emit(
        state.copyWith(
          status: PokedexStatus.success,
          pokemons: [...state.pokemons, ...newPokemons],
        ),
      );
    } on GetPokemonsFailure catch (e) {
      final cached = e.cachedPokemons;
      if (cached != null && cached.isNotEmpty) {
        emit(
          state.copyWith(
            status: PokedexStatus.success,
            pokemons: [...state.pokemons, ...cached],
          ),
        );
      } else {
        emit(state.copyWith(status: PokedexStatus.failure));
      }
    } on Exception catch (_) {
      emit(state.copyWith(status: PokedexStatus.failure));
    } finally {
      _isLoading = false;
    }
  }

  Future<void> clearPokemons() async {
    try {
      await _repository.clearPokemons();
      emit(state.copyWith(pokemons: []));
    } on ClearPokemonsFailure catch (_) {
      emit(state.copyWith(status: PokedexStatus.failure));
    }
  }
}
