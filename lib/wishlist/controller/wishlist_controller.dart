import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pokedex/home/models/pokemon.dart';
import 'package:pokedex/wishlist/repository/wishlist_firebase_repo.dart';

class WishListController extends ChangeNotifier {
  List<Pokemon> _wishlistedPokemons = [];
  bool _isLoading = true;

  final wishlistService = WishlistService();

  List<Pokemon> get wishlistedPokemons => _wishlistedPokemons;
  bool get isLoading => _isLoading;

  Future<void> getWishlistedPokemons(FirebaseAuth auth) async {
    try {
      
      _wishlistedPokemons = await wishlistService.getWishlistedPokemons(auth);
    } catch (e) {
      Logger().e(e);
    }
    _isLoading = false;
    notifyListeners();
  }
}
