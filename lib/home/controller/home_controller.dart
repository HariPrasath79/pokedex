import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:pokedex/home/models/pokemon.dart';
import 'package:pokedex/home/repository/home_repository.dart';
import 'package:pokedex/wishlist/repository/wishlist_firebase_repo.dart';

class HomeController extends ChangeNotifier {
  // final PokemonService _pokemonService = PokemonService();

  HomeRepository _homeRepository = HomeRepository();
  List<Pokemon> _pokemons = [];
  bool _isLoading = true;
  bool _isPokemonFetching = false;
  int _currentPokemonPagationIndex = 11;
  bool _isLastPokemon = false;

  List _wishlistedPokemons = [];

  final wishlistService = WishlistService();

  final searchController = TextEditingController();

  List<Color> lightColors = const [
    Color.fromRGBO(190, 220, 220, 1),
    Color.fromRGBO(196, 227, 212, 1),
    Color.fromRGBO(241, 206, 176, 1),
    Color.fromRGBO(235, 188, 180, 1),
    Color.fromRGBO(239, 211, 187, 1),
  ];

  List<Pokemon> get pokemons => _pokemons;
  bool get isLoading => _isLoading;

  List get wishlistedPokemons => _wishlistedPokemons;

  bool get isPokemonFetching => _isPokemonFetching;
  int get currentPokemonPagationIndex => _currentPokemonPagationIndex;
  bool get isLaastPokemon => _isLastPokemon;

  Future<Pokemon> getPokemonDetails(Pokemon pokemon) async {
    final pokemonData = await _homeRepository.fetchPokemonImage(pokemon.url);

    pokemon.imageUrl = pokemonData['sprites']['other']['home']['front_default'];
    final stats = pokemonData['stats'] as List;
    List<Stats> pokeStats = [];
    for (var stat in stats) {
      final data = Stats.fromJson(stat);
      pokeStats.add(data);
    }
    pokemon.stats = pokeStats;

    final abilityData = pokemonData['abilities'] as List;

    List<Ability> pokeAbilities = [];
    for (var ability in abilityData) {
      final data = Ability.fromJson(ability);
      pokeAbilities.add(data);
    }
    pokemon.abilities = pokeAbilities;

    pokemon.weight = pokemonData["weight"];

    pokemon.id = pokemonData["id"];

    return pokemon;
  }

  Future<void> loadPokemons() async {
    try {
      _wishlistedPokemons = await wishlistService.wishlistedPokemonNames();
      final pokemons = await _homeRepository.fetchPokemons(0, 10);
      for (var pokemon in pokemons) {
        if (_wishlistedPokemons.contains(pokemon.name)) {
          pokemon.isWishlisted = true;
        }
        final pokedex = await getPokemonDetails(pokemon);
        _pokemons.add(pokedex);
      }

      _isLoading = false;
    } catch (e) {
      print(e);
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> fetchPokemonsPagation() async {
    if (_isLastPokemon) {
      return;
    }
    _isPokemonFetching = true;
    notifyListeners();
    try {
      final pokemons = await _homeRepository.fetchPokemons(
          _currentPokemonPagationIndex, _currentPokemonPagationIndex + 10);
      for (var pokemon in pokemons) {
        final pokedex = await getPokemonDetails(pokemon);
        _pokemons.add(pokedex);
      }

      _isPokemonFetching = false;
    } catch (e) {
      print(e);
      Logger().i(e);
      _isLastPokemon = true;
      _isPokemonFetching = false;
    }
    notifyListeners();
  }

  void wishlistPokemon(index) async {
    try {
      await wishlistService.addToWishlist(_pokemons[index]);
      _pokemons[index].isWishlisted = !_pokemons[index].isWishlisted;
    } catch (e) {
      Logger().e(e);
    }

    notifyListeners();
  }

  int randomIndex() {
    Random random = Random();
    int randomNumber = random.nextInt(5);
    return randomNumber;
  }

  String getIndexofPokemon(int index) {
    if (index < 10) {
      return "00$index";
    } else if (index >= 10 && index <= 99) {
      return "0$index";
    } else {
      return "$index";
    }
  }
}
