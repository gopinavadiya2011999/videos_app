
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nn_editz_app/constant/color_constant.dart';
import 'package:nn_editz_app/model/video_list.dart';


class VideoDetailScreen extends StatefulWidget {
  final VideoList videoList ;
  const VideoDetailScreen({Key? key, required  this.videoList}) : super(key: key);

  @override
  State<VideoDetailScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<VideoDetailScreen> {
   VideoPlayerController? _videoPlayerController,
      _videoPlayerController2,
      _videoPlayerController3;

   CustomVideoPlayerController ?_customVideoPlayerController;
  late CustomVideoPlayerWebController _customVideoPlayerWebController;

  final CustomVideoPlayerSettings _customVideoPlayerSettings =
  const CustomVideoPlayerSettings(showSeekButtons: true);

  // final CustomVideoPlayerWebSettings _customVideoPlayerWebSettings =
  // CustomVideoPlayerWebSettings(
  //   src: widget.videoList.videoLink!/*longVideo*/,
  // );

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network(
        /*'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'*/widget.videoList.videoLink!,
    )..initialize().then((value) => setState(() {}));
    // _videoPlayerController2 = VideoPlayerController.network(video240);
    // _videoPlayerController3 = VideoPlayerController.network(video480);
    if(_videoPlayerController!=null){

    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController!,
      customVideoPlayerSettings: _customVideoPlayerSettings,
      // additionalVideoSources: {
      //   "240p": _videoPlayerController2,
      //   "480p": _videoPlayerController3,
      //   "720p": _videoPlayerController,
      // },
    );
    _customVideoPlayerController!.videoPlayerController.play();
    }

   // _customVideoPlayerWebController = CustomVideoPlayerWebController(
   //   webVideoPlayerSettings: _customVideoPlayerWebSettings,
    //);
  }

  @override
  void dispose() {
    _customVideoPlayerController!.videoPlayerController.pause();
    _customVideoPlayerController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // navigationBar: const CupertinoNavigationBar(
      //   middle: Text("Appinio Video Player"),
      // ),
      body: SafeArea(
        child:  SizedBox(
          width: double.infinity,
          height: double.infinity,
          child:_customVideoPlayerController==null?Center(child: CircularProgressIndicator(color: ColorConstant.black00)): CustomVideoPlayer(
            customVideoPlayerController: _customVideoPlayerController!,
          ),
        ),
      ),
    );
  }
}

// String videoUrlLandscape =
//     "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";
// String videoUrlPortrait =
//     'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4';
// String longVideo =
//     "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
//
// String video720 =
//     "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_10mb.mp4";
//
// String video480 =
//     "https://www.sample-videos.com/video123/mp4/480/big_buck_bunny_480p_10mb.mp4";
//
// String video240 =
//     "https://www.sample-videos.com/video123/mp4/240/big_buck_bunny_240p_10mb.mp4";