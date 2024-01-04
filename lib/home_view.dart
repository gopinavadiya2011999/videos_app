import 'package:bottom_nav_layout/bottom_nav_layout.dart';
import 'package:flutter/material.dart';
import 'package:nn_editz_app/home/all_videos_ui.dart';
import 'package:nn_editz_app/bottom_bar/home_main_view.dart';

import 'category/category_view.dart';
import 'constant/color_constant.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      primary: true,
      body: Theme(
        data: Theme.of(context).copyWith(canvasColor: ColorConstant.grey2B),
        child: BottomNavLayout(
          lazyLoadPages: true,
          pages: [
            (navKey) =>
                HomeMainView(navKey: navKey, initialPage: AllVideosUi()),
            (navKey) =>
                HomeMainView(navKey: navKey, initialPage: const CategoryView()),
          ],
          bottomNavigationBar: (currentIndex, onTap) => BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => onTap(index),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            unselectedLabelStyle: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 10,
            ),
            selectedLabelStyle: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 10,
            ),
            landscapeLayout:BottomNavigationBarLandscapeLayout.linear ,
            selectedItemColor: Colors.white,
            enableFeedback: false,
            unselectedItemColor: ColorConstant.white.withOpacity(0.5),
            // fixedColor: ColorConstant.greyEA,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            items: [
              bottomIcon(
                currentIndex: currentIndex,
                iconIndex: 0,
                label: 'Home',
                iconData: Icons.home,
              ),
              bottomIcon(
                currentIndex: currentIndex,
                iconIndex: 1,
                label: 'Category',
                iconData: Icons.category,
              ),
            ],
          ),
          // savePageState: true,
        ),
      ),
    );
  }
}

BottomNavigationBarItem bottomIcon({
  required int currentIndex,
  required int iconIndex,
  required String label,
  required IconData iconData,
}) {
  return BottomNavigationBarItem(
    icon: Container(
      padding: const EdgeInsets.only(bottom: 5, top: 5),
      child: Icon(iconData),
    ),
    label: label,
  );
}
