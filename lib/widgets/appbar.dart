import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker/values/colors.dart';

AppBar transparentAppBar({
  Widget? title,
  Widget? leading,
  double? leadingWidth,
  List<Widget>? actions,
  bool isShowDefaultLeadingWidget = true,
  PreferredSizeWidget? bottom,
  Function()? leadingOnTap,
  Color? color,
}) {
  return AppBar(
    backgroundColor: AppColors.transparent,
    elevation: 0,
    title: title,
    scrolledUnderElevation: 0.0,
    leadingWidth: leadingWidth,
    leading: leading ??
        (isShowDefaultLeadingWidget
            ? IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.arrowLeft,
                  size: 17,
                  color: color,
                ),
                onPressed: leadingOnTap ?? Get.back,
              )
            : null),
    actions: actions,
    automaticallyImplyLeading: false,
    bottom: bottom,
  );
}

AppBar transparentAppBarWithTitle({
  required String title,
  TextStyle? style,
  Widget? leading,
  double? leadingWidth,
  List<Widget>? actions,
  bool isShowDefaultLeadingWidget = true,
  PreferredSizeWidget? bottom,
  Function()? leadingOnTap,
  Color? color,
}) {
  var mStyle = style ??
      GoogleFonts.lato(
        textStyle: style?.copyWith(color: color),
      );

  return transparentAppBar(
    title: isShowDefaultLeadingWidget ? Text(title, style: mStyle) : Center(child: Text(title, style: mStyle)),
    leading: leading,
    leadingWidth: leadingWidth,
    actions: actions,
    isShowDefaultLeadingWidget: isShowDefaultLeadingWidget,
    bottom: bottom,
    leadingOnTap: leadingOnTap,
    color: color,
  );
}
