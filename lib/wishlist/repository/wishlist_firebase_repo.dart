import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pokedex/home/models/pokemon.dart';

class WishlistFirebaseRepo {
  final firestore = FirebaseFirestore.instance;
  Future<void> uploadPokemonToFirestore(Pokemon pokemon) async {
    final pokemonData = {
      'name': pokemon.name,
      'url': pokemon.url,
      'imageUrl': pokemon.imageUrl,
      'isWishlisted': pokemon.isWishlisted,
      'weight': pokemon.weight,
      'stats': pokemon.stats
          ?.map((stat) => {
                'baseStat': stat.baseStat,
                'stat': stat.stat,
              })
          .toList(),
      'abilities': pokemon.abilities
          ?.map((ability) => {
                'ability': ability.ability,
                'slot': ability.slot,
                'isHidden': ability.isHidden,
              })
          .toList(),
    };

    await firestore.collection('pokemon').doc(pokemon.name).set(pokemonData);
  }
}
