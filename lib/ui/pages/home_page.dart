import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_video/controller/video_controller.dart';
import 'package:social_video/ui/widget/video_player_item.dart';
import 'package:social_video/util/common_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    CommonUtils.doInFuture(
      () {
        context.read<VideoController>().getAllVideoList();
      },
    );
    return Scaffold(
      body: _body,
    );
  }

  Widget get _body {
    return Consumer<VideoController>(
      builder: (_, controller, __) => PageView.builder(
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemCount: controller.allVideoList.length,
        itemBuilder: ((context, index) {
          return VideoPlayerItem(
            videoUrl: controller.allVideoList.elementAt(index).videoUrl,
            videoFile: null,
          );
        }),
      ),
    );
  }
}
