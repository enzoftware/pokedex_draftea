import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_draftea/pokemon_detail/cubit/pokemon_detail_state.dart';
import 'package:pokemon_repository/pokemon_repository.dart';

class PokedexDetailCubit extends Cubit<PokemonDetailState> {
  PokedexDetailCubit({
    required PokemonRepository pokemonRepository,
  }) : _pokemonRepository = pokemonRepository,
       super(const PokemonDetailState());

  final PokemonRepository _pokemonRepository;

  Future<void> getPokemonDetail({required String id}) async {
    try {
      emit(state.copyWith(status: PokemonDetailStatus.loading));
      final pokemon = await _pokemonRepository.getPokemonDetail(id: id);
      emit(
        state.copyWith(status: PokemonDetailStatus.success, pokemon: pokemon),
      );
    } on Exception catch (e) {
      emit(state.copyWith(status: PokemonDetailStatus.failure, error: e));
    }
  }
}
