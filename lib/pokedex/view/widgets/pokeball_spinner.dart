import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pokedex_draftea/pokedex/view/pokeball_image.dart';

class PokeballSpinner extends StatefulWidget {
  const PokeballSpinner({super.key});

  @override
  State<PokeballSpinner> createState() => _PokeballSpinnerState();
}

class _PokeballSpinnerState extends State<PokeballSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    unawaited(_controller.repeat());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: const Center(
        child: PokeballImage(),
      ),
    );
  }
}
