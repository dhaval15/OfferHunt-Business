import 'package:firebase_database/firebase_database.dart';

class Owner {
  String userId;
  String contact;
  final String emailId;
  final String userName;
  final String address;

  Owner({
    this.userId,
    this.emailId,
    this.address,
    this.userName,
    this.contact,
  });

  Map<String, dynamic> toJson() => {
        'i': userId,
        'c': contact,
        'e': emailId,
        'n': userName,
        'a': address,
      };

  // ignore: missing_return
  static Future<Owner> fromKey(String key) async {
    try {
      final doc = (await FirebaseDatabase.instance.reference().child('owners').child(key).once()).value;
      return doc!=null ? Owner.fromDoc(doc): null;
    }
    catch(e){
      print(e);
      return null;
    }
  }

  static Owner fromDoc(dynamic doc) => Owner(
      address: doc['a'],
      userId: doc['i'],
      userName: doc['n'],
      contact: doc['c'],
      emailId: doc['e'],
    );
}