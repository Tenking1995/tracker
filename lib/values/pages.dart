import 'package:get/get.dart';
import 'package:tracker/screens/home/home_index.dart';
import 'package:tracker/screens/chart/chart_index.dart';

class AppRoutes {
  static const initial = home;
  static const home = '/';
  static const chart = '/chart';
}

class AppPages {
  // ignore: constant_identifier_names
  static const INITIAL = AppRoutes.initial;
  static List<String> history = [];
  static const Transition _defaultTransition = Transition.fadeIn;
  static const Duration _defaultTransitionDuration = Duration(milliseconds: 300);

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
      binding: HomeBinding(),
      transition: _defaultTransition,
      transitionDuration: _defaultTransitionDuration,
    ),
    GetPage(
      name: AppRoutes.chart,
      page: () => ChartPage(),
      binding: ChartBinding(),
      transition: _defaultTransition,
      transitionDuration: _defaultTransitionDuration,
    ),
  ];
}
