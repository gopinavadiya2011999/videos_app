import 'package:flutter/material.dart';
import 'package:serceerpod_app/all_videos_ui.dart';
import 'package:serceerpod_app/color_constant.dart';
import 'package:serceerpod_app/model/video_list.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({Key? key}) : super(key: key);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
             backgroundColor: ColorConstant.greyEA,
    body: SafeArea(
      child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_appbar(),
              _listView()],
          ),
    )
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

  _listView() {
    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 2.4;
    final double itemWidth = size.width / 2;
    return GridView.count(
      crossAxisCount: 2 ,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      controller:  ScrollController(keepScrollOffset: false),
      childAspectRatio: (itemWidth / itemHeight),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.only(bottom:15,top: 15,left: 15,right: 15),
      children: videoList.map((badges) {
        return InkWell(
          
          onTap: (){

           Navigator.push(context,MaterialPageRoute(builder: (context) => AllVideosUi(),));
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

            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                badges.categoryImage!,
                fit: BoxFit.fill
              ),
            ),
          ),
        );
      }).toList(),
    );

  }
}
