import 'dart:convert';

import 'package:tracker/models/expense_category_model.dart';
import 'package:http/http.dart' as http;

class ExpenseApi {
  static Future<List<ExpenseCategoryModel>> fetchExpenseCategories() async {
    final url = Uri.parse('https://media.halogen.my/experiment/mobile/expenseCategories.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> categories = data['expenseCategories'];
      return categories.map((e) => ExpenseCategoryModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load expense categories');
    }
  }
}
