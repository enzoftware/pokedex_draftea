import 'package:bloc/bloc.dart';
import 'package:pokedex_draftea/pokedex/cubit/pokedex_state.dart';
import 'package:pokemon_repository/pokemon_repository.dart';

class PokedexCubit extends Cubit<PokedexState> {
  PokedexCubit({
    required PokemonRepository repository,
  }) : _repository = repository,
       super(const PokedexState());

  final PokemonRepository _repository;

  Future<void> loadPokemons() async {
    emit(state.copyWith(status: PokedexStatus.loading));
    try {
      final pokemons = await _repository.getPokemons();
      emit(state.copyWith(status: PokedexStatus.success, pokemons: pokemons));
    } on GetPokemonsFailure catch (e) {
      emit(
        state.copyWith(
          status: PokedexStatus.failure,
          pokemons: e.cachedPokemons,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: PokedexStatus.failure));
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
