import 'package:flutter/material.dart';
import 'package:serceerpod_app/constant/color_constant.dart';

import '../widgets/inkwell.dart';

customButton(
    {AlignmentGeometry? alignment,
    String? buttonText,
    GestureTapCallback? onTap,
    EdgeInsetsGeometry? padding}) {
  return inkWell(
    onTap: onTap,
    child: Align(
      alignment: alignment ?? Alignment.center,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: ColorConstant.grey2B,
        ),
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 18, horizontal: 40),
        child: Text(buttonText!.toUpperCase(),
            style: TextStyle(
                color: ColorConstant.white,
                fontSize: 12,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400)),
      ),
    ),
  );
}
