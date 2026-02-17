import 'package:flutter/material.dart';

class DifficultyCard extends StatelessWidget {
  final String label;
  final String selectedLabel;
  final Color color;
  final ValueChanged<String> onSelected;

  const DifficultyCard({
    super.key,
    required this.label,
    required this.selectedLabel,
    required this.color,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool selected = selectedLabel == label;

    return GestureDetector(
      onTap: () => onSelected(label),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? color : const Color(0xFF062015),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
