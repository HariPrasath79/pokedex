import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PokemonCard extends StatelessWidget {
  final Color? backgroundColor;
  final bool isHeroDisabled;
  final String index;
  final String imageUrl;
  final String name;
  final bool isWishlisted;
  final void Function()? onTap;
  final void Function()? wishlistIconOnTap;
  const PokemonCard({
    super.key,
    this.backgroundColor,
    required this.index,
    required this.imageUrl,
    required this.name,
    required this.isWishlisted,
    required this.wishlistIconOnTap,
    this.onTap,
    this.isHeroDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          width: double.maxFinite,
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: backgroundColor,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              // overlayColor: WidgetStatePropertyAll(Colors.black),
              onTap: onTap,
              onDoubleTap: wishlistIconOnTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  isHeroDisabled
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                        )
                      : Hero(
                          tag: name,
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                  Column(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        index,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        IconButton(
          style: IconButton.styleFrom(backgroundColor: Colors.white),
          // highlightColor: Colors.white,
          onPressed: wishlistIconOnTap,
          icon: isWishlisted
              ? Icon(
                  CupertinoIcons.heart_fill,
                  color: Colors.red,
                )
              : Icon(CupertinoIcons.heart),
        )
      ],
    );
  }
}
