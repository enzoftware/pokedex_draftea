part of 'app_cubit.dart';

class AppState {
  const AppState({this.isOffline = false});

  final bool isOffline;

  AppState copyWith({bool? isOffline}) {
    return AppState(isOffline: isOffline ?? this.isOffline);
  }
}
