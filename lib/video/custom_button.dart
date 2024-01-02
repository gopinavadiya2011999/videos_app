import 'package:flutter/material.dart';
import 'package:serceerpod_app/constant/color_constant.dart';

import '../widgets/inkwell.dart';

customButton(
    {AlignmentGeometry? alignment,
    String? buttonText,
    GestureTapCallback? onTap,
      bool progress=false,
    GestureTapCallback? onLongPress,
    EdgeInsetsGeometry? padding}) {
  return inkWell(
    onTap: onTap,
    onLongPress:onLongPress ,
    child: Align(
      alignment: alignment ?? Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ColorConstant.grey2B,
        ),
        padding: padding,
        child: progress?Transform.scale(
            scale: 0.5,
            child: const CircularProgressIndicator(color: Colors.white)):Text(buttonText!.toUpperCase(),
            style: TextStyle(
                color: ColorConstant.white,
                fontSize: 12,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400)),
      ),
    ),
  );
}
