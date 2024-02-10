// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_processing_penelitian_tus/controllers/camera_controllers.dart';
import 'package:image_processing_penelitian_tus/constants/text_list.dart'
    as text;

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
    super.initState();
    _cameraControllers = CameraControllers();
    _initializeCamera();
    debugPrint(text.debugInitMessage);
  }

  Future<void> _initializeCamera() async {
    try {
      await _cameraControllers.initializeCamera();
      setState(() {
        debugPrint(text.debugCameraState);
      });
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
  Future<void> _processImageFromCamera() async {
    debugPrint(text.debugImageProcessSuccess);
    // final XFile image = await _cameraControllers.controller.takePicture();

    setState(() {
      widget.dataResult = text.setStateCaptureImageMessage;
      // debugPrint("${text.setStateFromCameraMessage} ${image.path}");
      _initializeCamera();
      isCameraPreviewVisible = true;
    });
  }

  Future<void> _captureImage() async {
    final XFile image = await _cameraControllers.controller.takePicture();
    setState(() {
      widget.dataResult = text.setStateCaptureImageMessage;
      debugPrint("${text.setStateFromCameraMessage} ${image.path}");
      _initializeCamera();
      isCameraPreviewVisible = true;
    });
  }

  // Todo : 2. Implement fetch and process the image from gallery
  Future<void> _processImageFromGallery() async {
    debugPrint(text.processImageFunctionMessage);
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
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              title(),
              // todo: 3. ------ Camera Preview Section -------
              isCameraPreviewVisible ? cameraPreview() : noCameraResult(),
              buttonRow(),
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

  Text title() {
    return Text(
      text.titleBody,
      style: TextStyle(fontSize: 24),
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
            child: ElevatedButton(
              onPressed: () {
                _captureImage();
              },
              child: Text("Scan Image"),
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
}
