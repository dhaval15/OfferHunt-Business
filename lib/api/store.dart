import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:offerhuntbusiness/api/api.dart';
import 'package:offerhuntbusiness/api/refs.dart';
import 'package:offerhuntbusiness/models/models.dart';

class OwnerStore {
  static Future<Map<String, dynamic>> getShopDoc(String key) async {
    return (await Refs.shops.child(key).once()).value;
  }

  static Future<Map<String, dynamic>> getOfferDoc(String key) async {
    return (await Refs.offers.child(key).once()).value;
  }

  final OfferState offerState;
  final ShopState shopState;

  OwnerStore._(this.shopState, this.offerState);

  factory OwnerStore.fromAuthApi(PhoneAuthAPI api) {
    final ownerKey = api.user.uid;
    Query shopQuery = Refs.shops.orderByChild('w').equalTo(ownerKey);
    Query offerQuery = Refs.offers.orderByChild('w').equalTo(ownerKey);
    return OwnerStore._(ShopState(shopQuery), OfferState(offerQuery));
  }

  void init() {
    offerState.init();
    shopState.init();
  }

  void dispose() {
    offerState.dispose();
    shopState.dispose();
  }
}

abstract class FirebaseDataState<T> {
  final List<T> data = [];
  final List<String> _keys = [];
  final List<StreamSubscription> _subscriptions = [];
  final List<StreamController<int>> _controllers = [];

  Stream get newStream {
    for(final controller in _controllers){
      if(!controller.hasListener){
        controller.close();
        _controllers.remove(controller);
      }
    }
    final controller = StreamController();
    _controllers.add(controller);
    return controller.stream;
  }

  FirebaseDataState(this.query);

  T generate(dynamic doc);

  final Query query;

  void init() {
    _subscriptions.add(query.onChildAdded.listen((event) {
      data.add(generate(event.snapshot.value));
      _keys.add(event.snapshot.key);
      _controllers.forEach((element) {
        element.add(1);
      });
    }));
    _subscriptions.add(query.onChildRemoved.listen((event) {
      int index = _keys.indexOf(event.snapshot.key);
      data.removeAt(index);
      _keys.removeAt(index);
      _controllers.forEach((element) {
        element.add(1);
      });
    }));
    _subscriptions.add(query.onChildChanged.listen((event) {
      int index = _keys.indexOf(event.snapshot.key);
      data[index] = generate(event.snapshot.value);
      _controllers.forEach((element) {
        element.add(1);
      });
    }));
  }

  void dispose() {
    _subscriptions.forEach((element) {
      element.cancel();
    });
    _controllers.forEach((element) {
      element.close();
    });
  }
}

typedef DataListener<T> = Function(List<T> data);

class OfferState extends FirebaseDataState<Offer> {
  OfferState(Query query) : super(query);

  @override
  Offer generate(doc) => Offer.fromJson(doc);
}

class ShopState extends FirebaseDataState<Shop> {
  ShopState(Query query) : super(query);

  @override
  Shop generate(doc) => Shop.fromJson(doc);
}

typedef FirebaseItemBuilder<T> = Widget Function(BuildContext context, T item);

class FirebaseDataList<T> extends StatelessWidget {
  final FirebaseItemBuilder<T> itemBuilder;
  final FirebaseDataState<T> state;

  const FirebaseDataList({this.itemBuilder, this.state});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: state.newStream,
        builder: (context, snapshot) {
          return ListView.builder(
            itemBuilder: (context, index) => itemBuilder(
              context,
              state.data[index],
            ),
            itemCount: state.data.length,
          );
        });
  }
}
