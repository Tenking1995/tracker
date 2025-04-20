import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker/values/colors.dart';

class SortToggleButton extends StatefulWidget {
  final void Function(String selected) onSortChanged;

  const SortToggleButton({
    super.key,
    required this.onSortChanged,
  });

  @override
  State<SortToggleButton> createState() => _SortToggleButtonState();
}

class _SortToggleButtonState extends State<SortToggleButton> {
  String selected = 'date';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton('date', Icons.calendar_today),
          _buildButton('amount', Icons.attach_money),
        ],
      ),
    );
  }

  Widget _buildButton(String value, IconData icon) {
    final isSelected = selected == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selected = value;
        });
        widget.onSortChanged(value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.black54,
              size: 10,
            ),
            const SizedBox(width: 6),
            Text(
              value.toUpperCase(),
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                  fontSize: 10,
                  color: isSelected ? Colors.white : Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
