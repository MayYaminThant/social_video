import 'package:social_video/model/my_user.dart';

class Video {
  String vid;
  String userId;
  String videoUrl;
  String caption;
  List<String>? likes;
  String? createdDate;
  MyUser? user;

  Video({
    required this.vid,
    required this.userId,
    required this.videoUrl,
    required this.caption,
    required this.likes,
    required this.user,
    this.createdDate,
  });

  Video.fromJson(Map<dynamic, dynamic> json)
      : vid = json['vid'].toString(),
        userId = json['userId'],
        videoUrl = json['videoUrl'],
        caption = json['caption'],
        likes = json['likes'] != null
            ? List.of(json['likes'].cast<String>())
            : null,
        createdDate = json['createdDate'],
        user = null;
}
