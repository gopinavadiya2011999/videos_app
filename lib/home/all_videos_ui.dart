import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:nn_editz_app/home/add_video_view.dart';
import 'package:nn_editz_app/model/category_model.dart';
import 'package:nn_editz_app/video/show_video_full_screen.dart';
import 'package:nn_editz_app/model/video_list.dart';
import 'package:nn_editz_app/video/video_detail_screen.dart';
import 'package:nn_editz_app/video/video_player_stack.dart';
import 'package:shimmer/shimmer.dart';
import '../constant/color_constant.dart';
import '../video/custom_button.dart';
import '../widgets/inkwell.dart';

class AllVideosUi extends StatefulWidget {
  bool? fromCategory = false;
  final CategoryModel? category;

  AllVideosUi({Key? key, this.fromCategory = false, this.category}) : super(key: key);

  @override
  State<AllVideosUi> createState() => _HomeUIState();
}

class _HomeUIState extends State<AllVideosUi> {
  List<VideoList> videoList = [];
  List<VideoList> newVideoList = [];
  TextEditingController controller = TextEditingController();
  bool isDelete = false;
  bool isSearchTap = false;
  bool filterOn = false;
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
    newVideoList.clear();
    getVideoList();
  }

  Future<List<VideoList>> getVideoList() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('videos').get();
    videoList.clear();
    snapshot.docs.map((element) {
      videoList.add(VideoList(
          videoLink: element['video_link'],
          title: element['title'],
          videoThumbnail: element['video_thumbnail'],
          categoryImage: element['category_id'],
          uploadTime: element['upload_time'],
          videoId: element['video_id'],
          delete: element['delete'] == 'true' ? true : false));
    }).toList();
    videoList.sort((a, b) => b.uploadTime!.compareTo(a.uploadTime!));
    setState(() {});
    return videoList;
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
              filterOn?
                Expanded(
                  child: newVideoList.isEmpty&& filterOn
                      ? const Center(child: Text("No Videos Found"))
                      : SingleChildScrollView(
                          child: Column(
                            children: [const SizedBox(height: 20), ..._listView2(newVideoList: newVideoList)],
                          ),
                        ),
                ): Expanded(
                child: FutureBuilder<List<VideoList>>(
                  future: getVideoList(),
                  builder: (context, AsyncSnapshot<List<VideoList>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(color: ColorConstant.black00),
                      );
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    _addButton(),
                                    const SizedBox(width: 10),
                                    customButton(
                                        onTap: () {
                                          checkBox = !checkBox;
                                          setState(() {});

                                          if (snapshot.data!.where((element) => element.delete == true).toList().isNotEmpty) {
                                            deleteDialog(snapshot);
                                          }
                                        },
                                        buttonText: "delete",
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10))
                                  ],
                                )),
                            if (checkBox || snapshot.data!.where((element) => element.delete == true).toList().isNotEmpty)
                              Align(
                                alignment: AlignmentDirectional.topEnd,
                                child: Container(
                                    margin: const EdgeInsets.only(right: 20, top: 10),
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      activeColor: ColorConstant.grey2B,
                                      checkColor: ColorConstant.white,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                      side: BorderSide(color: ColorConstant.grey2B, width: 1.5),
                                      value: isDelete,
                                      onChanged: (value) {
                                        isDelete = value!;
                                        setState(() {});
                                        for (var element in snapshot.data!) {
                                          deleteAll(element);
                                        }
                                      },
                                    )),
                              ),
                            ..._listView(snapshot: snapshot)
                          ],
                        ),
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _addButton(),
                          const SizedBox(height: 10),
                          const Text("No Videos Found"),
                        ],
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ));
  }

  deleteAll(VideoList element) {
    if (isDelete) {
      FirebaseFirestore.instance.collection('videos').doc('${element.videoId}').set({
        'category_id': element.categoryImage,
        'video_link': element.videoLink,
        'video_thumbnail': element.videoThumbnail,
        'delete': 'true',
        'title': element.title,
        'video_id': element.videoId,
        'upload_time': element.uploadTime
      });
    } else {
      FirebaseFirestore.instance.collection('videos').doc('${element.videoId}').set({
        'category_id': element.categoryImage,
        'video_link': element.videoLink,
        'video_thumbnail': element.videoThumbnail,
        'delete': 'false',
        'title': element.title,
        'video_id': element.videoId,
        'upload_time': element.uploadTime
      }, SetOptions(merge: true));
    }
    setState(() {});
  }

  _addButton() {
    return customButton(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddVideoView(),
              ));
        },
        buttonText: "add",
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10));
  }

  playDownloadIcon({GestureTapCallback? onTap, required IconData icon}) {
    return inkWell(
      onTap: onTap,
      child: Container(margin: const EdgeInsets.only(top: 3, bottom: 3), child: Icon(icon, color: ColorConstant.grey2B, size: 24)),
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
                icon: Icons.download,
                onTap: () async {
                  final status = await Permission.photos.status;
                  if (status.isDenied) {
                    await Permission.storage.request();
                    await Permission.photos.request();
                    downloadWallpaper(videoList.videoLink!, context);
                  } else {
                    downloadWallpaper(videoList.videoLink!, context);
                  }

                  print("video link :: ${videoList.videoLink}");
                },
              ),
              playDownloadIcon(onTap: (){

                Navigator.push(context, MaterialPageRoute(builder: (context) => AddVideoView(videoList:videoList),));
              }, icon: Icons.edit),
            ],
          )
        ]),
      ),
    );
  }

  _listView({required AsyncSnapshot<List<VideoList>> snapshot}) {

    return List.generate( snapshot.data!.length, (index) {
      VideoList value =  snapshot.data![index];
      return  listData(value,context);

    });
  } _listView2({ required List<VideoList> newVideoList}) {

    return List.generate( newVideoList.length , (index) {
      VideoList value = newVideoList[index] ;
      return  listData(value,context);

    });
  }

  void onFullScreenClick({required VideoList videoLink}) {
    Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute(
      builder: (context) => VideoDetailScreen(videoList: videoLink)/*ShowVideoFullScreen(videoList: videoLink)*/,
    ));
    // SystemChrome.setPreferredOrientations(
    //   [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
    // );
  }

  _appbar() {
    return Container(
      decoration: BoxDecoration(
          color: ColorConstant.greyEA,
          borderRadius: const BorderRadius.only(bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
          boxShadow: [BoxShadow(offset: const Offset(0, 3), blurRadius: 5, spreadRadius: 2, color: Colors.grey.withOpacity(0.5))]),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!isSearchTap || widget.fromCategory == true)
            inkWell(
                onTap: () {
                  if (widget.fromCategory == true) {
                    Navigator.pop(context);
                  } else {
                    newVideoList.addAll(videoList);
                    isSearchTap = true;
                    filterOn = true;
                    setState(() {});
                  }
                },
                child: Icon(widget.fromCategory == true ? Icons.arrow_back : Icons.search, color: ColorConstant.grey2B, size: 24)),
          if (isSearchTap)
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  height: 40,
                  child: TextFormField(
                    controller: controller,
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.justify,
                    onChanged: (value) {
                      filterSearchResults(value);
                      if (value.isEmpty) {
                        filterOn=false;
                        newVideoList.clear();
                      }else{
                        filterOn=true;
                      }
                      setState(() {});
                    },
                    cursorColor: ColorConstant.black00,
                    decoration: InputDecoration(
                      hintText: "Enter title",
                        suffixIconConstraints: const BoxConstraints(maxHeight: 20, maxWidth: 30),
                        prefixIconConstraints: const BoxConstraints(maxHeight: 20, maxWidth: 30),
                        suffixIcon: inkWell(
                          onTap: () {
                            controller.clear();
                            newVideoList.clear();
                            filterOn = false;

                            setState(() {});
                          },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Icon(Icons.close, color: ColorConstant.grey2B, size: 20),
                            ),

                        ),
                        contentPadding: const EdgeInsets.only(left: 5, right: 5),
                        enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide(color: ColorConstant.black00), borderRadius: BorderRadius.circular(5)),
                        disabledBorder:
                            OutlineInputBorder(borderSide: BorderSide(color: ColorConstant.black00), borderRadius: BorderRadius.circular(5)),
                        focusedBorder:
                            OutlineInputBorder(borderSide: BorderSide(color: ColorConstant.black00), borderRadius: BorderRadius.circular(5)),
                        prefixIcon:
                            inkWell(
                                onTap: () {
                                  newVideoList.clear();
                                  filterOn = false;
                                  isSearchTap=false;
                                  controller.clear();
                                  setState(() {});
                                },
                                child: Padding(padding: const EdgeInsets.only(left: 6), child: Icon(Icons.search, color: ColorConstant.grey2B, size: 24))),
                        border: OutlineInputBorder(borderSide: BorderSide(color: ColorConstant.black00), borderRadius: BorderRadius.circular(5))),
                  )),
            ),
          Text(
            "NN EDITZ",
            style: TextStyle(fontFamily: 'Bebas Neue', fontSize: 20, color: ColorConstant.black00, fontWeight: FontWeight.w600, letterSpacing: 1),
          )
        ],
      ),
    );
  }

  Future<void> requestPermission() async {
    var status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      status = await Permission.storage.request();
      if (status != PermissionStatus.granted) {
        // Handle denied permission
      }
    }
  }
  showLoadingDialog({required String description,required BuildContext context}){
   showDialog(
     builder: (context) {
       return AlertDialog(
         shadowColor: Colors.transparent,
         backgroundColor: Colors.transparent,
         surfaceTintColor: Colors.transparent,
         content: Center(
           child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               Container(
                 padding: const EdgeInsets.all(20),
                 margin: const EdgeInsets.symmetric(horizontal: 30),
                 decoration: BoxDecoration(
                   color: ColorConstant.black00,
                   borderRadius: BorderRadius.circular(20),
                 ),
                 child: Center(
                   child: Column(
                     children: [
                       const CircularProgressIndicator(),
                       const SizedBox(height: 10,),
                       Text(description,style:  TextStyle(color: ColorConstant.white),)
                     ],
                   ),
                 ),
               ),
             ],
           ),
         ),
       );
     } , context: context,
    );
  }
  void downloadWallpaper(String imageUrl,BuildContext context) {
    showLoadingDialog(description: "Downloading...", context: context);
    FileDownloader.downloadFile(
        url: imageUrl,
        // name: **OPTIONAL**, //THE FILE NAME AFTER DOWNLOADING,
        onProgress: (fileName, progress) {
          debugPrint("FILE DOWNLOADING PROGRESS $progress");
        },
        onDownloadCompleted: (String path) {
          debugPrint('FILE DOWNLOADED TO PATH: $path');
          Navigator.of(context, rootNavigator: true).pop('dialog');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Video Downloaded!")));

        },
        onDownloadError: (String error) {
          debugPrint('DOWNLOAD ERROR: $error');
          Navigator.of(context, rootNavigator: true).pop('dialog');
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error Downloading Video!")));

        });
  }

  //
  // Future<void> downloadFile(String fileUrl) async {
  //   Dio dio = Dio();
  //
  //   try {
  //     // Get the temporary directory using path_provider
  //     Directory? appDocDir = await getDownloadsDirectory();
  //     String savePath = "${appDocDir!.path}/$fileUrl.mp4";
  //
  //     // Download the file using Dio
  //     await dio.download(fileUrl, savePath);
  //
  //     print("File downloaded to: $savePath");
  //   } catch (error) {
  //     print("Error downloading file: $error");
  //   }
  // }

  //  Future downloadFile(String downloadUrl) async {
  //   final Reference ref = FirebaseStorage.instance.refFromURL(downloadUrl);
  //   final dir = await getDownloadsDirectory();
  //   final file = File('$dir/${ref.name}');
  //   print("object------>>>>> $file");
  //   await ref.writeToFile(file);
  // }
  void filterSearchResults(String query) {
    List<VideoList> searchResults = [];

    if (query.isNotEmpty) {
      for (var item in videoList) {
        if (item.title!.toLowerCase().trimLeft().contains(query.toLowerCase())) {
          searchResults.add(item);
        }
      }
    setState(() {
      newVideoList.clear();
      print("search result :: ${searchResults.map((e) => e.title)}");

      newVideoList.addAll(searchResults.toList());
      print("search result ::22222 ${newVideoList.map((e) => e.title).toList()}");
    });
    }

  }

  void deleteDialog(AsyncSnapshot<List<VideoList>> snapshot, {String? text, GestureTapCallback? yesTap}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text ?? "Are you sure you want to delete selected Videos ?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: ColorConstant.grey2B, fontSize: 16, fontFamily: 'Montserrat', fontWeight: FontWeight.w400)),
            ],
          ),
          actions: [
            inkWell(
              onTap: () {
                isDelete = false;
                setState(() {});
                for (var element in snapshot.data!) {
                  FirebaseFirestore.instance.collection('videos').doc('${element.videoId}').set({
                    'delete': 'false',
                    'category_id': element.categoryImage,
                    'video_link': element.videoLink,
                    'video_thumbnail': element.videoThumbnail,
                    'title': element.title,
                    'video_id': element.videoId,
                    'upload_time': element.uploadTime
                  }, SetOptions(merge: true));
                }
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 5),
                child: Text(
                  'close'.toUpperCase(),
                  style: TextStyle(color: ColorConstant.grey2B, fontSize: 12, fontFamily: 'Montserrat', fontWeight: FontWeight.w400),
                ),
              ),
            ),
            inkWell(
              onTap: yesTap ??
                  () {
                    for (var value in snapshot.data!) {
                      if (value.delete == true) {
                        FirebaseFirestore.instance.collection('videos').doc('${value.videoId}').delete();

                        setState(() {});
                      }
                    }

                    isDelete = false;
                    setState(() {});
                    Navigator.pop(context);
                  },
              child: Container(
                margin: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 5),
                child: Text(
                  'Yes'.toUpperCase(),
                  style: TextStyle(color: ColorConstant.grey2B, fontSize: 12, fontFamily: 'Montserrat', fontWeight: FontWeight.w400),
                ),
              ),
            )
          ],
        );
      },
    );
  }
  listData(VideoList value,BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ColorConstant.greyEA,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(offset: const Offset(0, 3), blurRadius: 5, spreadRadius: 2, color: Colors.grey.withOpacity(0.5))]),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Stack(
        children: [
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                      height: MediaQuery.of(context).size.height / 4.5,
                      width: double.infinity,
                      child: ClipRRect(borderRadius: BorderRadius.circular(30), child: CachedNetworkImage(
                          imageUrl: value.videoThumbnail!,
                          placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey.withOpacity(0.5),

                              highlightColor: Colors.grey.withOpacity(0.2),
                              child: Container(color: ColorConstant.black00)),

                          fit: BoxFit.fill))),
                  Positioned(
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: ColorConstant.white.withOpacity(0.5),
                          shape: BoxShape.circle
                      ),
                      child: playDownloadIcon(onTap: () => onFullScreenClick(videoLink: value), icon: Icons.play_arrow),
                    ),
                  ),
                ],
              ),
              _rowView(videoList: value)
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      side: BorderSide(color: ColorConstant.white, width: 1.5),
                      value: value.delete,
                      onChanged: (data) {
                        FirebaseFirestore.instance.collection('videos').doc('${value.videoId}').set({
                          'delete': data.toString(),
                          'category_id': value.categoryImage,
                          'video_link': value.videoLink,
                          'video_thumbnail': value.videoThumbnail,
                          'title': value.title,
                          'video_id': value.videoId,
                          'upload_time': value.uploadTime
                        }, SetOptions(merge: true));
                        setState(() {});
                      },
                    )))
        ],
      ),
    );
  }

}


