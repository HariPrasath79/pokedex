import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final String cartCount;
  final void Function()? onPressed;
  const ActionButton(
      {super.key, required this.cartCount, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        
        IconButton(
          icon: const Icon(CupertinoIcons.heart),
          onPressed: onPressed,
        ),
        Positioned(
          top: -4,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            child: Text(
              cartCount,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
