import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nn_editz_app/video/custom_button.dart';
import 'package:nn_editz_app/constant/color_constant.dart';
import '../widgets/inkwell.dart';
import 'add_category.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({Key? key}) : super(key: key);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  bool isDelete = false;
  bool checkBox = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.greyEA,
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _appbar(),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('categories')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(color: ColorConstant.black00),
                      );
                    } else if (snapshot.hasData &&
                        snapshot.data!.docs.isNotEmpty) {
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
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

                                          if (snapshot.data!.docs
                                              .where((element) =>
                                                  element['delete'] == "true")
                                              .toList()
                                              .isNotEmpty) {
                                            deleteDialog(snapshot);
                                          }
                                        },
                                        buttonText: "delete",
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10))
                                  ],
                                )),
                            if (checkBox ||
                                snapshot.data!.docs
                                    .where((element) =>
                                        element['delete'] == "true")
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
                                        for (var element
                                            in snapshot.data!.docs) {
                                          deleteAll(element);
                                        }
                                      },
                                    )),
                              ),
                            _listView(snapshot: snapshot)
                          ],
                        ),
                      );
                    } else {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _addButton(),
                          const SizedBox(height: 10),
                          const Text("No Category Found"),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }

  deleteAll(element) {
    if (isDelete) {
      FirebaseFirestore.instance
          .collection('categories')
          .doc('${element['category_id']}')
          .set({
        'delete': 'true',
        'category_name': element['category_name'],
        'category_image': element['category_image'],
        'category_id': element['category_id'],
        'upload_time': element['upload_time'],
      });
    } else {
      FirebaseFirestore.instance
          .collection('categories')
          .doc('${element['category_id']}')
          .set({
        'delete': 'false',
        'category_name': element['category_name'],
        'category_image': element['category_image'],
        'category_id': element['category_id'],
        'upload_time': element['upload_time'],
      }, SetOptions(merge: true));
    }
    setState(() {});
  }

  void deleteDialog(snapshot, {String? text, GestureTapCallback? yesTap}) {
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
                for (var element in snapshot.data!.docs) {
                  FirebaseFirestore.instance
                      .collection('categories')
                      .doc('${element['category_id']}')
                      .set({
                    'delete': 'false',
                    'category_name': element['category_name'],
                    'category_image': element['category_image'],
                    'category_id': element['category_id'],
                    'upload_time': element['upload_time'],
                  }, SetOptions(merge: true));
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
                    for (var value in snapshot.data!.docs) {
                      if (value['delete'] == 'true') {
                        FirebaseFirestore.instance
                            .collection('categories')
                            .doc('${value['category_id']}')
                            .delete();

                        setState(() {});
                      }
                    }

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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //Icon(Icons.search, color: ColorConstant.grey2B, size: 24),
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

  _listView({required AsyncSnapshot<QuerySnapshot<Object?>> snapshot}) {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.4;
    final double itemWidth = size.width / 2;
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 15,
      controller: ScrollController(keepScrollOffset: false),
      childAspectRatio: (itemWidth / itemHeight),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.only(bottom: 15, top: 10, left: 15, right: 15),
      children: snapshot.data!.docs /*categoryModel*/ .map((category) {
        return inkWell(
          onTap: () {
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) =>  AllVideosUi(fromCategory:true,category:category),
            //     ));
          },
          child: Container(
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
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                              category['category_image'],

                              fit: BoxFit.fill),
                        ),
                        Positioned(

                            child: Container(

                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                const Color(0xff000000).withOpacity(0.75), const Color(0xff000000).withOpacity(0)
                              ]
                            )
                          ),
                        )),
                        Positioned(
                          bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.only(bottom: 10,top: 5,right: 15,left: 15),

                                child: Text(category['category_name'], style: TextStyle(fontFamily: 'Montserrat',
                                    fontSize: 12, color: ColorConstant.white, fontWeight:
                                    FontWeight.w500),)))
                      ],
                    ),
                  ),
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
                            value: category['delete'] == 'true' ? true : false,
                            onChanged: (value) {
                              FirebaseFirestore.instance
                                  .collection('categories')
                                  .doc('${category['category_id']}')
                                  .set({
                                'delete': value.toString(),
                                'category_name': category['category_name'],
                                'category_image': category['category_image'],
                                'category_id': category['category_id'],
                                'upload_time': category['upload_time'],
                              }, SetOptions(merge: true));
                              setState(() {});
                            },
                          )))
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  _addButton() {
    return customButton(
        onTap: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddCategory(),
              ));
        },
        buttonText: "add",
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10));
  }
}
