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
  int _initialPageIndex = 0;
  int get initialPageIndex => _initialPageIndex;

  set allVideoList(List<Video> allVideoListArg) {
    if (allVideoListArg == _allVideoList) return;
    _allVideoList = allVideoListArg;
    notifyListeners();
  }

  set initialPageIndex(int initialPageIndex) {
    if (initialPageIndex == _initialPageIndex) return;
    _initialPageIndex = initialPageIndex;
    notifyListeners();
  }

  Future<void> getAllVideoList() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("videos");
    ref.onValue.listen((DatabaseEvent event) async {
      if (event.snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> data = event.snapshot.value as Map;

        allVideoList = [];

        for (final d in data.values) {
          Video video = Video.fromJson(d);
          MyUser? user = await UserController.getAUser(video.userId);
          if (user != null) {
            video.user = user;
          }
          allVideoList.add(video);
        }

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

  static Future<void> updateVideoLikes(Video video) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("videos/${video.vid}");

    await ref.update({
      "likes": video.likes,
      "modifiedDate": DateTime.now().toString(),
    });
  }
}
