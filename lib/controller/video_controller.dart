import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_video/controller/user_controller.dart';
import 'package:social_video/model/my_user.dart';
import 'package:social_video/model/video.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:path/path.dart' as path;

class VideoController extends ChangeNotifier {
  List<Video> _allVideoList = [];
  List<Video> get allVideoList => _allVideoList;
  List<Video> _filterVideoList = [];
  List<Video> get filterVideoList => _filterVideoList;

  set allVideoList(List<Video> allVideoListArg) {
    if (allVideoListArg == _allVideoList) return;
    _allVideoList = allVideoListArg;
    notifyListeners();
  }

  set filterVideoList(List<Video> filterVideoList) {
    if (filterVideoList == _filterVideoList) return;
    _filterVideoList = filterVideoList;
    notifyListeners();
  }

  Future<void> getAllVideoList() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("videos");
    ref.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> data = event.snapshot.value as Map;

        allVideoList = [];
        data.forEach((key, value) async {
          Video video = Video.fromJson(value);
          MyUser? user = await UserController.getAUser(video.userId);
          if (user != null) video.user = user;
          allVideoList.add(video);
        });
        notifyListeners();
      }
    });
  }

  static Future<String> uploadVideo(
      BuildContext context, File videoFile) async {
    FirebaseStorage storage = FirebaseStorage.instance;

    try {
      final String fileName = path.basename(videoFile.path);
      try {
        var snapshot = await storage.ref(fileName).putFile(videoFile);

        return await snapshot.ref.getDownloadURL();
      } on FirebaseException catch (e) {
        if (kDebugMode) {
          log(e.toString());
        }
      }
      return "";
    } catch (err) {
      if (kDebugMode) {
        log(err.toString());
      }
      return "";
    }
  }

  static Future<void> uploadPost(
      BuildContext context, File videoFile, String caption, MyUser user,
      {required VoidCallback successCallback,
      required VoidCallback failureCallback}) async {
    String videoPath = await uploadVideo(context, videoFile);
    String key = "${DateTime.now().millisecondsSinceEpoch}_${user.customerId}";
    DatabaseReference ref = FirebaseDatabase.instance.ref("videos/$key");
    try {
      await ref.set({
        'vid': key,
        'userId': user.customerId,
        'videoUrl': videoPath,
        'caption': caption,
        'likes': [0],
        'createdDate': DateTime.now().toString(),
      });
      successCallback();
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        log(e.toString());
        failureCallback();
      }
    }
  }
}