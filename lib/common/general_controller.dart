import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker/api/expense_api.dart';
import 'package:tracker/helpers/storage_helper.dart';
import 'package:tracker/models/expense_category_model.dart';
import 'package:tracker/models/expense_model.dart';
import 'package:tracker/widgets/category_dropdown.dart';
import 'package:tracker/values/colors.dart';
import 'package:tracker/widgets/button.dart';
import 'package:tracker/widgets/textfield.dart';
import 'package:uuid/uuid.dart';

class GeneralController extends GetxController {
  GeneralController._();

  static GeneralController get to {
    if (!Get.isRegistered<GeneralController>()) {
      Get.put(GeneralController._(), permanent: true);
    }
    return Get.find<GeneralController>();
  }

  final RxList<ExpenseModel> rawExpensesList = <ExpenseModel>[].obs;
  final RxList<ExpenseModel> expensesList = <ExpenseModel>[].obs;
  final RxList<ExpenseCategoryModel> categories = <ExpenseCategoryModel>[].obs;
  final RxList<List<ExpenseModel>> groupedExpensesList = <List<ExpenseModel>>[].obs;
  final Rx<double> monthlyTarget = 0.0.obs;
  final Rx<String?> categoryFilter = Rx(null);

  final thisMonth = DateTime(DateTime.now().year, DateTime.now().month);
  final lastMonth = DateTime(DateTime.now().year, DateTime.now().month - 1);
  double get thisMonthExpenses {
    double thisMonthTotal = 0;
    for (var tx in rawExpensesList) {
      final txMonth = DateTime(tx.date.year, tx.date.month);

      if (txMonth == thisMonth) {
        thisMonthTotal += double.parse(tx.amount);
      }
    }
    return thisMonthTotal;
  }

  double get lastMonthExpenses {
    double lastMonthTotal = 0;
    for (var tx in rawExpensesList) {
      final txMonth = DateTime(tx.date.year, tx.date.month);

      if (txMonth == lastMonth) {
        lastMonthTotal += double.parse(tx.amount);
      }
    }
    return lastMonthTotal;
  }

  Map<String, double> get dailyTotals {
    Map<String, double> dailyTotalsMap = {};

    for (var tx in rawExpensesList) {
      String key = "${tx.date.year}-${tx.date.month}-${tx.date.day}";

      if (dailyTotalsMap.containsKey(key)) {
        dailyTotalsMap[key] = dailyTotalsMap[key]! + double.parse(tx.amount);
      } else {
        dailyTotalsMap[key] = double.parse(tx.amount);
      }
    }

    return dailyTotalsMap;
  }

  var isSortByDate = true;

  @override
  void onInit() {
    super.onInit();
    refreshExpensesList();
    getCategories();
  }

  Future<List<ExpenseModel>?> getExpensesList() async {
    var list = await StorageHelper.to.get('expenses');
    if (list is List<dynamic>) {
      String jsonString = jsonEncode(list);
      List<dynamic> decoded = jsonDecode(jsonString);
      List<Map<String, dynamic>> finalList = decoded.map((item) {
        return (item as Map).map((key, value) => MapEntry(key.toString(), value));
      }).toList();
      List<ExpenseModel> models = finalList.map((item) => ExpenseModel.fromJson(item)).toList();
      return isSortByDate
          ? (models..sort((a, b) => b.date.compareTo(a.date)))
          : (models..sort((a, b) => double.parse(b.amount).compareTo(double.parse(a.amount))));
    } else if (list is List<ExpenseModel>) {
      return isSortByDate ? (list..sort((a, b) => b.date.compareTo(a.date))) : (list..sort((a, b) => double.parse(b.amount).compareTo(double.parse(a.amount))));
    }
    return null;
  }

  Future getCategories() async {
    categories.value = await ExpenseApi.fetchExpenseCategories();
    update();
  }

  Future deleteExpense(ExpenseModel model) async {
    if (rawExpensesList.isNotEmpty == true) {
      rawExpensesList.removeWhere((item) => item.id == model.id);
      addExpenseList(rawExpensesList);
    }
  }

  Future addExpenseList(List<ExpenseModel> list) async {
    await StorageHelper.to.store('expenses', list);
    refreshExpensesList();
  }

  void refreshExpensesList() async {
    expensesList.value = (await getExpensesList() ?? []);
    rawExpensesList.value = (await getExpensesList() ?? []);
    expensesList.value = expensesList.where((item) => (categoryFilter.isNotEmpty == true) ? item.category == categoryFilter.value : true).toList();

    Map<String, List<ExpenseModel>> grouped = {};

    for (var item in expensesList) {
      String key = "${item.date.year}-${item.date.month}-${item.date.day}";

      if (grouped.containsKey(key)) {
        grouped[key]!.add(item);
      } else {
        grouped[key] = [item];
      }
    }

    groupedExpensesList.value = grouped.values.toList();
    update();
  }

  void addUpdateNewExpenses({bool isAdd = true, ExpenseModel? model}) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController noteController = TextEditingController();
    String? selectedCategory;

    if (isAdd == false) {
      titleController.text = model?.title ?? '';
      amountController.text = model?.amount ?? '';
      noteController.text = model?.note ?? '';
    }

    bool validate() {
      if (titleController.text.isEmpty) {
        showSimpleToast('Please enter title');
        return false;
      }
      if (selectedCategory == null) {
        showSimpleToast('Please select category');
        return false;
      }
      if (amountController.text.isEmpty) {
        showSimpleToast('Please enter an amount');
        return false;
      } else if (!RegExp(r'^\d+\.?\d{0,2}$').hasMatch(amountController.text)) {
        showSimpleToast('Enter a valid amount (e.g. 12.34)');
        return false;
      }
      return true;
    }

