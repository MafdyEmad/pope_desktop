import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:pope_desktop/core-old/share/app_api.dart';
import 'package:pope_desktop/core-old/theme/app_style.dart';

class DisplayAudio extends StatefulWidget {
  final String imagePath;

  const DisplayAudio({super.key, required this.imagePath});
  @override
  State<DisplayAudio> createState() => _DisplayAudioState();
}

class _DisplayAudioState extends State<DisplayAudio> {
  late final AudioPlayer audioPlayer;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () async {
                  audioPlayer.play(UrlSource('${API.explore}${widget.imagePath}'));
                },
              ),
              IconButton(
                icon: const Icon(Icons.pause),
                onPressed: () {
                  audioPlayer.pause();
                },
              ),
              IconButton(
                icon: const Icon(Icons.stop),
                onPressed: () {
                  audioPlayer.stop();
                },
              ),
            ],
          ),
          Text(
            widget.imagePath.split('/').last,
            maxLines: 4,
            style: AppStyle.bodyMedium(context),
          )
        ],
      ),
    );
  }
}
