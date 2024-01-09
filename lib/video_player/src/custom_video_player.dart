
import 'package:flutter/material.dart';
import 'package:nn_editz_app/video_player/src/custom_video_player_controller.dart';
import 'package:nn_editz_app/video_player/src/embedded_video_player.dart';

class CustomVideoPlayer extends StatelessWidget {
  final CustomVideoPlayerController customVideoPlayerController;
  const CustomVideoPlayer({
    Key? key,
    required this.customVideoPlayerController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmbeddedVideoPlayer(
      isFullscreen: false,
      customVideoPlayerController: customVideoPlayerController,
    );
  }
}
