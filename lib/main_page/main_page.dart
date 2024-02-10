// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_processing_penelitian_tus/controllers/camera_controller.dart';
import 'package:image_processing_penelitian_tus/constants/text_list.dart'
    as text;
import 'package:image_processing_penelitian_tus/main_page/scan_list.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  String? dataResult = text.noData;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late CameraControllers _cameraControllers;
  bool isCameraPreviewVisible = false;

  @override
  void initState() {
    _cameraControllers = CameraControllers();
    super.initState();
    _initializeCamera();
    debugPrint(text.debugInitMessage);
  }

  Future<void> _initializeCamera() async {
    try {
      await _cameraControllers.initializeCamera();
      if (_cameraControllers.controller.value.isInitialized) {
        setState(() {
          isCameraPreviewVisible = true;
          debugPrint(text.debugCameraState);
        });
      } else {
        debugPrint('${text.errorCameraInitialization} Camera not initialized');
      }
    } catch (e) {
      debugPrint('${text.errorCameraInitialization} $e');
    }
  }

  // Close the camera when the widget is removed from the widget tree.
  void _closeCamera() async {
    setState(() {
      isCameraPreviewVisible = false;
    });
  }

  // Todo : 1. Implement fetch and process the image from camera
  // Future<void> _processImageFromCamera() async {
  //   debugPrint(text.debugImageProcessSuccess);
  //   // final XFile image = await _cameraControllers.controller.takePicture();

  //   setState(() {
  //     widget.dataResult = text.setStateCaptureImageMessage;
  //     // debugPrint("${text.setStateFromCameraMessage} ${image.path}");
  //     _initializeCamera();
  //     isCameraPreviewVisible = true;
  //   });
  // }

  final ImagePicker _picker = ImagePicker();
  Future<void> _processImageFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: _cameraControllers.controller.value.isInitialized
          ? ImageSource.camera
          : ImageSource.gallery,
    );

    if (image != null) {
      // final tmpDirectory = await getTemporaryDirectory();
      // final imageFile = File('${tmpDirectory.path}/${DateTime.now()}.jpg');
      // await image.saveTo(imageFile.path);

      setState(() {
        widget.dataResult = text.setStateCaptureImageMessage;
        debugPrint("${text.setStateFromCameraMessage} ${image.path}");
        _initializeCamera();
        isCameraPreviewVisible = true;
        _cameraControllers
            .textRecognition(); // Assuming you have implemented this
      });
    } else {
      debugPrint('Image selection cancelled or error occurred');
      // Consider displaying an error message to the user here
    }
  }

  Future<void> _captureImage() async {
    try {
      if (await Permission.storage.request().isGranted) {
        final XFile image = await _cameraControllers.controller.takePicture();

        final Directory appDirectory = await getApplicationCacheDirectory();
        final String pictureDirectory = '${appDirectory.path}/Pictures';

        await Directory(pictureDirectory).create(recursive: true);

        final String imagePath =
            '$pictureDirectory/${DateTime.now().millisecondsSinceEpoch}.jpg';
        await File(image.path).copy(imagePath);

        print('Image captured: ${image.path}');

        setState(() async {
          widget.dataResult = text.setStateCaptureImageMessage;
          await _initializeCamera();
          isCameraPreviewVisible = true;
          await _cameraControllers.textRecognition();
        });
      } else {
        print('Permission denied for storage.');
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  // Todo : 2. Implement fetch and process the image from gallery
  Future<void> _processImageFromGallery() async {
    debugPrint(text.processImageFunctionMessage);

    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      widget.dataResult = text.setStateOpenFileMessage;
    });
  }

  @override
  void dispose() {
    _cameraControllers.disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          text.titleAppBar,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red.shade900,
      ),
      body: content(),
    );
  }

  Widget content() {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(2),
          child: Column(
            children: [
              title(),
              // todo: 3. ------ Camera Preview Section -------
              isCameraPreviewVisible ? cameraPreview() : noCameraResult(),
              buttonRow(),
              directoryResult(),
              // todo: 6. ------ Result Section -------
              dynamicText(widget.dataResult ?? text.noData),
            ],
          ),
        ),
      ),
    );
  }

  Padding fixedPadding({double paddingValue = 16}) {
    return Padding(
      padding: EdgeInsets.all(paddingValue),
    );
  }

  Widget title() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Text(
        text.titleBody,
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Text dynamicText(String content) => Text(widget.dataResult ?? text.noData);

  ButtonBar buttonRow() {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            // todo: 4. ------ Implement fetch and process the image from camera
            _processImageFromCamera();
          },
          child: const Text('📸'),
        ),
        ElevatedButton(
          onPressed: () {
            // todo: 5. ------ Implement fetch and process the image from gallery
            _processImageFromGallery();
          },
          child: Text(text.cameraButtonIcon),
        ),
        fixedPadding(),
      ],
    );
  }

  Container cameraPreview() {
    return Container(
      height: 400,
      width: 400,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
                // Any decoration necessary
                ),
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(16), // Match container's borderRadius
              child: AspectRatio(
                aspectRatio: _cameraControllers.controller.value.aspectRatio,
                child: CameraPreview(_cameraControllers.controller),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Todo: Scan image
                  },
                  child: Text("Scan Image"),
                ),
                SizedBox(
                  width: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Todo: Save to directory
                    // _captureImage();
                  },
                  child: Text("Save Image"),
                ),
              ],
            ),
          ),
          Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: _closeCamera,
                icon: Icon(
                  Icons.close,
                  color: Colors.red.shade900,
                  size: 32,
                  semanticLabel: "Close Camera",
                ),
              )),
        ],
      ),

      // todo: 3. ------ Image Section -------
      // Conditionally if image is not picked, then show text "No Image Selected"
      // (imageSource != null)
      //     ? Image.file(
      //         imageSource!,
      //         width: 300,
      //         height: 300,
      //       )
      //     : Text("No Image Selected"),
    );
  }

  Container noCameraResult() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Text(text.noCameraPreview),
    );
  }

  Widget directoryResult() {
    return ScanList();
  }
}
