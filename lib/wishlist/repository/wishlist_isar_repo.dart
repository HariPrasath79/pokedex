import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pokedex/home/models/pokemon.dart';

class WishlistIsarRepo {
  static late final Isar _isar;

  static void init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [PokemonSchema],
      directory: dir.path,
    );
  }

  static Future<void> savePokemon(Pokemon pokemon) async {
    await _isar.writeTxn(() async {
      await _isar.pokemons.put(pokemon);
    });
  }

  static Future<List<Pokemon>> getAllPokemons() async {
    final allPokemons = await _isar.pokemons.where().findAll();
    return allPokemons;
  }
}
