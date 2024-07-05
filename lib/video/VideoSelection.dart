import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class Videoselection extends StatefulWidget {
  const Videoselection({Key? key}) : super(key: key);

  @override
  State<Videoselection> createState() => _VideoselectionState();
}

class _VideoselectionState extends State<Videoselection> {
  final List<File> _selectedVideos = [];
  final List<VideoPlayerController> _controllers = [];
  final List<bool> _isPlaying = [];

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Future<void> _pickVideo() async {
    try {
      FilePickerResult? pickedFiles = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: true,
      );
      if (pickedFiles != null) {
        setState(() {
          _selectedVideos
              .addAll(pickedFiles.paths.map((path) => File(path!)).toList());
        });
        _initializeVideos(_selectedVideos);
      }
    } catch (e) {
      print("Video picker error: $e");
    }
  }

  void _initializeVideos(List<File> videoFiles) {
    _controllers.clear();
    _isPlaying.clear();
    videoFiles.forEach((videoFile) {
      VideoPlayerController controller = VideoPlayerController.file(videoFile);
      controller.initialize().then((_) {
        setState(() {});
      });
      _controllers.add(controller);
      _isPlaying.add(false);
    });
  }

  void _captureVideo() async {
    try {
      final pickedFile = await _picker.pickVideo(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _selectedVideos.add(File(pickedFile.path));
        });
        _initializeVideos(_selectedVideos);
      }
    } catch (e) {
      print("Camera error: $e");
    }
  }

  void _showCustomSnackBar() {
    Get.showSnackbar(
      GetSnackBar(
        duration: Duration(seconds: 3),
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
            _buildSnackBarRow(Icons.video_library, _pickVideo),
            _buildSnackBarRow(Icons.videocam, _captureVideo),
          ],
        ),
      ),
    );
  }

  Widget _buildSnackBarRow(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: onPressed,
    );
  }

  void _togglePlayPause(int index) {
    if (_controllers[index] != null) {
      setState(() {
        _isPlaying[index] = !_isPlaying[index];
        _isPlaying[index]
            ? _controllers[index].play()
            : _controllers[index].pause();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCBE3FB),
      appBar: AppBar(
        backgroundColor: Color(0xFFCBE3FB),
        title: Text('Video Selection Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              onPressed: _showCustomSnackBar,
              icon: Icon(
                Icons.video_camera_back,
                color: Colors.black,
                size: 50,
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _selectedVideos.isNotEmpty
                    ? _selectedVideos.asMap().entries.map((entry) {
                        int index = entry.key;
                        File videoFile = entry.value;
                        return Container(
                          width: 300,
                          height: 500,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              _controllers[index] != null &&
                                      _controllers[index].value.isInitialized
                                  ? AspectRatio(
                                      aspectRatio:
                                          _controllers[index].value.aspectRatio,
                                      child: VideoPlayer(_controllers[index]),
                                    )
                                  : Center(
                                      child: Image.asset(
                                        'assets/gif/folder-walk.gif',
                                        height: 200,
                                        width: 200,
                                      ),
                                    ),
                              IconButton(
                                onPressed: () {
                                  _togglePlayPause(index);
                                },
                                icon: Icon(
                                  _isPlaying[index]
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList()
                    : [Text('No videos selected')],
              ),
            ),
            IconButton(
              onPressed: () {
                if (_selectedVideos.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select at least one video'),
                    ),
                  );
                } else {
                  _selectedVideos.forEach((file) => print(file.path));
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
