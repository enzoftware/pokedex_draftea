import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit({
    required Connectivity connectivity,
  }) : _connectivity = connectivity,
       super(const AppState()) {
    _connectivity.onConnectivityChanged.listen((event) {
      setOfflineMode(isOffline: event.contains(ConnectivityResult.none));
    });
  }

  final Connectivity _connectivity;

  void setOfflineMode({required bool isOffline}) {
    emit(state.copyWith(isOffline: isOffline));
  }
}
