import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/home/repository/home_firebase_repository.dart';
import 'package:pokedex/home/repository/home_repository.dart';
import 'package:pokedex/wishlist/repository/wishlist_firebase_repo.dart';

final getIt = GetIt.instance;

class DepInj {
  static void init() {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    getIt.registerSingleton<HomeFirebaseRepository>(
        HomeFirebaseRepository(firestore: firestore));

    getIt.registerSingleton<WishlistFirebaseRepo>(
        WishlistFirebaseRepo(firestore));

    getIt.registerSingleton<HomeRepository>(HomeRepository());
  }
}



// void init() {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   getIt.registerSingleton<HomeFirebaseRepository>(
//       HomeFirebaseRepository(firestore: _firestore));

//   getIt.registerSingleton<WishlistFirebaseRepo>(
//       WishlistFirebaseRepo(_firestore));

//   getIt.registerSingleton<HomeRepository>(HomeRepository());

// // Alternatively you could write it if you don't like global variables
// }
