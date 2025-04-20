import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tracker/common/general_controller.dart';
import 'package:tracker/screens/chart/widgets/daily_bar_chart.dart';
import 'package:tracker/values/colors.dart';
import 'package:tracker/widgets/appbar.dart';
import 'chart_index.dart';

class ChartPage extends GetResponsiveView<ChartController> {
  ChartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: transparentAppBarWithTitle(title: 'Chart'),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: DailyBarChart(dailyTotalsMap: GeneralController.to.dailyTotals),
      ),
    );
  }
}
