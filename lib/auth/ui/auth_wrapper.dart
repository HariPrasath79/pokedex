import 'package:flutter/material.dart';
import 'package:pokedex/auth/controller/auth_controller.dart';
import 'package:pokedex/auth/ui/auth_screen.dart';
import 'package:pokedex/home/ui/home.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthController>(context);

    if (authProvider.isSignInStatusChecking) {
      return Scaffold(
          backgroundColor: Color.fromRGBO(255, 203, 5, 1),
          body: Center(
            child: Image.asset('assets/pokemon_logo.png'),
          ));
    }

    if (authProvider.currentUser != null) {
      return const HomeScreen();
    } else {
      return AuthScreen();
    }
  }
}
