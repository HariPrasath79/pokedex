import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'package:pokedex/auth/controller/auth_controller.dart';
import 'package:pokedex/auth/ui/auth_screen.dart';
import 'package:pokedex/core/loading_indicator_common.dart';
import 'package:pokedex/core/utils.dart';
import 'package:pokedex/home/controller/home_controller.dart';
import 'package:pokedex/home/ui/components/action_button.dart';
import 'package:pokedex/home/ui/components/custom_textfield.dart';
import 'package:pokedex/home/ui/components/pokemon_card.dart';
import 'package:pokedex/home/ui/pokemon_details/pokemon_details_screen.dart';
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
    // Provider.of<controller!>(context).loadPokemons();
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
      controller.fetchPokemonsPagation(context);
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
                          Navigator.pushAndRemoveUntil<dynamic>(
                            context,
                            MaterialPageRoute<dynamic>(
                              builder: (BuildContext context) => AuthScreen(),
                            ),
                            (route) =>
                                false, //if you want to disable back feature set to false
                          );
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
          child:
              Consumer<HomeController>(builder: (context, controller, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: controller.searchController,
                        prefixIcon: Icons.search,
                        hintText: 'Search by Name',
                        onChanged: (value) {
                          if (value.isEmpty) {
                            return;
                          }
                          controller.searchControllerOnChanged();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        if (controller.isFilterOn) {
                          controller.clearFilterOn();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: controller.isFilterOn
                              ? Colors.red
                              : const Color.fromRGBO(93, 94, 125, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: controller.isFilterOn
                            ? const Icon(
                                CupertinoIcons.xmark,
                                color: Colors.white,
                              )
                            : const Icon(
                                CupertinoIcons.line_horizontal_3_decrease,
                                color: Colors.white,
                              ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                if (controller.isLoading)
                  const Expanded(
                    child: Center(
                        child: SizedBox(
                      height: 200,
                      width: 200,
                      child: loadingIndicator,
                    )),
                  ),
                if (controller.errorMessage != null)
                  const Expanded(
                      child: Center(child: Text('No Pokémon found'))),
                if (controller.pokemons.isNotEmpty && !controller.isLoading)
                  Expanded(
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
                          itemCount: controller.pokemons.length,
                          itemBuilder: (context, index) {
                            final pokemon = controller.pokemons[index];

                            return PokemonCard(
                              wishlistIconOnTap: () async {
                                await controller.wishlistPokemon(
                                    index, context);
                                Logger()
                                    .i(controller.pokemons[index].isWishlisted);
                              },
                              isWishlisted: pokemon.isWishlisted,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PokemonDetails(
                                      pokemon: pokemon,
                                      index: getIndexofPokemon(pokemon.id!),
                                      backgroundColor:
                                          lightColors[randomIndex()],
                                    ),
                                  ),
                                );
                              },
                              index: getIndexofPokemon(index + 1),
                              imageUrl: pokemon.imageUrl!,
                              name: pokemon.name,
                              backgroundColor:
                                  lightColors[controller.randomIndex()],
                            );
                          },
                        ),
                      ),
                      controller.isPokemonFetching
                          ? fetchingLoadingIndicator
                          : const SizedBox(),
                    ]),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
