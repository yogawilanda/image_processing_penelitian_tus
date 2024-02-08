// camera_controllers.dart

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraControllers {
  late CameraController controller;

  Future<void> initializeCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    List<CameraDescription> cameras = await availableCameras();
    controller = CameraController(
      cameras[0],
      ResolutionPreset.max,
    );

    await controller.initialize();
  }

  Future<XFile> takePicture() async {
    return await controller.takePicture();
  }

  void disposeCamera() {
    controller.dispose();
  }
}
