import 'package:flutter/material.dart';

import '../AllMediaSelection/AllMediaSelection.dart';
import '../audio/AudioSelection.dart';
import '../image/ImageSelection.dart';
import '../pdf/PdfSelection.dart';
import '../video/VideoSelection.dart';
import 'homepage_card.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        //title: const Text('Click to Upload'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Positioned.fill(child: Image.asset('assets/gif/img.gif')),
          const Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      HomepageCard(
                        icons: Icons.photo_camera_back_outlined,
                        screen: Imageselection(),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      HomepageCard(
                        icons: Icons.video_camera_back_outlined,
                        screen: Videoselection(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      HomepageCard(
                        icons: Icons.library_music_outlined,
                        screen: AudioSelection(),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      HomepageCard(
                        icons: Icons.picture_as_pdf_outlined,
                        screen: Pdfselection(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      HomepageCard(
                        icons: Icons.museum_outlined,
                        screen: Allmediaselection(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
