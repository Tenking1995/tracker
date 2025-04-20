import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tracker/common/general_controller.dart';
import 'package:tracker/screens/home/widgets/sort_toggle_button.dart';
import 'package:tracker/values/colors.dart';
import 'package:tracker/widgets/appbar.dart';
import 'package:tracker/widgets/category_dropdown.dart';
import 'package:tracker/widgets/simple_category_dropdown.dart';
import 'home_index.dart';

class HomePage extends GetResponsiveView<HomeController> {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    bool isToday(DateTime date) {
      final now = DateTime.now();
      return date.year == now.year && date.month == now.month && date.day == now.day;
    }

    return Scaffold(
      appBar: transparentAppBarWithTitle(
        title: 'Expenses',
        isShowDefaultLeadingWidget: false,
      ),
      backgroundColor: AppColors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: controller.onFloatingButtonTapped,
        tooltip: 'Add',
        child: FaIcon(
          FontAwesomeIcons.plus,
          size: 17,
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => SmartRefresher(
            controller: controller.refreshController,
            onRefresh: controller.onRefresh,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5) + EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'RM ${GeneralController.to.lastMonthExpenses.toStringAsFixed(2)}',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: 19,
                                      color: AppColors.black1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  ' (Last Month)',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.orange1,
                                    ),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'RM ${GeneralController.to.thisMonthExpenses.toStringAsFixed(2)}',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: 22,
                                      color: AppColors.black1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                Text(
                                  ' (This Month)',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.orange1,
                                    ),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'Target: RM ${GeneralController.to.monthlyTarget.toStringAsFixed(2)}',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.black1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                IconButton(
                                  icon: FaIcon(
                                    FontAwesomeIcons.penToSquare,
                                    size: 17,
                                  ),
                                  onPressed: controller.onUpdateMonthlyTargetTapped,
                                ),
                              ],
                            ),
                            Text(
                              'Monthly Balance: RM ${controller.getThisMonthBalance()}',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.black1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.chartColumn,
                          size: 17,
                        ),
                        onPressed: controller.onChartIconTapped,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: SortToggleButton(
                          onSortChanged: (selected) {
                            if (selected == 'date') {
                              GeneralController.to.updateSortType(true);
                            } else if (selected == 'amount') {
                              GeneralController.to.updateSortType(false);
                            }
                          },
                        ),
                      ),
                      SimpleCategoryDropdown(
                        passedInSelectedValue: GeneralController.to.categoryFilter.value,
                        items: GeneralController.to.categories,
                        onChanged: (value) {
                          GeneralController.to.setCategoryFilter(value);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemBuilder: (context, index) {
                      var list = GeneralController.to.groupedExpensesList[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${DateFormat('d MMMM yyyy').format(list.first.date)} ${isToday(list.first.date) ? '(Today)' : ''}',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                fontSize: 14,
                                color: AppColors.orange1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 5),
                          ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var data = list[index];
                              return Bounceable(
                                onTap: () => controller.onExpenseItemTapped(data),
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  decoration: BoxDecoration(color: AppColors.orange1.withAlpha(50), borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Category: ${data.category}',
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.orange1,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              data.title,
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                  fontSize: 16,
                                                  color: AppColors.black1,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              DateFormat('d MMMM yyyy - h.mma').format(data.date),
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                  fontSize: 10,
                                                  color: AppColors.grey1,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              'RM ${data.amount}',
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                  fontSize: 24,
                                                  color: AppColors.black1,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            if (data.note?.isNotEmpty == true)
                                              Text(
                                                'Note: ${data.note}',
                                                style: GoogleFonts.lato(
                                                  textStyle: TextStyle(
                                                    fontSize: 14,
                                                    color: AppColors.red1,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: FaIcon(FontAwesomeIcons.xmark, size: 17),
                                        onPressed: () => controller.onExpenseItemDeleteTapped(data),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(height: 10),
                            itemCount: list.length,
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemCount: GeneralController.to.groupedExpensesList.length,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
