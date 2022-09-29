import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:social_video/ui/pages/video_upload_page.dart';
import 'package:social_video/util/navigator_utils.dart';

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
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['mp4'],
          );
          if (result == null) return;

          PlatformFile platformFile = result.files.first;
          final File file = File(platformFile.path!);
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
