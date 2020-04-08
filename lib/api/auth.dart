import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:offerhuntbusiness/api/api.dart';
import 'package:offerhuntbusiness/api/paths.dart';
import 'package:offerhuntbusiness/api/store.dart';
import 'package:offerhuntbusiness/models/owner.dart';

enum PhoneAuthStatus {
  initial,
  invalidPhoneNumber,
  sendingCode,
  codeSent,
  verifyingCode,
  invalidCode,
  details,
  updatingDetails,
  welcome,
  successful
}

class PhoneAuthAPI {
  final _controller = StreamController<PhoneAuthStatus>();
  String verificationId;
  FirebaseUser user;
  Owner owner;

  Future init() async {
    user = await FirebaseAuth.instance.currentUser();
    if (user != null) owner = await Owner.fromKey(user.uid);
  }

  Future<String> get displayName async {
    if (owner.userName != null) return owner.userName;
    return null;
  }

  Stream<PhoneAuthStatus> get stream => _controller.stream;

  bool _verify(String phoneNumber) {
    if (phoneNumber.length != 13) {
      _controller.sink.add(PhoneAuthStatus.invalidPhoneNumber);
      return false;
    }
    return true;
  }

  void sendCode(String phoneNumber) {
    if (!_verify(phoneNumber)) return;
    _controller.sink.add(PhoneAuthStatus.sendingCode);
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: _verifyCredentials,
      verificationFailed: (exception) {
        _controller.add(PhoneAuthStatus.invalidPhoneNumber);
      },
      codeSent: (verificationId, [timeout]) {
        this.verificationId = verificationId;
        _controller.sink.add(PhoneAuthStatus.codeSent);
      },
      codeAutoRetrievalTimeout: (token) {},
    );
  }

  void verifyCode(String otpCode) {
    _verifyCredentials(
        PhoneAuthCredential(smsCode: otpCode, verificationId: verificationId));
  }

  void _verifyCredentials(AuthCredential credential) async {
    FirebaseAuth.instance.signInWithCredential(credential).then((result) async {
      this.user = result.user;
      if ((await Owner.fromKey(user.uid)) != null)
        _controller.sink.add(PhoneAuthStatus.welcome);
      else
        _controller.sink.add(PhoneAuthStatus.details);
    }).catchError((error) {
      _controller.add(PhoneAuthStatus.invalidCode);
    });
  }

  void updateOwner(Owner owner) async {
    _controller.sink.add(PhoneAuthStatus.updatingDetails);
    owner.userId = user.uid;
    owner.contact = user.phoneNumber;
    await FirebaseDatabase.instance
        .reference()
        .child(OWNERS)
        .child(user.uid)
        .set(owner.toJson());
    this.owner = owner;
    _controller.sink.add(PhoneAuthStatus.welcome);
  }

  void dispose() {
    _controller.close();
  }

  void edit() {
    _controller.sink.add(PhoneAuthStatus.initial);
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
    verificationId = null;
    user = null;
    owner = null;
  }
}

class AuthProvider extends StatelessWidget {
  final Widget child;
  final AuthState state = AuthState();

  PhoneAuthAPI get authApi => state.authApi;

  OwnerApi get ownerApi => state.ownerApi;

  OwnerStore get store => state.store;

  Future init() => state.init();
  Future logout() => state.logout();

  AuthProvider({@required this.child});

  FirebaseUser get currentUser => authApi.user;

  Owner get currentOwner => authApi.owner;

  factory AuthProvider.of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<AuthProvider>();

  @override
  Widget build(BuildContext context) => child;
}

class AuthState {
  PhoneAuthAPI authApi;
  OwnerApi ownerApi;
  OwnerStore store;

  Future init() async {
    authApi = PhoneAuthAPI();
    await authApi.init();
    ownerApi = OwnerApi.withAuthApi(authApi);
    store = OwnerStore.fromAuthApi(authApi);
    store.init();
  }

  Future logout() async {
    await authApi.logout();
    authApi.dispose();
    authApi = null;
    ownerApi = null;
    store.dispose();
    store = null;
  }
}
