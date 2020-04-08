import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Refs {
  static DatabaseReference get shops =>
      FirebaseDatabase.instance.reference().child('shops');

  static DatabaseReference get offers =>
      FirebaseDatabase.instance.reference().child('offers');

  static StorageReference get shopImages =>
      FirebaseStorage.instance.ref().child('shops');

  static StorageReference get offerImages =>
      FirebaseStorage.instance.ref().child('offers');

  static String get newShopKey => shops.push().key;

  static String get newOfferKey => offers.push().key;

}
