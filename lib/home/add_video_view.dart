import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nn_editz_app/model/video_list.dart';
import 'package:nn_editz_app/widgets/capitalize_sentence.dart';
import 'package:nn_editz_app/constant/color_constant.dart';
import 'package:nn_editz_app/video/custom_button.dart';
import 'package:nn_editz_app/constant/flutter_toast.dart';
import 'package:nn_editz_app/model/category_model.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

import '../widgets/inkwell.dart';

class AddVideoView extends StatefulWidget {
  final VideoList ?videoList ;
   const AddVideoView({Key? key, this.videoList}) : super(key: key);

  @override
  State<AddVideoView> createState() => _AddVideoViewState();
}

class _AddVideoViewState extends State<AddVideoView> {
  final ImagePicker picker = ImagePicker();
  TextEditingController videoTitleController = TextEditingController();
  List<CategoryModel> categoryModel = [];
  CategoryModel? category;
  bool isUploading = false;
  XFile? image;
  XFile? video;
  VideoPlayerController? videoController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategory();
    print("999999:: ${widget.videoList!.title}");
    if(widget.videoList!=null ){
    videoTitleController.text=widget.videoList!.title??"";

    if(widget.videoList!.videoLink!=null){
      videoController = VideoPlayerController.networkUrl(Uri.parse( widget.videoList!.videoLink!)
      )
        ..initialize().then((_) {
          videoController!.addListener(
                () => setState(
                  () => videoController!
                  .value.position.inSeconds,
            ),
          );
        });
    }
    setState(() {});

        // videoController!.play();
        //  videoController!.setLooping(true);

    }
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoTitleController.clear();
    if (videoController != null) {
      videoController!.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.greyEA,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _appbar(),
            const SizedBox(height: 20),
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Video  Title'),
                    const SizedBox(height: 9),
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: ColorConstant.grey2B.withOpacity(0.2),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                                spreadRadius: 1)
                          ],
                          color: ColorConstant.greyEA,
                          borderRadius: BorderRadius.circular(5)),
                      child: TextFormField(
                        minLines: 4,
                        cursorColor: ColorConstant.black00,
                        maxLines: 8,
                        controller: videoTitleController,
                        style: TextStyle(
                            color: ColorConstant.black00,
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(8),
                            hintText: 'Enter video title',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                color: ColorConstant.grey2B,
                                fontSize: 12,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w400)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (categoryModel.isNotEmpty) _dropDownMenu(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        customButton(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            buttonText: widget.videoList!=null && widget.videoList!.videoThumbnail!=null?'Change Image': 'Pick Image',
                            onTap: () async {
                              image = await picker.pickImage(
                                  source: ImageSource.gallery);
                              setState(() {});
                            }),
                        customButton(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          buttonText:widget.videoList!=null && widget.videoList!.videoLink!=null?'Change Video': 'Pick Video',
                          onTap: () async {
                            video = await picker.pickVideo(
                                source: ImageSource.gallery);
                            setState(() {});
                            videoController = VideoPlayerController.file(File(
                                    video!.path) // widget.videoList!.videoLink!
                                )
                              ..initialize().then((_) {
                                videoController!.addListener(
                                  () => setState(
                                    () => videoController!
                                        .value.position.inSeconds,
                                  ),
                                );
                               // videoController!.play();
                              //  videoController!.setLooping(true);
                              });
                          },
                        ),
                      ],
                    ),
                    if (image != null || video != null || widget.videoList!.videoLink!=null || widget.videoList!.videoThumbnail!=null)
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (image != null|| widget.videoList!.videoThumbnail!=null)
                              image != null?    SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: Image.file(File(image!.path),
                                      fit: BoxFit.fill)):SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: Image.network(widget.videoList!.videoThumbnail!,
                                      fit: BoxFit.fill)),
                            if ((video != null|| widget.videoList!.videoLink!=null) && videoController!=null)
                              SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: VideoPlayer(videoController!))
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    customButton(
                      progress: isUploading,
                        padding: EdgeInsets.symmetric(vertical: isUploading?6:18,horizontal: 40),
                        buttonText:widget.videoList!=null && widget.videoList!.videoLink!=null?'Edit Video':  'Add video',
                        onTap: () async {
                          dismissKeyboard(context);
                          if (videoTitleController.text.isEmpty) {
                            showBottomLongToast('Please add video title');
                          } else if (video == null && widget.videoList==null &&widget.videoList!.videoLink==null) {
                            showBottomLongToast('Please add video');
                          } else if (image == null && widget.videoList==null &&widget.videoList!.videoThumbnail==null) {
                            showBottomLongToast('Please add image');
                          } else if (category == null) {
                            showBottomLongToast('Please select category');
                          } else {
                            isUploading =true;
                            setState(() {

                            });

                            Uuid uuid = const Uuid();


                            if(widget.videoList!=null){
                              String imageDownloadURL = image!=null?await uploadFile( File(image!.path), 'thumbnails/${widget.videoList!.videoId!}.jpg'):"";
                              String videoDownloadURL = video!=null?await uploadFile(File(video!.path), 'videos/${widget.videoList!.videoId!}.mp4'):"";
                              FirebaseFirestore.instance
                                  .collection('videos').doc(widget.videoList!.videoId!)
                                  .update({
                                'category_id': category!.categoryId,
                                'video_link': videoDownloadURL.isNotEmpty?videoDownloadURL:widget.videoList!.videoLink!,
                                'video_thumbnail': imageDownloadURL.isNotEmpty?imageDownloadURL:widget.videoList!.videoThumbnail!,
                                'delete': 'false',
                                'title': capitalizeAllSentence(
                                    videoTitleController.text.trim()),
                                'video_id': widget.videoList!.videoId!,
                                'upload_time': DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString()
                              });
                            }else{
                              var time = uuid.v4() +
                                  DateTime.now().millisecondsSinceEpoch.toString();
                              String imageDownloadURL = await uploadFile( File(image!.path), 'thumbnails/$time.jpg');
                              String videoDownloadURL = await uploadFile(File(video!.path), 'videos/$time.mp4');
                              FirebaseFirestore.instance
                                  .collection('videos').doc(time)
                                  .set({
                                'category_id': category!.categoryId,
                                'video_link': videoDownloadURL,
                                'video_thumbnail': imageDownloadURL,
                                'delete': 'false',
                                'title': capitalizeAllSentence(
                                    videoTitleController.text.trim()),
                                'video_id': time,
                                'upload_time': DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString()
                              });
                            }
                            isUploading=false;
                            setState(() {});
                            Navigator.pop(context);
                          }
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  getCategory() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    categoryModel.clear();
     snapshot.docs.map((element) {
        categoryModel.add(CategoryModel(
          categoryImage: element['category_image'],
          categoryName: element['category_name'],
          updateTime: element['upload_time'],
          categoryId: element['category_id'],
          delete: element['delete']=='true'?true:false));
    }).toList();
    setState(() {});
    if(categoryModel.isNotEmpty && categoryModel.where((element) => element.categoryId==widget.videoList!.categoryImage).isNotEmpty) {
      category = categoryModel.where((element) => element.categoryId==widget.videoList!.categoryImage).first;
    }
    setState(() {});

   }

  _dropDownMenu() {
    return Container(
      alignment: AlignmentDirectional.center,
      height: 43,
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: ColorConstant.grey2B.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
              spreadRadius: 1)
        ],
        color: ColorConstant.greyEA,
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton<CategoryModel>(
        menuMaxHeight: 300,

        underline: Container(),
        hint: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              category == null ? 'Select Category' : category!.categoryName!,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: ColorConstant.black00,
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        style: TextStyle(
            color: ColorConstant.greyEA,
            fontSize: 14,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500),
        value: category,
        isExpanded: true,
        iconSize: 50,

        dropdownColor: ColorConstant.greyEA,
        icon: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(6),
              bottomRight: Radius.circular(6),
            ),
            color: ColorConstant.greyEA,
          ),
          height: MediaQuery.of(context).size.height / 10,
          width: MediaQuery.of(context).size.width / 10,
          child: Icon(
            Icons.arrow_drop_down_rounded,
            color: ColorConstant.black00,
            size: MediaQuery.of(context).size.height / 20,
          ),
        ),
        alignment: AlignmentDirectional.bottomStart,
        onChanged: (CategoryModel? value) {
          setState(() {
            categoryModel.first.categoryName = value!.categoryName!;
            category = value;
          });
        },

        // The list of options
        items: categoryModel
            .map(
              (e) => DropdownMenuItem<CategoryModel>(
                value: e,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Text(
                      e.categoryName.toString(),
                      style: TextStyle(
                          color: ColorConstant.black00,
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
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
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back,
                  color: ColorConstant.grey2B, size: 24)),
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
Future<String> uploadFile(File file, String storagePath) async {
  try {
    Reference storageReference = FirebaseStorage.instance.ref().child(storagePath);
    UploadTask uploadTask = storageReference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask;

    // Get the download URL
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  } catch (e) {
    print('Error uploading file to Firebase Storage: $e');
    throw e; // Rethrow the error to indicate failure
  }
}
