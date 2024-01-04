import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:nn_editz_app/home_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

   late VideoPlayerController _controller;

   @override
  void initState() {
    super.initState();
    navigateToMain();
    _controller = VideoPlayerController.asset('assets/nn_editz.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.play();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.pause();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:/*SizedBox(
        width: double.infinity,
        height:double.infinity,
        child: Image.asset('assets/nn_editzz.gif',fit: BoxFit.fill))*/ _controller.value.isInitialized
        ? VideoPlayer(_controller)
        : const CircularProgressIndicator(color: Colors.white));
  }

  void navigateToMain() {
     Future.delayed(const Duration( seconds: 6)).then((value) {
       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeView()), (route) => false);
     });
  }
}
