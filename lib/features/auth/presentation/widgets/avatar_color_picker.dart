import 'package:flutter/material.dart';

class AvatarColorPicker extends StatelessWidget {
  final List<Color> colors;
  final int selectedIndex;
  final ValueChanged<int> onColorSelected;

  const AvatarColorPicker({
    super.key,
    required this.colors,
    required this.selectedIndex,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      children: List.generate(colors.length, (index) {
        final color = colors[index];

        return GestureDetector(
          onTap: () => onColorSelected(index),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selectedIndex == index
                    ? Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.3)
                    : Colors.white,
                width: 1.5,
              ),
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: color,
              child: selectedIndex == index
                  ? Icon(
                      Icons.check,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.3),
                    )
                  : null,
            ),
          ),
        );
      }),
    );
  }
}
