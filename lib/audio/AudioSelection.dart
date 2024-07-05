import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class AudioSelection extends StatefulWidget {
  const AudioSelection({super.key});

  @override
  State<AudioSelection> createState() => AudioSelectionState();
}

class AudioSelectionState extends State<AudioSelection> {
  final List<File> _selectedAudios = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState _playerState = PlayerState.STOPPED;
  int _currentIndex = -1; // Track current playing audio index

  Future<void> _pickAudios() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
      );
      if (result != null) {
        setState(() {
          _selectedAudios
              .addAll(result.paths.map((path) => File(path!)).toList());
        });
      }
    } catch (e) {
      print("Audio picker error: $e");
    }
  }

  Future<void> _playAudio(File audioFile, int index) async {
    try {
      await _audioPlayer.play(DeviceFileSource(audioFile.path));
      setState(() {
        _playerState = PlayerState.PLAYING;
        _currentIndex = index; // Update current index
      });
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> _pauseAudio() async {
    try {
      await _audioPlayer.pause();
      setState(() {
        _playerState = PlayerState.PAUSED;
      });
    } catch (e) {
      print("Error pausing audio: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCBE3FB),
      appBar: AppBar(
        backgroundColor: Color(0xFFCBE3FB),
        title: Text('Audio Selection Page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: _pickAudios,
                icon: Icon(
                  Icons.audiotrack,
                  color: Colors.black,
                  size: 50,
                ),
              ),
              SizedBox(height: 20),
              _selectedAudios.isNotEmpty
                  ? Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _selectedAudios.asMap().entries.map((entry) {
                        int index = entry.key;
                        File file = entry.value;
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
                                          Icon(Icons.music_note),
                                          SizedBox(width: 5),
                                          Text(
                                            file.path.split('/').last,
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
                                        if (_currentIndex == index &&
                                            _playerState ==
                                                PlayerState.PLAYING) {
                                          _pauseAudio();
                                        } else {
                                          _playAudio(file, index);
                                        }
                                      },
                                      child: Icon(
                                        _currentIndex == index &&
                                                _playerState ==
                                                    PlayerState.PLAYING
                                            ? Icons.pause
                                            : Icons.play_arrow,
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
                  : Text('No audios selected'),
              IconButton(
                onPressed: () {
                  if (_selectedAudios.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Please select at least one audio')),
                    );
                  } else {
                    _selectedAudios.forEach((file) => print(file.path));
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

enum PlayerState {
  STOPPED,
  PLAYING,
  PAUSED,
}
