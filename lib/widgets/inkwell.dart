import 'package:flutter/material.dart';

Widget inkWell({GestureTapCallback? onLongPress,GestureTapCallback? onTap, Widget? child}) {
  return InkWell(
onLongPress: onLongPress,
    hoverColor:Colors.transparent ,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    onTap: onTap,
    child: child,
  );
}