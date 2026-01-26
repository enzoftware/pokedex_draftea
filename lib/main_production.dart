import 'package:pokedex_draftea/app/app.dart';
import 'package:pokedex_draftea/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
