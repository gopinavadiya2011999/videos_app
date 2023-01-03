import 'package:flutter/material.dart';

InkWell inkWell({GestureTapCallback? onTap, Widget? child}) {
  return InkWell(

    hoverColor:Colors.transparent ,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    onTap: onTap,
    child: child,
  );
}