import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_video/common/common_widget.dart';
import 'package:social_video/model/my_user.dart';
import 'package:path/path.dart' as path;

class UserController with ChangeNotifier {
  MyUser? _currentUser;
  MyUser? get currentUser => _currentUser;

  set currentUser(MyUser? currentUser) {
    if (currentUser == _currentUser) return;
    _currentUser = currentUser;
    notifyListeners();
  }

  File? _pickedImageFile;
  File? get pickedImageFile => _pickedImageFile;

  set pickedImageFile(File? pickedImageFile) {
    if (pickedImageFile == _pickedImageFile) return;
    _pickedImageFile = pickedImageFile;
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

  static Future<void> updateUserByProfileUrl(String profileUrl) async {
    _updateUser({
      "profileUrl": profileUrl,
      "modifiedDate": DateTime.now().toString(),
    });
  }

  static Future<void> _updateUser(Map<String, Object?> map) async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }
    User user = FirebaseAuth.instance.currentUser!;
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/${user.uid}");

    await ref.update(map);
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

  Future<String?> uploadPicture(BuildContext context) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    if (pickedImageFile == null) {
      showSimpleSnackBar(context, "Your picked image is invalid!", Colors.red);
      return "";
    }

    try {
      final String fileName = path.basename(pickedImageFile!.path);
      File imageFile = File(pickedImageFile!.path);
      try {
        var snapshot = await storage.ref(fileName).putFile(imageFile);

        String? oldImageUrl = currentUser?.profileUrl ?? '';

        if (oldImageUrl.isNotEmpty) {
          await storage.refFromURL(oldImageUrl).delete();
        }
        return await snapshot.ref.getDownloadURL();
      } on FirebaseException catch (e) {
        if (kDebugMode) {
          log(e.toString());
          showSimpleSnackBar(context, e.toString(), Colors.red);
        }
      }
      return null;
    } catch (err) {
      if (kDebugMode) {
        log(err.toString());
        showSimpleSnackBar(context, err.toString(), Colors.red);
      }
      return null;
    }
  }
}
