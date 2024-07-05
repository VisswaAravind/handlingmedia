import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Imageselection extends StatefulWidget {
  const Imageselection({super.key});

  @override
  State<Imageselection> createState() => _ImageselectionState();
}

class _ImageselectionState extends State<Imageselection> {
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _requestPermission(Permission permission) async {
    final status = await permission.request();
    if (status != PermissionStatus.granted) {
      Get.snackbar(
        'Permission Denied',
        'Permission is required to access the storage and camera.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
  }

  Future<void> _pickImages() async {
/*    await _requestPermission(Permission.photos);
    await _requestPermission(Permission.storage);*/
    try {
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(pickedFiles.map((file) => File(file.path)));
        });
      }
    } catch (e) {
      print("Image picker error: $e");
    }
  }

  Future<void> _captureImage() async {
    // await _requestPermission(Permission.camera);
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _selectedImages.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      print("Camera error: $e");
    }
  }

  void _showCustomSnackBar() {
    Get.showSnackbar(
      GetSnackBar(
        duration: Duration(seconds: 5),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.black.withOpacity(0.7),
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        messageText: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSnackBarRow(Icons.photo_library, _pickImages),
            _buildSnackBarRow(Icons.camera_alt, _captureImage),
          ],
        ),
      ),
    );
  }

  Widget _buildSnackBarRow(IconData icon, VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(icon: Icon(icon, color: Colors.white), onPressed: onPressed),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCBE3FB),
      appBar: AppBar(
        backgroundColor: Color(0xFFCBE3FB),
        title: Text('Image Selection Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: _showCustomSnackBar,
              icon: Icon(
                Icons.photo_camera_outlined,
                color: Colors.black,
                size: 50,
              ),
              //child: Text('Please select images'),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _selectedImages.isNotEmpty
                      ? Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _selectedImages.map((file) {
                            return Image.file(
                              file,
                              width: 200,
                              height: 400,
                              fit: BoxFit.cover,
                            );
                          }).toList(),
                        )
                      : Text('No images selected'),
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                if (_selectedImages.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select at least one image')),
                  );
                } else {
                  _selectedImages.forEach((file) => print(file.path));
                }
              },
              icon: Icon(
                Icons.thumb_up_alt_sharp,
                color: Colors.black,
                size: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum MediaType { image }

/*Future<void> _pickVideo() async {
    try {
      final pickedFiles = await _picker.pickMultipleMedia();
      if (pickedFiles != null) {
        for (final pickedFile in pickedFiles) {
          // Check if the picked file is a video
          if (pickedFile.path.toLowerCase().endsWith('.mp4') ||
              pickedFile.path.toLowerCase().endsWith('.mov') ||
              pickedFile.path.toLowerCase().endsWith('.avi')) {
            setState(() {
              _selectedVideos.add(File(pickedFile.path));
            });
            _initializeVideo(File(pickedFile.path));
          }
        }
      }
    } catch (e) {
      print("Video picker error: $e");
    }
  }*/
