import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:offerhuntbusiness/api/refs.dart';
import 'package:offerhuntbusiness/api/store.dart';
import 'package:offerhuntbusiness/models/models.dart';

import '../api/api.dart';

class Shop {
  String key;
  String name;
  double lat;
  double long;
  String address;
  String emailId;
  String contactNo;
  String owner;
  List<String> categories;
  
  Shop({
    this.key,
    this.name,
    this.lat,
    this.long,
    this.address,
    this.contactNo,
    this.emailId,
    this.owner,
    this.categories,
  });

  factory Shop.ofOwner(Owner owner)=>Shop(
    owner: owner.userId,
    contactNo: owner.contact,
    emailId: owner.emailId,
  );
  
  Map<String, dynamic> toJson() => {
    'k': key,
    'n': name,
    'l': lat,
    'o': long,
    'c': contactNo,
    'a': address,
    'e': emailId,
    'w': owner,
    'z': categories,
  };
  
  Future save(BuildContext context,{File image}) async {
    final api = AuthProvider.of(context).ownerApi;
    key = Refs.newShopKey;
    await api.saveShop(toJson());
    if(image!=null)await api.uploadShopImage(key,image);
  }

  void copyFrom(Shop shop){
    key = shop.key ?? key;
    name = shop.name ?? name;
    address = shop.address ?? address;
    lat = shop.lat ?? lat;
    long = shop.long ?? long;
    contactNo = shop.contactNo ?? contactNo;
    emailId = shop.emailId ?? emailId;
    owner = shop.owner ?? owner;
    categories = shop.categories ?? categories;
  }
  
  factory Shop.fromJson(Map<String, dynamic> doc) => Shop(
    key: doc['k'],
    name: doc['t'],
    address: doc['a'],
    lat: doc['l'],
    long: doc['o'],
    emailId: doc['e'],
    contactNo: doc['c'],
    owner: doc['w'],
    categories: doc['z'],
  );
  
  static Future<Shop> fromKey(String key) async {
    return Shop.fromJson(await OwnerStore.getShopDoc(key));
  }
}
