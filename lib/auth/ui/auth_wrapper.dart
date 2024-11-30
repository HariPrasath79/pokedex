import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/auth/controller/auth_controller.dart';
import 'package:pokedex/auth/ui/auth_screen.dart';
import 'package:pokedex/core/connectivity_checker.dart';
import 'package:pokedex/core/dependency_injection.dart';
import 'package:pokedex/core/no_internet_screen.dart';
import 'package:pokedex/home/repository/home_firebase_repository.dart';
import 'package:pokedex/home/ui/home.dart';
import 'package:pokedex/wishlist/repository/wishlist_firebase_repo.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Start listening for connectivity changes.
    final connectivityNotifier =
        Provider.of<ConnectivityNotifier>(context, listen: false);
    final authController = Provider.of<AuthController>(context, listen: false);

    connectivityNotifier.addListener(() async {
      if (connectivityNotifier.isConnected) {
        // Trigger sign-in status check when internet is available.
        await authController.checkSignInStatus();

       
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final connectivityNotifier = Provider.of<ConnectivityNotifier>(context);

    if (!connectivityNotifier.isConnected) {
      return const NoInternetScreen();
    }

    return const ScreenNavigation();
  }
}

class ScreenNavigation extends StatelessWidget {
  const ScreenNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authProvider, child) {
        if (authProvider.isSignInStatusChecking) {
          return Scaffold(
            backgroundColor: const Color.fromRGBO(255, 203, 5, 1),
            body: Center(
              child: Image.asset('assets/pokemon_logo.png'),
            ),
          );
        }

        if (authProvider.currentUser != null) {
          return const HomeScreen();
        } else {
          return AuthScreen();
        }
      },
    );
  }
}
