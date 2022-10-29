// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';

// class CameraPage extends StatefulWidget {
//   const CameraPage({super.key, required this.cameras});

//   final List<CameraDescription>? cameras;
//   @override
//   State<CameraPage> createState() => _CameraPageState();
// }

// class _CameraPageState extends State<CameraPage> {
//   late CameraController _cameraController;
//   @override
//   void initState() {
//     super.initState();
//     // initialize the rear camera
//     initCamera(widget.cameras![0]);
//   }

//   @override
//   void dispose() {
//     // Dispose of the controller when the widget is disposed.
//     _cameraController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: _cameraController.value.isInitialized
//             ? CameraPreview(_cameraController)
//             : const Center(child: CircularProgressIndicator()),
//       ),
//     );
//   }

//   Future initCamera(CameraDescription cameraDescription) async {
//     _cameraController =
//         CameraController(cameraDescription, ResolutionPreset.high);

//     try {
//       await _cameraController.initialize().then((value) {});
//     } on CameraException catch (e) {
//       debugPrint("camera error $e");
//     }
//   }
// }
