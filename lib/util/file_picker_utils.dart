import 'dart:io';

import 'package:file_picker/file_picker.dart';

class FilePickerUtils {
  static Future<File?> pickFile(List<String> allowedExtensions) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );
    if (result == null) return null;

    PlatformFile platformFile = result.files.first;
    final File file = File(platformFile.path!);
    return file;
  }
}
