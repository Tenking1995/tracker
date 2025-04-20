import 'dart:convert';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tracker/common/general_controller.dart';
import 'package:tracker/models/expense_model.dart';
import 'package:tracker/values/pages.dart';

import 'home_index.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

class HomeController extends GetxController {
  final state = HomeState();
  final RefreshController refreshController = RefreshController(initialRefresh: false);
  bool isNeedRefresh = false;

  @override
  onReady() {
    getCategories();
    super.onInit();
  }

  onRefresh() {
    getCategories();
  }

  void getCategories() {
    GeneralController.to.getCategories();
    GeneralController.to.refreshExpensesList();
    refreshController.refreshCompleted(resetFooterState: true);
    update();
  }

  void onFloatingButtonTapped() {
    GeneralController.to.addUpdateNewExpenses();
  }

  void onExpenseItemTapped(ExpenseModel data) {
    GeneralController.to.addUpdateNewExpenses(isAdd: false, model: data);
  }

  void onExpenseItemDeleteTapped(ExpenseModel data) {
    GeneralController.to.showSimpleDialog(
      title: 'Confirmation',
      message: 'Are you sure want to delete this expense?',
      buttonTextOne: 'Yes',
      buttonTextTwo: 'No',
      buttonOneOnPressed: () {
        GeneralController.to.deleteExpense(data);
        Get.back();
      },
      buttonTwoOnPressed: Get.back,
    );
  }

  void onChartIconTapped() {
    Get.toNamed(AppRoutes.chart);
  }

  void onUpdateMonthlyTargetTapped() {
    GeneralController.to.onUpdateMonthlyTarget();
  }

  String getThisMonthBalance() {
    return (GeneralController.to.thisMonthExpenses - GeneralController.to.monthlyTarget.value).toStringAsFixed(2);
  }
}
