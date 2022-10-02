import 'dart:io';

import 'package:flutter/material.dart';
import '../../ui/pages/video_upload_page.dart';
import '../../util/file_picker_utils.dart';

import '../../util/navigator_utils.dart';

class AddVideoPage extends StatefulWidget {
  const AddVideoPage({super.key});

  @override
  State<AddVideoPage> createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: _pickFileButton),
    );
  }

  Center get _pickFileButton {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final File? file = await FilePickerUtils.pickFile(['mp4']);
          if (file == null) {
            return;
          }
          if (!mounted) return;
          NavigatorUtils.push(context, UploadVideoPage(videoFile: file));
        },
        style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 17),
            backgroundColor: Colors.pink[400],
            fixedSize: const Size(150, 50)),
        child: const Text('Add Video'),
      ),
    );
  }
}
