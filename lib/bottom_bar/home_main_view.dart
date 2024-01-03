import 'package:flutter/material.dart';

class HomeMainView extends StatelessWidget {
  const HomeMainView({Key? key, this.navKey, this.initialPage})
      : super(key: key);

  final GlobalKey<NavigatorState>? navKey;
  final Widget? initialPage;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navKey,
      observers: [
        HeroController(),
      ],
      onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => initialPage!),
    );
  }
}