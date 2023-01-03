// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serceerpod_app/model/video_list.dart';
import 'package:video_player/video_player.dart';

import '../constant/color_constant.dart';
import '../widgets/inkwell.dart';

class VideoPlayerStack extends StatefulWidget {
  final VideoPlayerController? controller;
  final bool? isHideVideoButton;
  final bool? setVolumeIs;
  final VideoList? videoList;
  final GestureTapCallback? fullScreenTap;
  final GestureTapCallback? volumeButton;

  const VideoPlayerStack({
    Key? key,
    this.controller,
    this.isHideVideoButton,
    this.setVolumeIs,
    this.fullScreenTap,
    this.volumeButton,
    this.videoList,
  }) : super(key: key);

  @override
  _VideoPlayerStackState createState() => _VideoPlayerStackState();
}
bool openDetail=false;
class _VideoPlayerStackState extends State<VideoPlayerStack> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        VideoPlayer(widget.controller!),
          Positioned.fill(
            child: inkWell(
                onTap: (){
                  openDetail=!openDetail;
                  setState(() {

                  });
                },
                child: Container(color: openDetail?ColorConstant.black00.withOpacity(.5):ColorConstant.transparent)),
          ),
        if (openDetail)
        _showVideoProgressIndicator(
          controller: widget.controller!,
          isHideVideoButton: widget.isHideVideoButton!,
        ),
        if (openDetail)
        Positioned(
            top: 10,
            left: 20,
            right: 20,
            child: SafeArea(
                child: Row(
              children: [
                inkWell(
                  onTap: () {
                    Navigator.pop(context);
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitDown,
                      DeviceOrientation.portraitUp,
                    ]);
                  },
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    widget.videoList!.title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        color: Colors.white),
                  ),
                )
              ],
            ))),
       /* widget.isHideVideoButton == true
            ? Container() : */
               if (openDetail)
           Stack(
                children: [
                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: Container(
                  //     height: 32,
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(
                  //       border: Border.all(
                  //         width: double.infinity,
                  //         color: ColorConstant.transparent,
                  //       ),
                  //       color: const Color.fromRGBO(10, 0, 0, 0.6),
                  //     ),
                  //     //color: Colors.black,
                  //   ),
                  // ),
                  _showVideoButtonView(
                    controller: widget.controller!,
                    fullScreenTap: widget.fullScreenTap!,
                    setVolumeIs: widget.setVolumeIs!,
                  ),
                ],
              ),
        if(openDetail)
        GestureDetector(
          onTap: () {
            widget.controller!.value.isPlaying
                ? widget.controller!.pause()
                : widget.controller!.play();
            setState(() => {});
          },
          child: Align(
            alignment: Alignment.center,
            child: widget.controller!.value.isPlaying
                ? const Align(
                    alignment: Alignment.center,
                    child: SizedBox(height: 50, width: 50, child: Text("")),
                  )
                :
                //CircleAvatar(
                // radius: 22,
                //  backgroundColor: ColorConstant.grey2B,
                //child:

                Icon(
                    Icons.play_arrow,
                    size: 50,
                    color: ColorConstant.white,
                  ),
            //),
          ),
        ),
      ],
    );
  }

  _showVideoButtonView({
    required VideoPlayerController controller,
    required GestureTapCallback fullScreenTap,
    required bool setVolumeIs,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5, top: 5, left: 08, right: 08),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          children: [
            _showVideoButtonViewIcon(
              icon: controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              onTap: () {
                controller.value.isPlaying
                    ? controller.pause()
                    : controller.play();
                setState(() => {});
              },
            ),
            _showVideoButtonViewIcon(
              icon: Icons.skip_next_outlined,
              onTap: () {
                controller.seekTo(Duration(
                  seconds: controller.value.position.inSeconds + 10,
                ));
                setState(() => {});
              },
            ),
            Text(
              getVideoTime(widget.controller!.value.position),
              style: const TextStyle(color: Colors.white),
            ),
            const Spacer(),
            _showVideoButtonViewIcon(
                icon: widget.setVolumeIs != null && widget.setVolumeIs!
                    ? Icons.volume_off
                    : Icons.volume_down,
                onTap: widget.volumeButton),
            _showVideoButtonViewIcon(
              icon: Icons.fullscreen,
              onTap: fullScreenTap,
            ),
          ],
        ),
      ),
    );
  }

  _showVideoButtonViewIcon({IconData? icon, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Icon(icon,
              color: ColorConstant
                  .white) /*SvgPicture.asset(
          icon!,
          height: 20,
          width: 20,
          fit: BoxFit.fill,
          color: ColorConstant.white,
        ),*/
          ),
    );
  }

  String getVideoTime(Duration duration) {
    if (!mounted) {
      widget.controller!.addListener(
        () => setState(
          () => widget.controller!.value.position.inSeconds,
        ),
      );
    }

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return duration.inHours == 0
        ? "$twoDigitMinutes:$twoDigitSeconds"
        : "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  _showVideoProgressIndicator({
    required bool isHideVideoButton,
    required VideoPlayerController controller,
  }) {
    return Positioned(
      bottom: /*isHideVideoButton ? 00 : */34,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: 8,
          child: VideoProgressIndicator(
            controller,
            allowScrubbing: true,
            colors: VideoProgressColors(
              bufferedColor: ColorConstant.grey2B,
              playedColor: ColorConstant.white,
            ),
          ),
        ),
      ),
    );
  }
}