    await Get.dialog(
      Dialog(
        backgroundColor: Colors.black.withValues(alpha: 255.0 * 50 / 10),
        insetPadding: EdgeInsets.zero,
        child: Center(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.white,
                ),
                clipBehavior: Clip.hardEdge,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isAdd ? 'New Expense' : 'Expense',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 19,
                          color: AppColors.black1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    CategoryDropdown(
                      categories: categories,
                      onChanged: (selected) {
                        selectedCategory = selected?.name;
                      },
                    ),
                    SizedBox(height: 5),
                    appTextField(title: 'Title', controller: titleController),
                    SizedBox(height: 5),
                    appTextField(
                      title: 'Amount',
                      controller: amountController,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 5),
                    appTextField(title: 'Note', controller: noteController),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: appButton(
                            buttonText: isAdd ? 'Add' : 'Update',
                            onPressed: () async {
                              if (validate()) {
                                ExpenseModel expenseModel = ExpenseModel(
                                  id: Uuid().v4(),
                                  title: titleController.text,
                                  category: selectedCategory ?? '',
                                  amount: double.parse(amountController.text).toStringAsFixed(2),
                                  note: noteController.text,
                                  date: DateTime.now(),
                                );
                                List<ExpenseModel> list = await getExpensesList() ?? [];
                                list.add(expenseModel);
                                StorageHelper.to.store('expenses', list);
                                Get.back();
                              }
                            },
                            textColor: AppColors.white,
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: appButton(
                            buttonText: 'Cancel',
                            onPressed: Get.back,
                            color: AppColors.grey1.withAlpha(50),
                            textColor: AppColors.white,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Positioned(
                top: 20,
                right: 25,
                child: IconButton(
                  icon: FaIcon(FontAwesomeIcons.xmark, size: 17),
                  onPressed: Get.back,
                ),
              )
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
    refreshExpensesList();
  }

  void onUpdateMonthlyTarget() async {
    TextEditingController amountController = TextEditingController();

    amountController.text = (await StorageHelper.to.get('monthlyTarget') ?? '0').toString();

    bool validate() {
      if (amountController.text.isEmpty) {
        showSimpleToast('Please enter an amount');
        return false;
      } else if (!RegExp(r'^\d+\.?\d{0,2}$').hasMatch(amountController.text)) {
        showSimpleToast('Enter a valid amount (e.g. 12.34)');
        return false;
      }
      return true;
    }

    await Get.dialog(
      Dialog(
        backgroundColor: Colors.black.withValues(alpha: 255.0 * 50 / 10),
        insetPadding: EdgeInsets.zero,
        child: Center(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.white,
                ),
                clipBehavior: Clip.hardEdge,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Monthly Target',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                          fontSize: 19,
                          color: AppColors.black1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    appTextField(
                      title: 'Amount',
                      controller: amountController,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: appButton(
                            buttonText: 'Update',
                            onPressed: () async {
                              if (validate()) {
                                await StorageHelper.to.store('monthlyTarget', amountController.text);
                                monthlyTarget.value = double.parse(await StorageHelper.to.get('monthlyTarget') ?? '0');
                                Get.back();
                              }
                            },
                            textColor: AppColors.white,
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: appButton(
                            buttonText: 'Cancel',
                            onPressed: Get.back,
                            color: AppColors.grey1.withAlpha(50),
                            textColor: AppColors.white,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Positioned(
                top: 20,
                right: 25,
                child: IconButton(
                  icon: FaIcon(FontAwesomeIcons.xmark, size: 17),
                  onPressed: Get.back,
                ),
              )
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
    refreshExpensesList();
  }

  void updateSortType(bool isSortByDate) async {
    this.isSortByDate = isSortByDate;
    refreshExpensesList();
  }

  void setCategoryFilter(String? category) async {
    categoryFilter.value = category;
    refreshExpensesList();
  }

  void showSimpleToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  void showSimpleDialog({
    String? title,
    String? message,
    String? buttonTextOne,
    String? buttonTextTwo,
    Function()? buttonOneOnPressed,
    Function()? buttonTwoOnPressed,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.black.withValues(alpha: 255.0 * 50 / 10),
        insetPadding: EdgeInsets.zero,
        child: Center(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColors.white,
                ),
                clipBehavior: Clip.hardEdge,
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (title != null)
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 19,
                            color: AppColors.black1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (message != null) ...[
                      SizedBox(height: 15),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            fontSize: 16,
                            color: AppColors.black1,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (buttonTextOne != null)
                          Expanded(
                            child: appButton(
                              buttonText: buttonTextOne,
                              onPressed: buttonOneOnPressed,
                              textColor: AppColors.white,
                            ),
                          ),
                        if (buttonTextTwo != null) ...[
                          SizedBox(width: 5),
                          Expanded(
                            child: appButton(
                              buttonText: buttonTextTwo,
                              onPressed: buttonTwoOnPressed,
                              color: AppColors.grey1.withAlpha(50),
                              textColor: AppColors.white,
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Positioned(
                top: 20,
                right: 25,
                child: IconButton(
                  icon: FaIcon(FontAwesomeIcons.xmark, size: 17),
                  onPressed: Get.back,
                ),
              )
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
    refreshExpensesList();
  }
}
