import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker/values/colors.dart';

Widget appButton({
  required String buttonText,
  Function()? onPressed,
  Color? color,
  Color? textColor,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color ?? AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5), // Rounded corners
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    ),
    onPressed: onPressed,
    child: Text(
      buttonText,
      style: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: 16,
          color: textColor ?? AppColors.black1,
        ),
      ),
      textAlign: TextAlign.center,
    ),
  );
}
