import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;

class Allmediaselection extends StatefulWidget {
  const Allmediaselection({super.key});

  @override
  State<Allmediaselection> createState() => _AllmediaselectionState();
}

class _AllmediaselectionState extends State<Allmediaselection> {
  final List<File> _selectedMedia = [];

  Future<void> _pickMedia() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: true,
      );
      if (result != null) {
        setState(() {
          _selectedMedia
              .addAll(result.paths.map((path) => File(path!)).toList());
        });
      }
    } catch (e) {
      print("Media picker error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCBE3FB),
      appBar: AppBar(
        backgroundColor: Color(0xFFCBE3FB),
        title: Text('All Media Selection'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: _pickMedia,
                icon: Icon(
                  Icons.perm_media_outlined,
                  color: Colors.black,
                  size: 50,
                ),
              ),
              SizedBox(height: 20),
              _selectedMedia.isNotEmpty
                  ? Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _selectedMedia.map((file) {
                        return Column(
                          children: [
                            Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(color: Colors.grey, width: 1),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.insert_drive_file),
                                          SizedBox(width: 5),
                                          Text(
                                            path.basename(file.path),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    GestureDetector(
                                      onTap: () {
                                        OpenFile.open(file.path);
                                      },
                                      child: Icon(
                                        Icons.open_in_new,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    )
                  : Text('No media selected'),
              IconButton(
                onPressed: () {
                  if (_selectedMedia.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please select at least one media file'),
                      ),
                    );
                  } else {
                    _selectedMedia.forEach((file) => print(file.path));
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
      ),
    );
  }
}
