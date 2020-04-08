import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:offerhuntbusiness/api/refs.dart';
import 'package:offerhuntbusiness/api/store.dart';
import '../api/api.dart';

class Offer {
  String key;
  String title;
  String subtitle;
  int discount;
  String description;
  DateTime fromDate;
  DateTime toDate;
  String shopKey;
  List<String> categories;
  String owner;

  Offer({
    this.key,
    this.title,
    this.subtitle,
    this.description,
    this.discount,
    this.shopKey,
    this.fromDate,
    this.toDate,
    this.owner,
    this.categories,
  });

  Map<String, dynamic> toJson() => {
        'k': key,
        't': title,
        's': subtitle,
        'd': description,
        'a': shopKey,
        'p': discount,
        'f': fromDate.millisecondsSinceEpoch,
        'e': toDate.millisecondsSinceEpoch,
        'w': owner,
        'z': categories,
      };

  Future save(BuildContext context,{File image}) async {
    final api = AuthProvider.of(context).ownerApi;
    key = Refs.newOfferKey;
    await api.saveOffer(toJson());
    if (image != null) await api.uploadOfferImage(key, image);
  }

  void copyFrom(Offer offer) {
    key = offer.key ?? key;
    title = offer.title ?? title;
    subtitle = offer.subtitle ?? subtitle;
    description = offer.description ?? description;
    discount = offer.discount ?? discount;
    fromDate = offer.fromDate ?? fromDate;
    toDate = offer.toDate ?? toDate;
    shopKey = offer.shopKey ?? shopKey;
    owner = offer.owner ?? owner;
    categories = offer.categories ?? categories;
  }

  factory Offer.fromJson(Map<String, dynamic> doc) => Offer(
        key: doc['k'],
        title: doc['t'],
        subtitle: doc['s'],
        description: doc['d'],
        shopKey: doc['a'],
        discount: doc['p'],
        fromDate: DateTime.fromMillisecondsSinceEpoch(doc['f']),
        toDate: DateTime.fromMillisecondsSinceEpoch(doc['e']),
        owner: doc['w'],
        categories: doc['z'],
      );

  static Future<Offer> fromKey(String key) async {
    return Offer.fromJson(await OwnerStore.getOfferDoc(key));
  }
}
