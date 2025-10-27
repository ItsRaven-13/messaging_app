import 'package:flutter/material.dart';
import 'package:messaging_app/app/theme/theme_extensions.dart';

class AvatarColors {
  final BuildContext context;
  AvatarColors(this.context);

  List<Color> get colors => [
    context.colors.avatarBlue,
    context.colors.avatarPink,
    context.colors.avatarPurple,
    context.colors.avatarYellow,
  ];

  Color get random {
    final list = List<Color>.from(colors)..shuffle();
    return list.first;
  }
}
