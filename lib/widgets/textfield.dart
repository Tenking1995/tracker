import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker/values/colors.dart';

Widget appTextField({
  String? title,
  required TextEditingController controller,
  TextInputType? keyboardType,
}) {
  return TextField(
    keyboardType: keyboardType,
    inputFormatters: keyboardType == TextInputType.number || keyboardType == TextInputType.numberWithOptions()
        ? [
            FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
          ]
        : [],
    controller: controller,
    decoration: InputDecoration(
      labelText: title,
      labelStyle: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: 14,
          color: AppColors.grey1,
        ),
      ),
      floatingLabelStyle: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: 14,
          color: AppColors.primary,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: AppColors.primary),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      fillColor: Colors.white,
      filled: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    style: TextStyle(fontSize: 16, color: Colors.black),
  );
}
