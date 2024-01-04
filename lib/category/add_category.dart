import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nn_editz_app/constant/flutter_toast.dart';
import 'package:nn_editz_app/home/add_video_view.dart';
import 'package:nn_editz_app/video/custom_button.dart';
import 'package:nn_editz_app/widgets/capitalize_sentence.dart';
import 'package:nn_editz_app/widgets/custom_text_field.dart';
import 'package:uuid/uuid.dart';
import '../constant/color_constant.dart';
import '../widgets/inkwell.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController categoryNameController = TextEditingController();
bool isCatLoading=false;
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.greyEA,
      body: SafeArea(
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
                  customTextField(
                      hintText: 'Category  Title',
                      labelText: 'Enter category title',
                      controller: categoryNameController),
                  const SizedBox(height: 20),
                  customButton(
                      padding: const EdgeInsets.symmetric(horizontal: 40,vertical:18),
                      buttonText: 'Pick Image',
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        dismissKeyboard(context);
                        image =
                            await picker.pickImage(source: ImageSource.gallery);
                        setState(() {});
                      }),
                  if (image != null) const SizedBox(height: 20),
                  if (image != null)
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 150,
                        width: 150,
                        child: Image.file(File(image!.path), fit: BoxFit.fill),
                      ),
                    ),
                  const SizedBox(height: 20),
                  customButton(
                    padding: EdgeInsets.symmetric(horizontal: 40,vertical: isCatLoading?8:18),
                    progress: isCatLoading,
                    buttonText: "Add Category",
                    onTap: () async {
                      dismissKeyboard(context);
                      if (categoryNameController.text.isEmpty) {
                        showBottomLongToast('Please enter category name');
                      } else if (image == null) {
                        showBottomLongToast('Please select category image');
                      } else {
                        isCatLoading =true;
                        setState(() {

                        });
                        Uuid uuid = const Uuid();

                        var time = uuid.v4() +
                            DateTime.now().millisecondsSinceEpoch.toString();
                        String imageDownloadURL = await uploadFile(File(image!.path),'catImage/$time.jpg');
                        FirebaseFirestore.instance
                            .collection('categories')
                            .doc(time)
                            .set({
                          'delete': 'false',
                          'category_name': capitalizeAllSentence(
                                  categoryNameController.text.trim())
                              .toString(),
                          'category_image': imageDownloadURL,
                          'category_id': time,
                          'upload_time':
                              DateTime.now().millisecondsSinceEpoch.toString()
                        }, SetOptions(merge: true));
                        isCatLoading=false;
                        setState(() {});
                        Navigator.pop(context);

                        showBottomLongToast('Category Added Successfully!');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
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
