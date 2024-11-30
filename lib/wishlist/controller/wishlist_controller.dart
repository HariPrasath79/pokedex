import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pokedex/home/models/pokemon.dart';
import 'package:pokedex/wishlist/repository/wishlist_firebase_repo.dart';

class WishListController extends ChangeNotifier {
  WishlistFirebaseRepo wishlistRepo;

  WishListController({required this.wishlistRepo});
  List<Pokemon> _wishlistedPokemons = [];
  bool _isLoading = true;

  List<Pokemon> get wishlistedPokemons => _wishlistedPokemons;
  bool get isLoading => _isLoading;

  Future<void> getWishlistedPokemons(FirebaseAuth auth) async {
    try {
      _wishlistedPokemons = await wishlistRepo.getWishlistedPokemons(auth);
    } catch (e) {
      Logger().e(e);
    }
    _isLoading = false;
    notifyListeners();
  }

  void removeFromWishlist(Pokemon pokemon) {
    _wishlistedPokemons.remove(pokemon);
    notifyListeners();
  }
}
