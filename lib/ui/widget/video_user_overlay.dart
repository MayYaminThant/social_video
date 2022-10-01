import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_video/controller/user_controller.dart';
import 'package:social_video/model/my_user.dart';
import 'package:social_video/util/screen_size_utils.dart';

import '../../controller/video_controller.dart';
import '../../model/video.dart';

class VideoUserOverlay extends StatefulWidget {
  const VideoUserOverlay({super.key, required this.video});

  final Video video;

  @override
  State<VideoUserOverlay> createState() => _VideoUserOverlayState();
}

class _VideoUserOverlayState extends State<VideoUserOverlay> {
  @override
  Widget build(BuildContext context) {
    MyUser? user = context.read<UserController>().currentUser;
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        const SizedBox(),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@ ${widget.video.user?.customerName}',
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                ),
                Text(
                  widget.video.caption,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: ScreenSizeUtil.screenHeight(context) / 2,
          width: 70,
          height: 70,
          child: SizedBox(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: widget.video.user?.profileUrl != null
                      ? Image.network(
                          widget.video.user!.profileUrl!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/no_image.jpg',
                              width: 60,
                              height: 60,
                              fit: BoxFit.fill,
                            );
                          },
                        )
                      : Image.asset(
                          'assets/images/no_image.jpg',
                          width: 60,
                          height: 60,
                          fit: BoxFit.fill,
                        ),
                ),
                Positioned(
                  bottom: -12,
                  right: 15,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add_circle_rounded,
                      color: Colors.pink,
                    ),
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 25,
          top: ScreenSizeUtil.screenHeight(context) / 1.7,
          child: Consumer<VideoController>(
            builder: (_, controller, __) => IconButton(
              onPressed: () {
                Video video = widget.video;
                video.likes ??= [];
                String userId = user?.customerId ?? '';
                if (video.likes!.contains(userId)) {
                  video.likes!.removeWhere((item) => item == userId);
                } else {
                  video.likes!.add(userId);
                }
                VideoController.updateVideoLikes(video);
              },
              icon: Icon(
                Icons.favorite,
                size: 50,
                color: widget.video.likes != null &&
                        user != null &&
                        widget.video.likes!.contains(user.customerId)
                    ? Colors.pink
                    : Colors.white,
              ),
              color: Colors.black,
            ),
          ),
        ),
        Positioned(
          right: 35,
          bottom: ScreenSizeUtil.screenHeight(context) / 4.7,
          child: Text(
            widget.video.likes?.length.toString() ?? '0',
            style: const TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
