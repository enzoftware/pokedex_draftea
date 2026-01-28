import 'package:flutter/widgets.dart';

class PokeballImage extends StatelessWidget {
  const PokeballImage({super.key, this.size = 50});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/pokeball.png',
      width: size,
      height: size,
    );
  }
}
