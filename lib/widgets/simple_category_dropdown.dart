import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker/models/expense_category_model.dart';
import 'package:tracker/values/colors.dart';

class SimpleCategoryDropdown extends StatefulWidget {
  final List<ExpenseCategoryModel> items;
  final String? passedInSelectedValue;
  final void Function(String?) onChanged;

  const SimpleCategoryDropdown({
    required this.items,
    required this.onChanged,
    this.passedInSelectedValue,
    super.key,
  });

  @override
  State<SimpleCategoryDropdown> createState() => _SimpleCategoryDropdownState();
}

class _SimpleCategoryDropdownState extends State<SimpleCategoryDropdown> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.passedInSelectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.orange1.withAlpha(50),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.orange1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              hint: Text(
                "Sort by",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: 10,
                    color: AppColors.orange1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              isExpanded: false,
              icon: const Icon(Icons.arrow_drop_down, color: AppColors.orange1),
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 10,
                  color: AppColors.orange1,
                ),
              ),
              dropdownColor: Colors.white,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue;
                });
                widget.onChanged(newValue!);
              },
              items: widget.items.map((ExpenseCategoryModel value) {
                return DropdownMenuItem<String>(
                  value: value.name,
                  child: Text(value.name),
                );
              }).toList(),
            ),
          ),
        ),
        if (selectedValue != null)
          IconButton(
            icon: const Icon(
              Icons.clear,
              size: 17,
              color: AppColors.orange1,
            ),
            onPressed: () {
              setState(() {
                selectedValue = null;
              });
              widget.onChanged(null);
            },
          ),
      ],
    );
  }
}
