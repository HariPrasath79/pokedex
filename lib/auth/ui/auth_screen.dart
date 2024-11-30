import 'package:flutter/material.dart';
import 'package:pokedex/auth/controller/auth_controller.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Consumer<AuthController>(
          builder: (cntx, controller, _) {
            return MaterialButton(
              onPressed: () {
                controller.signInWithGoogle(context);
              },
              color: Colors.black,
              padding: const EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: controller.isLoading
                  ? const SizedBox(
                      height: 40,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 40,
                          child: Image.asset(
                            "assets/search.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          "Continue With Google",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
      backgroundColor: const Color.fromRGBO(255, 203, 5, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/pokemon_logo.png'),
            const SizedBox(height: 10),
            const Text(
              "Welcome to Pokemon App, Let's explore the pokemon world",
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
