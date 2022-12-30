import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serceerpod_app/color_constant.dart';

import 'home_view.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.black));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
            color: ColorConstant.black00,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            titleTextStyle: const TextStyle(color: Colors.black)),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
            color: ColorConstant.transparent,
            titleTextStyle: const TextStyle(color: Colors.black)),
      ),
      debugShowCheckedModeBanner: false,

      home: const HomeView(),
    );
  }
}

