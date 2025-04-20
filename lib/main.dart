import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tracker/common/general_controller.dart';
import 'package:tracker/values/colors.dart';
import 'package:tracker/values/pages.dart';

void main() async {
  await GetStorage.init();

  Get.put(GeneralController.to, permanent: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tracker',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: Colors.white,
        brightness: Brightness.light,
        highlightColor: Colors.white,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          focusColor: AppColors.primary,
          splashColor: AppColors.primary,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      enableLog: true,
    );
  }
}
