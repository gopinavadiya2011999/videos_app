import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serceerpod_app/model/video_list.dart';
import 'package:serceerpod_app/video/video_player_stack.dart';
import 'package:video_player/video_player.dart';

class ShowVideoFullScreen extends StatefulWidget {
  VideoList? videoList;
  ShowVideoFullScreen( {
        Key? key, this. videoList,
      }) : super(key: key);

  @override
  _ShowVideoFullScreenState createState() => _ShowVideoFullScreenState();
}

class _ShowVideoFullScreenState extends State<ShowVideoFullScreen> {
  VideoPlayerController? videoController;
  bool setVolumeIs = false;
  bool isFullScreen = false;
  bool isHideVideoButton = false;
  String showTime = "";
  @override
  void dispose() {
    if(videoController!=null){

      //videoController!.pause();
       videoController!.dispose();
    }
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  //  WidgetsBinding.instance.addPostFrameCallback((_){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: []);
      videoController = VideoPlayerController.file(
   File(  widget.videoList!.videoLink! )   // widget.videoList!.videoLink!
      )..initialize().then((_) {
        videoController!.addListener(
              () => setState(
                () =>
            videoController!.value.position.inSeconds,
          ),
        );
        videoController!.play();
      });
   // });

  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.pop(context);
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitDown,
          DeviceOrientation.portraitUp,
        ]);
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          left: false,
          right: false,
          top: false,
          child: _fullScreenView(),
        ),
      ),
    );
  }

  _fullScreenView() {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isHideVideoButton =
            isHideVideoButton == false ? true : false;
          });
        },
        child: AspectRatio(
          aspectRatio: videoController!.value.aspectRatio,
          child: VideoPlayerStack(
            videoList:widget.videoList,
            volumeButton: (){
              if (!setVolumeIs) {
                setVolumeIs = true;
                videoController!.setVolume(00);
                setState(() => {});
              } else {
                setVolumeIs = false;
                setState(() => {});
              }
            },
            controller: videoController!,
            fullScreenTap: () {
              Navigator.pop(context);
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitDown,
                DeviceOrientation.portraitUp,
              ]);
            },
            isHideVideoButton: isHideVideoButton,
            setVolumeIs: setVolumeIs,
          ),
        ),
      ),
    );
  }
}
