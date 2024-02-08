// todo: Kerjakan setelah selesai
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// Mengambil gambar dari galeri
Future<String> openFile({ImageSource? source}) async {
  final imagePicker = ImagePicker();

  String path = '';

  try {
    final getImage = await imagePicker.pickImage(source: source!);

    getImage != null ? path = getImage.path : path;
  } catch (e) {
    debugPrint(e.toString()); 
  }

  return path;
}

Future<void> selectImage() async {}

Future<void> batchSelection() async {}

Future<void> processImage() async {}
