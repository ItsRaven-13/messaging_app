import 'package:flutter/material.dart';

class AvatarPreview extends StatelessWidget {
  final String initials;
  final Color backgroundColor;

  const AvatarPreview({
    super.key,
    required this.initials,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          width: 1,
        ),
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        radius: 45,
        backgroundColor: backgroundColor,
        child: initials.isNotEmpty
            ? Text(initials, style: const TextStyle(fontSize: 30))
            : const Icon(Icons.add_a_photo_outlined, size: 40),
      ),
    );
  }
}
