import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import 'package:pokedex/home/models/pokemon.dart';

class WishlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  Future<void> addToWishlist(Pokemon pokemon) async {
    if (userId == null) throw Exception('User not authenticated');

    final userDoc = await _firestore.collection('users').doc(userId).get();

    if (userDoc.exists) {
      _firestore.collection('users').doc(userId).update({
        'wishlistedPokemonNames': FieldValue.arrayUnion([pokemon.name]),
      });
    } else {
      _firestore.collection('users').doc(userId).set({
        'wishlistedPokemonNames': FieldValue.arrayUnion([pokemon.name]),
      });
    }

    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(pokemon.name);

    await docRef.set({
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
  }

  Future<List> wishlistedPokemonNames() async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final wishlist = userDoc.data();
        final list = wishlist!['wishlistedPokemonNames'] as List<dynamic>;
        return list;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return [];
  }

  Future<void> removeFromWishlist(Pokemon pokemon) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    final userDoc = _firestore.collection('users').doc(userId);

    await userDoc.update({
      'wishlistedPokemonNames': FieldValue.arrayRemove([pokemon.name]),
    });

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .doc(pokemon.id.toString())
        .delete();
  }

  Future<List<Pokemon>> getWishlistedPokemons(FirebaseAuth auth) async {
    final userId = auth.currentUser?.uid;
    Logger().i(userId);
    if (userId == null) throw Exception('User not authenticated');

    final querySnapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('wishlist')
        .where('isWishlisted', isEqualTo: true)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return Pokemon(
        id: data['id'] ?? -1,
        name: data['name'],
        url: data['url'],
        imageUrl: data['imageUrl'],
        isWishlisted: data['isWishlisted'],
        stats: (data['stats'] as List<dynamic>?)
            ?.map((e) => Stats(baseStat: e['baseStat'], stat: e['stat']))
            .toList(),
        abilities: (data['abilities'] as List<dynamic>?)
            ?.map((e) => Ability(
                  ability: e['ability'],
                  slot: e['slot'],
                  isHidden: e['isHidden'],
                ))
            .toList(),
        weight: data['weight'],
      );
    }).toList();
  }
}
