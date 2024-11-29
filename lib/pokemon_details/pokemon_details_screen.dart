import 'package:flutter/material.dart';
import 'package:pokedex/home/models/pokemon.dart';

class PokemonDetails extends StatelessWidget {
  final Pokemon pokemon;
  final String index;
  final Color backgroundColor;

  const PokemonDetails({
    super.key,
    required this.pokemon,
    required this.index,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text(
              pokemon.name,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              index,
              style: const TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Animation for Image
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              padding: EdgeInsets.symmetric(vertical: 35),
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(25)),
              child: Hero(
                tag: pokemon.name,
                child: Center(
                  child: Image.network(
                    pokemon.imageUrl!,
                    fit: BoxFit.contain,
                    height: 250,
                    width: 250,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Other Pokémon details here
            const Text(
              "Stats",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(pokemon.stats!.length, (index) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${pokemon.stats![index].stat}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          '${pokemon.stats![index].baseStat}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Abilities",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(pokemon.abilities!.length, (index) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${pokemon.abilities![index].ability}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          '${pokemon.abilities![index].slot}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Weight: ${pokemon.weight}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
