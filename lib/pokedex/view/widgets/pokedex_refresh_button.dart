import 'package:flutter/material.dart';

class PokedexRefreshButton extends StatelessWidget {
  const PokedexRefreshButton({
    required this.isLandscape,
    required this.onRefresh,
    super.key,
  });

  factory PokedexRefreshButton.landscape({required VoidCallback onRefresh}) {
    return PokedexRefreshButton(
      onRefresh: onRefresh,
      isLandscape: true,
    );
  }

  final VoidCallback onRefresh;
  final bool isLandscape;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      icon: const Icon(Icons.refresh),
      label: isLandscape ? const Text('Refresh') : const SizedBox.shrink(),
      onPressed: onRefresh,
    );
  }
}
