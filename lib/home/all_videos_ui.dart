import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serceerpod_app/category/category_view.dart';
import 'package:serceerpod_app/home/add_video_view.dart';
import 'package:serceerpod_app/model/category_model.dart';
import 'package:serceerpod_app/video/show_video_full_screen.dart';
import 'package:serceerpod_app/model/video_list.dart';
import '../constant/color_constant.dart';
import '../video/custom_button.dart';
import '../widgets/inkwell.dart';

class AllVideosUi extends StatefulWidget {
  bool? fromCategory = false;
  final CategoryModel? category;

  AllVideosUi({Key? key, this.fromCategory = false, this.category})
      : super(key: key);

  @override
  State<AllVideosUi> createState() => _HomeUIState();
}

class _HomeUIState extends State<AllVideosUi> {
  // List<VideoList> videoList = [];

  bool isDelete = false;
  bool checkBox = false;

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
  initState() {
    super.initState();
    getVideoList();
  }

  getVideoList() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('videos').get();
    videoList.clear();
    snapshot.docs.map((element) {
      videoList.add(VideoList(
          videoLink: element['video_link'],
          title: element['title'],
          videoThumbnail: element['video_thumbnail'],
          categoryImage: element['category_image'],
          categoryName: element['category_name'],
          uploadTime: element['upload_time'],
          videoId: element['video_id'],
          delete: element['delete'] == 'true' ? true : false));
    }).toList();
    setState(() {});
  }

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
                child: videoList.isNotEmpty
                    ? StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('videos')
                          .snapshots(),
                      builder: (context, snapshot) {
                        return SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                    margin: const EdgeInsets.only(
                                        top: 20, left: 20, right: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            widget.category != null
                                                ? widget.category!.categoryName ??
                                                    ""
                                                : "All Videos",
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 16,
                                              color: ColorConstant.black00,
                                              fontWeight: FontWeight.w500,
                                            )),
                                        const Spacer(),
                                        _addButton(),
                                        const SizedBox(width: 10),
                                        customButton(
                                            onTap: () {
                                              checkBox = !checkBox;
                                              setState(() {});
                                              if (videoList
                                                  .where(
                                                      (element) => element.delete)
                                                  .toList()
                                                  .isNotEmpty) {
                                                deleteDialog();
                                              }
                                            },
                                            buttonText: "delete",
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 10)),
                                      ],
                                    )),
                                if (checkBox ||
                                    videoList
                                        .where((element) => element.delete)
                                        .toList()
                                        .isNotEmpty)
                                  Align(
                                    alignment: AlignmentDirectional.topEnd,
                                    child: Container(
                                        margin: const EdgeInsets.only(
                                            right: 20, top: 10),
                                        height: 24,
                                        width: 24,
                                        child: Checkbox(
                                          activeColor: ColorConstant.grey2B,
                                          checkColor: ColorConstant.white,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          side: BorderSide(
                                              color: ColorConstant.grey2B,
                                              width: 1.5),
                                          value: isDelete,
                                          onChanged: (value) {
                                            isDelete = value!;
                                            setState(() {});
                                            deleteAll();
                                          },
                                        )),
                                  ),
                                _listView()
                              ],
                            ),
                          );
                      }
                    )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _addButton(),
                          const SizedBox(height: 10),
                          const Text("No Videos Found"),
                        ],
                      ),
              )
            ],
          ),
        ));
  }

  deleteAll() {
    if (isDelete) {
      for (var element in videoList) {
        element.delete = true;
      }
      setState(() {});
    } else {
      for (var element in videoList) {
        element.delete = false;
      }
      setState(() {});
    }
  }

  _addButton() {
    return customButton(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddVideoView(),
              )).then((value) {
            getVideoList();
          });
        },
        buttonText: "add",
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10));
  }

  playDownloadIcon({GestureTapCallback? onTap, required IconData icon}) {
    return inkWell(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.only(top: 3, bottom: 3),
          child: Icon(icon, color: ColorConstant.grey2B, size: 24)),
    );
  }

  _rowView({required VideoList videoList}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: IntrinsicHeight(
        child: Row(children: [
          Expanded(
            child: Text(
              videoList.title!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
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
    return ListView.builder(
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
          child: Stack(
            children: [
              Column(
                children: [
                  inkWell(
                      onTap: () =>
                          onFullScreenClick(videoLink: videoList[index]),
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height / 4.5,
                          width: double.infinity,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.file(
                                  File(videoList[index].categoryImage!),
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
              if (checkBox)
                Positioned(
                    right: 15,
                    top: 15,
                    child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        height: 24,
                        decoration: BoxDecoration(
                          color: ColorConstant.grey2B,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        width: 24,
                        child: Checkbox(
                          activeColor: ColorConstant.greyEA,
                          checkColor: ColorConstant.grey2B,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          side: BorderSide(
                              color: ColorConstant.white, width: 1.5),
                          value: videoList[index].delete,
                          onChanged: (value) {
                            videoList[index].delete = value!;
                            setState(() {});
                          },
                        )))
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
          inkWell(
              onTap: () {
                if (widget.fromCategory == true) {
                  Navigator.pop(context);
                }
              },
              child: Icon(
                  widget.fromCategory == true ? Icons.arrow_back : Icons.search,
                  color: ColorConstant.grey2B,
                  size: 24)),
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

  void deleteDialog({String? text, GestureTapCallback? yesTap}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  text ??
                      "Are you sure you want to delete selected Categories ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ColorConstant.grey2B,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400)),
            ],
          ),
          actions: [
            inkWell(
              onTap: () {
                isDelete = false;
                setState(() {});
                for (var value in videoList) {
                  value.delete = false;
                  setState(() {});
                }
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.only(
                    left: 10, right: 10, top: 0, bottom: 5),
                child: Text(
                  'close'.toUpperCase(),
                  style: TextStyle(
                      color: ColorConstant.grey2B,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            inkWell(
              onTap: yesTap ??
                  () {
                    for (var value in videoList) {
                      if (value.delete) {
                        _delete(videoList: value);
                        setState(() {});
                      }
                    }
                    videoList.removeWhere((element) => element.delete == true);
                    isDelete = false;
                    setState(() {});
                    Navigator.pop(context);
                  },
              child: Container(
                margin: const EdgeInsets.only(
                    left: 10, right: 10, top: 0, bottom: 5),
                child: Text(
                  'Yes'.toUpperCase(),
                  style: TextStyle(
                      color: ColorConstant.grey2B,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  void _delete({required VideoList videoList}) async {
    VideoList videoLists = VideoList(
      videoId: videoList.videoId,
      categoryImage: videoList.categoryImage,
      categoryName: videoList.categoryName,
      title: videoList.title,
      videoLink: videoList.videoLink,
      videoThumbnail: videoList.videoThumbnail,
      uploadTime: videoList.uploadTime,
    );
    // await dbHelper.delete(videoLists);
    setState(() {});
  }
}
