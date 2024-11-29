import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/auth/controller/auth_controller.dart';
import 'package:pokedex/core/loading_indicator_common.dart';
import 'package:pokedex/core/utils.dart';
import 'package:pokedex/home/controller/home_controller.dart';
import 'package:pokedex/home/ui/components/action_button.dart';
import 'package:pokedex/home/ui/components/custom_textfield.dart';
import 'package:pokedex/home/ui/components/pokemon_card.dart';
import 'package:pokedex/pokemon_details/pokemon_details_screen.dart';
import 'package:pokedex/wishlist/ui/wishlist.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    // Provider.of<HomeController>(context).loadPokemons();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<HomeController>(context, listen: false).loadPokemons();
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final controller = Provider.of<HomeController>(context, listen: false);
      if (controller.isPokemonFetching) {
        return;
      }
      controller.fetchPokemonsPagation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to log out?"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Provider.of<AuthController>(context, listen: false)
                                .signOut();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              "Yes",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            child: const Text("No"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(CupertinoIcons.arrow_left_circle)),
            Consumer<HomeController>(
              builder: (context, controller, child) {
                return ActionButton(
                  cartCount: controller.wishlistedPokemons.length.toString(),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const WishlistScreen()));
                  },
                );
              },
            ),
          ],
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pokédex',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
              ),
              Text(
                "Search for pokemon",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Consumer<HomeController>(builder: (context, controller, child) {
                  return Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: controller.searchController,
                          prefixIcon: Icons.search,
                          hintText: 'Name or Number',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(93, 94, 125, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          CupertinoIcons.line_horizontal_3,
                          color: Colors.white,
                        ),
                      )
                    ],
                  );
                }),
                const SizedBox(height: 10),
                Consumer<HomeController>(builder: (context, homeController, _) {
                  if (homeController.isLoading) {
                    return const Expanded(
                      child: Center(
                          child: SizedBox(
                        height: 200,
                        width: 200,
                        child: loadingIndicator,
                      )),
                    );
                  }
                  if (!homeController.isLoading &&
                      homeController.pokemons.isEmpty) {
                    return const Expanded(
                        child: Center(child: Text('No Pokémon found')));
                  }
                  return Expanded(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Expanded(
                        child: GridView.builder(
                          controller: _scrollController,
                          cacheExtent: 2000,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 13,
                            mainAxisSpacing: 13,
                            mainAxisExtent: height * 0.3,
                          ),
                          itemCount: homeController.pokemons.length,
                          itemBuilder: (context, index) {
                            final pokemon = homeController.pokemons[index];
                            return PokemonCard(
                              wishlistIconOnTap: () {
                                homeController.wishlistPokemon(index);
                              },
                              isWishlisted: pokemon.isWishlisted,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PokemonDetails(
                                      pokemon: pokemon,
                                      index: homeController
                                          .getIndexofPokemon(pokemon.id!),
                                      backgroundColor:
                                          lightColors[randomIndex()],
                                    ),
                                  ),
                                );
                              },
                              index:
                                  homeController.getIndexofPokemon(index + 1),
                              imageUrl: pokemon.imageUrl!,
                              name: pokemon.name,
                              backgroundColor: homeController
                                  .lightColors[homeController.randomIndex()],
                            );
                          },
                        ),
                      ),
                      homeController.isPokemonFetching
                          ? fetchingLoadingIndicator
                          : const SizedBox(),
                    ]),
                  );
                }),
              ],
            ),
          ),
        ));
  }
}
