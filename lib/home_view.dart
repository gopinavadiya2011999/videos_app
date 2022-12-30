
import 'package:bottom_nav_layout/bottom_nav_layout.dart';
import 'package:flutter/material.dart';
import 'package:serceerpod_app/all_videos_ui.dart';
import 'package:serceerpod_app/bottom_bar/home_main_view.dart';

import 'category_view.dart';
import 'color_constant.dart';

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
        data: Theme.of(context).copyWith(canvasColor:  ColorConstant.grey2B),
        child: BottomNavLayout(
          lazyLoadPages: true,
          pages: [
                (navKey) => HomeMainView(
              navKey: navKey,
              initialPage: const     AllVideosUi(),

            ),
                (navKey) => HomeMainView(
              navKey: navKey,
              initialPage: const   CategoryView(),
            ),

          ],
          bottomNavigationBar: (currentIndex, onTap) => BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) => onTap(index),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            unselectedLabelStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 10,
            ),
            selectedLabelStyle: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 10,
            ),
            unselectedItemColor:   ColorConstant.greyEA,
            fixedColor:  ColorConstant.greyEA,
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
          savePageState: true,
        ),
      ),
    )/*Scaffold(
      body: SafeArea(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor:  ColorConstant.grey2B),
        child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category),
                label: 'Category'
              ),
            ],
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            unselectedItemColor:   ColorConstant.greyEA,
            fixedColor:  ColorConstant.greyEA,
            iconSize: 24,
            onTap: _onItemTapped,
            elevation: 5),
      ),
    )*/;
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
      child:  Icon(iconData),
    ),
    label: label,
  );
}
