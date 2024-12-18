import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pokedex/core/dependency_injection.dart';
import 'package:pokedex/core/utils.dart';
import 'package:pokedex/home/repository/home_firebase_repository.dart';
import 'package:pokedex/home/ui/home.dart';
import 'package:pokedex/wishlist/repository/wishlist_firebase_repo.dart';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  User? user;
  String? errorMessage;
  String? uid;
  GoogleSignInAccount? _currentUser;
  bool _isSignInStatusChecking = false;

  bool get isSignInStatusChecking => _isSignInStatusChecking;
  bool get isLoading => _isLoading;

  GoogleSignInAccount? get currentUser => _currentUser;
  FirebaseAuth get auth => _auth;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> checkSignInStatus() async {
    _isSignInStatusChecking = true;
    notifyListeners();
    _currentUser = await _googleSignIn.signInSilently();
    _isSignInStatusChecking = false;
    if (_auth.currentUser != null) {
      final uid = _auth.currentUser!.uid;

      getIt.get<WishlistFirebaseRepo>().updateUserId(uid);
      getIt.get<HomeFirebaseRepository>().updateUserId(uid);
    }

    notifyListeners();
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _isLoading = false;
        notifyListeners();
        return; // User canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      final uid = _auth.currentUser!.uid;

      getIt.get<WishlistFirebaseRepo>().updateUserId(uid);
      getIt.get<HomeFirebaseRepository>().updateUserId(uid);

      _isLoading = false;

      // Navigate to home screen
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    } catch (e) {
      _isLoading = false;
      errorMessage = "Sign in failed";
      if (context.mounted) {
        getSnackBar(context, hint: "Sign in failed");
      }
    }

    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _currentUser = null;
    print("Sign out complete");

    notifyListeners();
  }
}
