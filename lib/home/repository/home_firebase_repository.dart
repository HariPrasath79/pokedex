import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

import 'package:pokedex/home/models/pokemon.dart';

class HomeFirebaseRepository {
  var userId = FirebaseAuth.instance.currentUser?.uid;
  FirebaseFirestore firestore;
  HomeFirebaseRepository({required this.firestore});

  void updateUserId(String? userId) {
    this.userId = userId;
  }

  Future<void> addToWishlist(Pokemon pokemon) async {
    if (userId == null) throw Exception('User not authenticated');

    try {
      final userDoc = await firestore.collection('users').doc(userId).get();

      if (userDoc.exists) {
        firestore.collection('users').doc(userId).update({
          'wishlistedPokemonNames': FieldValue.arrayUnion([pokemon.name]),
        });
      } else {
        firestore.collection('users').doc(userId).set({
          'wishlistedPokemonNames': FieldValue.arrayUnion([pokemon.name]),
        });
      }

      final docRef = firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(pokemon.name);

      await docRef.set({
        'id': pokemon.id,
        'name': pokemon.name,
        'url': pokemon.url,
        'imageUrl': pokemon.imageUrl,
        'isWishlisted': true,
        'stats': pokemon.stats
            ?.map((e) => {
                  'baseStat': e.baseStat,
                  'stat': e.stat,
                })
            .toList(),
        'abilities': pokemon.abilities
            ?.map((e) => {
                  'ability': e.ability,
                  'slot': e.slot,
                  'isHidden': e.isHidden,
                })
            .toList(),
        'weight': pokemon.weight,
      });
    } on FirebaseException catch (e) {
      Logger().i("error ${e.message}");
      throw Exception("Error occured while adding to wishlist");
    }
  }

  Future<List> wishlistedPokemonNames() async {
    try {
      final userDoc = await firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final wishlist = userDoc.data();
        final list = wishlist!['wishlistedPokemonNames'] as List<dynamic>;
        return list;
      }
    } on FirebaseException catch (e) {
      Logger().e(e.toString());
      throw Exception("Error occured while fetching wishlisted pokemon names");
    }
    return [];
  }

  Future<void> removeFromWishlist(String pokemonName) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    try {
      final userDoc = firestore.collection('users').doc(userId);

      await userDoc.update({
        'wishlistedPokemonNames': FieldValue.arrayRemove([pokemonName]),
      });

      await firestore
          .collection('users')
          .doc(userId)
          .collection('wishlist')
          .doc(pokemonName)
          .delete();
    } on FirebaseException catch (e) {
      Logger().i("error ${e.message}");
      throw Exception("Error occured while removing from wishlist");
    }
  }
}
