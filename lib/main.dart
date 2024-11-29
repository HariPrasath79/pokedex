import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/auth/controller/auth_controller.dart';
import 'package:pokedex/auth/ui/auth_screen.dart';
import 'package:pokedex/auth/ui/auth_wrapper.dart';

import 'package:pokedex/firebase_options.dart';

import 'package:pokedex/home/controller/home_controller.dart';
import 'package:pokedex/home/ui/home.dart';
import 'package:pokedex/wishlist/controller/wishlist_controller.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => AuthController()..checkSignInStatus()),
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => WishListController()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: const Color.fromRGBO(245, 251, 251, 1),
            surfaceTintColor: Colors.transparent,
          ),
          scaffoldBackgroundColor:
              const Color.fromRGBO(245, 251, 251, 1), //rgb(245 251 251)
          fontFamily: "poppins",
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: AuthWrapper(),
      ),
    );
  }
}
