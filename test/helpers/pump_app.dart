import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_draftea/app/cubit/app_cubit.dart';
import 'package:pokedex_draftea/l10n/l10n.dart';
import 'package:pokemon_repository/pokemon_repository.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget) {
    return pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: widget,
      ),
    );
  }

  /// Pumps the widget with all necessary dependencies for the Pokedex app.
  ///
  /// Provides [PokemonRepository] and [AppCubit] which are commonly needed
  /// for widget tests across the app.
  Future<void> pumpPokedexApp(
    Widget widget, {
    required PokemonRepository repository,
    required AppCubit appCubit,
  }) {
    return pumpWidget(
      RepositoryProvider.value(
        value: repository,
        child: BlocProvider.value(
          value: appCubit,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: widget,
          ),
        ),
      ),
    );
  }
}
