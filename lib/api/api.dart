import 'dart:async';
import 'dart:io';
import 'package:offerhuntbusiness/api/auth.dart';
import 'package:offerhuntbusiness/api/refs.dart';
export 'auth.dart';

class OwnerApi {
  final PhoneAuthAPI api;

  OwnerApi._(this.api);

  factory OwnerApi.withAuthApi(PhoneAuthAPI api) => OwnerApi._(api);

  Future saveShop(Map<String, dynamic> shop) async {
    await Refs.shops.child(shop['k']).set(shop);
  }

  Future saveOffer(Map<String, dynamic> offer) async {
    await Refs.offers.child(offer['k']).set(offer);
  }

  Future uploadShopImage(String key, File image) {
    return Refs.shopImages.child(key).putFile(image).onComplete;
  }

  Future uploadOfferImage(String key, File image) {
    return Refs.offerImages.child(key).putFile(image).onComplete;
  }
}
