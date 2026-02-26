import 'package:flutter/material.dart';

class RouteTypeButton extends StatelessWidget {
  final String label;
  final String selectedLabel;
  final IconData icon;
  final ValueChanged<String> onSelected;

  const RouteTypeButton({
    super.key,
    required this.label,
    required this.selectedLabel,
    required this.icon,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool selected = selectedLabel == label;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: GestureDetector(
          onTap: () => onSelected(label),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF062015),
              borderRadius: BorderRadius.circular(16),
              border: selected
                  ? Border.all(
                      color: const Color(0xFFCEDF8F),
                      width: 2,
                    )
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color:
                      selected ? const Color(0xFFCEDF8F) : Colors.white70,
                  size: 22,
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected ? Colors.white : Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
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
