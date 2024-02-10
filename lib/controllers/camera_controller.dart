// camera_controller.dart

import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class CameraControllers {
  late CameraController controller;
  late String imagePath = ''; // Add this variable to store the image path

  final TextRecognizer textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  Future<void> textRecognition() async {
    final inputImage = InputImage.fromFilePath(imagePath);

    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          print(word.text);
        }
      }
    }
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  Future<void> initializeCamera() async {
    await WidgetsFlutterBinding.ensureInitialized();
    List<CameraDescription> cameras = await availableCameras();
    controller = CameraController(
      // 1 is the front camera
      // 0 is the back camera
      cameras[0],
      ResolutionPreset.medium,
    );

    await controller.initialize();
  }

  Future<void> takePicture() async {
    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String pictureDirectory = '${appDirectory.path}/Pictures';
    await Directory(pictureDirectory).create(recursive: true);

    final XFile image = await controller.takePicture();
    imagePath = image.path;
  }

  void disposeCamera() {
    controller.dispose();
  }
}
