import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex_draftea/app/cubit/app_cubit.dart';

class OfflineModeBanner extends StatelessWidget {
  const OfflineModeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      buildWhen: (previous, current) => previous.isOffline != current.isOffline,
      builder: (context, state) {
        return AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: state.isOffline
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  color: Colors.red,
                  child: const Text(
                    'Offline mode - showing cached data',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}
