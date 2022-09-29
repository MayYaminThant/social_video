import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:social_video/model/my_user.dart';

class UserController with ChangeNotifier {
  MyUser? _currentUser;
  MyUser? get currentUser => _currentUser;

  set currentUser(MyUser? currentUser) {
    if (currentUser == _currentUser) return;
    _currentUser = currentUser;
    notifyListeners();
  }

  static Future<void> insertUser() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }
    User user = FirebaseAuth.instance.currentUser!;
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/${user.uid}");

    await ref.set({
      "customerId": user.uid,
      "customerName": user.displayName,
      "emailAddress": user.email,
      "profileUrl": user.photoURL,
      "createdDate": DateTime.now().toString(),
      "modifiedDate": DateTime.now().toString(),
    });
  }

  static Future<MyUser?> getAUser(String userId) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref();

    final snapshot = await ref.child('users/$userId').get();
    if (snapshot.exists) {
      return MyUser.fromJson(snapshot.value as Map<dynamic, dynamic>);
    } else {
      return null;
    }
  }
}
