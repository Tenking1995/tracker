import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker/models/expense_category_model.dart';
import 'package:tracker/values/colors.dart';

class CategoryDropdown extends StatefulWidget {
  final List<ExpenseCategoryModel> categories;
  final Function(ExpenseCategoryModel?) onChanged;

  const CategoryDropdown({
    required this.categories,
    required this.onChanged,
    super.key,
  });

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  ExpenseCategoryModel? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ExpenseCategoryModel>(
      value: selectedCategory,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelText: 'Select Category',
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
        // fillColor: Colors.grey.shade100,
      ),
      icon: const Icon(Icons.keyboard_arrow_down),
      isExpanded: true,
      items: widget.categories.map((cat) {
        return DropdownMenuItem(
          value: cat,
          child: Row(
            children: [
              Text(
                cat.name,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: 14,
                    color: AppColors.grey1,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCategory = value;
        });
        widget.onChanged(value);
      },
    );
  }
}
