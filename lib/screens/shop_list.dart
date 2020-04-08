
import 'package:flutter/material.dart';
import 'package:offerhuntbusiness/api/api.dart';
import 'package:offerhuntbusiness/models/models.dart';
import '../api/store.dart';

class ShopList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return FirebaseDataList<Shop>(
      state: AuthProvider.of(context).store.shopState,
      itemBuilder: (context,Shop shop) => ShopItem(shop),
    );
  }

}

class ShopItem extends StatelessWidget{

  final Shop shop;

  const ShopItem(this.shop);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(shop.name),
    );
  }

}

class OfferList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FirebaseDataList<Offer>(
      state: AuthProvider.of(context).store.offerState,
      itemBuilder: (context,offer) => OfferItem(offer),
    );
  }
}

class OfferItem extends StatelessWidget {
  final Offer offer;

  const OfferItem(this.offer);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(offer.title),
    );
  }
}

