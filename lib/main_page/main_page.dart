// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  MainPage({super.key});

  String dataResult = "Result From Image Processing";
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    debugPrint('Inisiasi berhasil: Masuk ke Halaman Main');
  }

  // Todo : 1. Implement fetch and process the image from camera
  // get and process image from camera
  Future processImageFromCamera() async {
    // show debug print
    debugPrint('processImageFromCamera : pressed by future function');
    setState(() {
      widget.dataResult = "Result From Image Processing Clicked";
    });
  }

  // Todo : 2. Implement fetch and process the image from gallery
  // get and process image from gallery
  Future processImageFromGallery() async {
    // show debug print
    debugPrint('processImageFromCamera : pressed by future function');
    setState(() {
      widget.dataResult = "Develope the Image Processing Camera First!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Image Processing',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red.shade900,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Image Recognition Using TF',
                  style: TextStyle(fontSize: 24),
                ),

                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: Text(
                    "Silahkan pilih gambar dari kamera atau galeri",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
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

                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // todo: 4. ------ Implement fetch and process the image from camera
                        processImageFromCamera();
                      },
                      child: const Text('📸'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // todo: 5. ------ Implement fetch and process the image from gallery
                        processImageFromGallery();
                      },
                      child: const Text('📂'),
                    ),
                  ],
                ),

                Container(
                  padding: const EdgeInsets.all(16),
                ),
                
                // todo: 6. ------ Result Section -------
                Text(widget.dataResult ?? "No Data"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
