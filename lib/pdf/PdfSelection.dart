import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;

class Pdfselection extends StatefulWidget {
  const Pdfselection({Key? key}) : super(key: key);

  @override
  State<Pdfselection> createState() => _PdfselectionState();
}

class _PdfselectionState extends State<Pdfselection> {
  final List<File> _selectedpdf = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickdocument() async {
    try {
      final pickedFiles = await _picker.pickMultipleMedia();
      if (pickedFiles != null) {
        for (final pickedFile in pickedFiles) {
          // Check if the picked file is a pdf
          if (pickedFile.path.toLowerCase().endsWith('.pdf')) {
            setState(() {
              _selectedpdf.add(File(pickedFile.path));
            });
          }
        }
      }
    } catch (e) {
      print("pdf picker error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCBE3FB),
      appBar: AppBar(
        backgroundColor: Color(0xFFCBE3FB),
        title: Text('PDF Selection Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            IconButton(
              onPressed: _pickdocument,
              icon: Icon(
                Icons.document_scanner_outlined,
                color: Colors.black,
                size: 50,
              ),
            ),
            SizedBox(height: 20),
            _selectedpdf.isNotEmpty
                ? Column(
                    children: _selectedpdf.map((file) {
                      return GestureDetector(
                        onTap: () {
                          OpenFile.open(file.path);
                        },
                        child: Column(
                          children: [
                            Container(
                              color: Colors.white60,
                              width: 100,
                              height: 100,
                              child: Center(
                                child: Icon(
                                  Icons.picture_as_pdf,
                                  size: 50,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              path.basename(file.path),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  )
                : Text('No PDFs selected'),
            SizedBox(height: 20),
            IconButton(
              onPressed: () {
                if (_selectedpdf.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select at least one PDF'),
                    ),
                  );
                } else {
                  _selectedpdf.forEach((file) => print(file.path));
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
