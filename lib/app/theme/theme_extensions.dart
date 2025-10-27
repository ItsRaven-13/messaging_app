import 'package:flutter/material.dart';
import 'package:messaging_app/app/theme/app_colors.dart';

extension ThemeExtras on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
