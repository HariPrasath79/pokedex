import 'package:flutter/material.dart';
import 'package:pokedex/auth/controller/auth_controller.dart';
import 'package:pokedex/core/loading_indicator_common.dart';
import 'package:pokedex/core/utils.dart';
import 'package:pokedex/home/controller/home_controller.dart';
import 'package:pokedex/home/ui/components/pokemon_card.dart';
import 'package:pokedex/wishlist/controller/wishlist_controller.dart';
import 'package:provider/provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final auth = Provider.of<AuthController>(context, listen: false).auth;
      Provider.of<WishListController>(context, listen: false)
          .getWishlistedPokemons(auth);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wishlist"),
        surfaceTintColor: Colors.transparent,
      ),
      body: Consumer<WishListController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(
                child:
                    SizedBox(height: 100, width: 100, child: loadingIndicator));
          }

          if (controller.wishlistedPokemons.isEmpty) {
            return const Center(child: Text("No Pokemons Wishlisted"));
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 280,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: controller.wishlistedPokemons.length,
                itemBuilder: (context, index) {
                  final pokemon = controller.wishlistedPokemons[index];
                  return PokemonCard(
                    isHeroDisabled: true,
                    index: getIndexofPokemon(pokemon.id!),
                    imageUrl: pokemon.imageUrl!,
                    name: pokemon.name,
                    isWishlisted: pokemon.isWishlisted,
                    wishlistIconOnTap: () async {
                      try {
                        await Provider.of<HomeController>(context,
                                listen: false)
                            .wishlistPokemonFromWishlistScreen(
                                pokemon, context);
                        controller.removeFromWishlist(pokemon);
                      } catch (e) {
                        getSnackBar(context,
                            hint: "Failed to remove from Wishlist");
                      }
                    },
                    backgroundColor: lightColors[randomIndex()],
                  );
                }),
          );
        },
      ),
    );
  }
}
