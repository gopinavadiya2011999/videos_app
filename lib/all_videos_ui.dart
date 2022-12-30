import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:serceerpod_app/show_video_full_screen.dart';
import 'package:serceerpod_app/model/video_list.dart';

import 'color_constant.dart';

class AllVideosUi extends StatefulWidget {
  const AllVideosUi({Key? key}) : super(key: key);

  @override
  State<AllVideosUi> createState() => _HomeUIState();
}

class _HomeUIState extends State<AllVideosUi> {
  // String getVideoTime({required String videoLink}) {
  //   videoController = VideoPlayerController.network(
  //       videoLink
  //   )..initialize().then((_) {
  //
  //     videoController!.addListener(
  //           () => setState(
  //             () =>
  //         videoController!.value.position.inSeconds,
  //       ),
  //     );
  //     // https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4
  //     setState(() => {});
  //   });
  //   print("%%%%%%% #${videoController!.value.position}");
  //
  //   Duration duration = videoController!.value.position;
  //   String twoDigits(int n) => n.toString().padLeft(2, "0");
  //   String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  //   String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  //
  //   return duration.inHours == 0
  //       ? "$twoDigitMinutes:$twoDigitSeconds"
  //       : "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.greyEA,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _appbar(),
              Expanded(
                child: SingleChildScrollView(

                  child: Column(children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("All Videos",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                color: ColorConstant.black00,
                                fontWeight: FontWeight.w500,
                              )),
                          InkWell(
                              onTap: () async {
                                final ImagePicker _picker = ImagePicker();
                                final XFile? image = await _picker.pickVideo(source: ImageSource.gallery);

                                print("image:: ${image!.path}");
                              //  final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
                              },
                              child: Icon(Icons.add,size: 24,color: ColorConstant.grey2B))
                        ],
                      ),
                    ),
                    _listView()
                  ],),
                ),
              )
            ],
          ),
        ));
  }

  playDownloadIcon({GestureTapCallback? onTap, required IconData icon}) {
    return InkWell(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.only(top: 3, bottom: 3),
          child: Icon(icon, color: ColorConstant.grey2B, size: 24)),
    );
  }

  _rowView({required VideoList videoList}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: IntrinsicHeight(
        child: Row(children: [
          Flexible(
            child: Text(
              videoList.title!,
              style: const TextStyle(fontFamily: 'Montserrat'),
            ),
          ),
          VerticalDivider(thickness: 1.5, color: ColorConstant.grey2B),
          Column(
            children: [
              playDownloadIcon(
                  onTap: () => onFullScreenClick(videoLink: videoList),
                  icon: Icons.play_arrow),
              playDownloadIcon(icon: Icons.download),
            ],
          )
        ]),
      ),
    );
  }

  _listView() {
    return  ListView.builder(
      shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 10),
      itemCount: videoList.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
              color: ColorConstant.greyEA,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 3),
                    blurRadius: 5,
                    spreadRadius: 2,
                    color: Colors.grey.withOpacity(0.5))
              ]),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              InkWell(
                  onTap: () => onFullScreenClick(videoLink: videoList[index]),
                  child: SizedBox(
                      width: double.infinity,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(videoList[index].categoryImage!,
                              fit: BoxFit.fill)))),
              // Text(
              //   getVideoTime(videoLink: videoList[index].videoLink!),
              //   style: const TextStyle(
              //     fontSize: 12,
              //     fontWeight: FontWeight.w500,
              //   )),
              _rowView(videoList: videoList[index])
            ],
          ),
        );
      },
    );
  }

  void onFullScreenClick({required VideoList videoLink}) {
    Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute(
      builder: (context) => ShowVideoFullScreen(videoList: videoLink),
    ))
        .then((value) {
      value;
    });
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
    );
  }

  _appbar() {
    return Container(
      decoration: BoxDecoration(
          color: ColorConstant.greyEA,
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 3),
                blurRadius: 5,
                spreadRadius: 2,
                color: Colors.grey.withOpacity(0.5))
          ]),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.search, color: ColorConstant.grey2B, size: 24),
          Text(
            "NN EDITZ",
            style: TextStyle(
                fontFamily: 'Bebas Neue',
                fontSize: 20,
                color: ColorConstant.black00,
                fontWeight: FontWeight.w600,
                letterSpacing: 1),
          )
        ],
      ),
    );
  }
}
