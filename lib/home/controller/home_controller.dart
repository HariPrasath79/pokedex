import 'dart:math';

import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:pokedex/core/utils.dart';
import 'package:pokedex/home/models/pokemon.dart';
import 'package:pokedex/home/repository/home_firebase_repository.dart';
import 'package:pokedex/home/repository/home_repository.dart';

class HomeController extends ChangeNotifier {
  // final PokemonService _pokemonService = PokemonService();

  final HomeFirebaseRepository homeFirebaseRepository;

  final HomeRepository homeRepository;

  HomeController(
      {required this.homeFirebaseRepository, required this.homeRepository});

  List<Pokemon> _pokemons = [];
  List<Pokemon> _pokemonsCache = [];
  bool _isLoading = true;
  bool _isPokemonFetching = false;
  int _currentPokemonPagationIndex = 11;
  bool _isLastPokemon = false;

  bool _isFilterOn = false;

  String? errorMessage;

  List _wishlistedPokemons = [];

  final searchController = TextEditingController();

  List<Pokemon> get pokemons => _pokemons;
  bool get isLoading => _isLoading;
  bool get isFilterOn => _isFilterOn;
  List get wishlistedPokemons => _wishlistedPokemons;
  List<Pokemon> get pokemonsCache => _pokemonsCache;
  bool get isPokemonFetching => _isPokemonFetching;
  int get currentPokemonPagationIndex => _currentPokemonPagationIndex;
  bool get isLaastPokemon => _isLastPokemon;

  Future<Pokemon> getPokemonDetails(Pokemon pokemon) async {
    final pokemonData = await homeRepository.fetchPokemonImage(pokemon.url);

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

  void searchControllerOnChanged() {
    if (searchController.text.isEmpty) {
      _isFilterOn = false;
      _pokemons = _pokemonsCache;
      notifyListeners();
      return;
    }
    _isFilterOn = true;
    _pokemons = _pokemonsCache
        .where((pokedex) => pokedex.name.contains(searchController.text))
        .toList();
    notifyListeners();
  }

  void clearFilterOn() {
    _isFilterOn = false;
    searchController.clear();
    _pokemons = List.from(_pokemonsCache);

    notifyListeners();
  }

  Future<void> loadPokemons() async {
    try {
      _wishlistedPokemons =
          await homeFirebaseRepository.wishlistedPokemonNames();
      final pokemons = await homeRepository.fetchPokemons(0, 10);
      for (var pokemon in pokemons) {
        if (_wishlistedPokemons.contains(pokemon.name)) {
          pokemon.isWishlisted = true;
        }
        final pokedex = await getPokemonDetails(pokemon);
        _pokemons.add(pokedex);
        _pokemonsCache.add(pokedex);
      }

      _isLoading = false;
    } catch (e) {
      print(e);
      errorMessage = "Failed to load";
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> fetchPokemonsPagation(BuildContext context) async {
    if (_isLastPokemon) {
      return;
    }
    _isPokemonFetching = true;
    notifyListeners();
    try {
      final pokemons = await homeRepository.fetchPokemons(
          _currentPokemonPagationIndex, _currentPokemonPagationIndex + 10);

      for (var pokemon in pokemons) {
        // Check if the Pokémon is already in the cache
        if (_pokemonsCache
            .any((cachedPokemon) => cachedPokemon.name == pokemon.name)) {
          continue;
        }

        final pokedex = await getPokemonDetails(pokemon);
        _pokemons.add(pokedex);
        _pokemonsCache.add(pokedex);
      }

      // Increment the pagination index
      _currentPokemonPagationIndex += 10;

      _isPokemonFetching = false;
    } catch (e) {
      getSnackBar(context, hint: "Failed to fetch pokemons");
      Logger().i(e);

      _isPokemonFetching = false;
    }
    notifyListeners();
  }

  Future<void> wishlistPokemon(int index, BuildContext context) async {
    try {
      if (_pokemons[index].isWishlisted) {
        await homeFirebaseRepository.removeFromWishlist(_pokemons[index].name);
        _wishlistedPokemons.remove(_pokemons[index].name);
      } else {
        await homeFirebaseRepository.addToWishlist(_pokemons[index]);
        _wishlistedPokemons.add(_pokemons[index].name);
      }

      _pokemons[index].isWishlisted = !_pokemons[index].isWishlisted;
    } catch (e) {
      getSnackBar(context, hint: "Failed to fetch pokemons");
      Logger().e(e);
    }

    notifyListeners();
  }

  Future<void> wishlistPokemonFromWishlistScreen(
      Pokemon pokemon, BuildContext context) async {
    try {
      await homeFirebaseRepository.removeFromWishlist(pokemon.name);
      _wishlistedPokemons.remove(pokemon.name);

      final index = _pokemons.indexWhere((pokedex) => pokedex.id == pokemon.id);
      final cacheIndex =
          _pokemonsCache.indexWhere((pokedex) => pokedex.id == pokemon.id);
      if (index != -1) {
        _pokemons[index].isWishlisted = false;
      }
      if (cacheIndex != -1) {
        _pokemonsCache[cacheIndex].isWishlisted = false;
      }
    } catch (e) {
      getSnackBar(context, hint: "Failed to fetch pokemons");
      Logger().e(e);
    }

    notifyListeners();
  }

  int randomIndex() {
    Random random = Random();
    int randomNumber = random.nextInt(5);
    return randomNumber;
  }
}
