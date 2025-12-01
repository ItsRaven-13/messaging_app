import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class PinThemeStyles {
  static PinTheme getDefaultTheme(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return PinTheme(
      width: 55,
      height: 55,
      textStyle: TextStyle(
        fontSize: 20,
        color: colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.primary),
      ),
    );
  }

  static PinTheme getFocusedTheme(BuildContext context) {
    final PinTheme defaultTheme = getDefaultTheme(context);
    return defaultTheme.copyWith(
      decoration: defaultTheme.decoration!.copyWith(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
    );
  }

  static PinTheme getSubmittedTheme(BuildContext context) {
    final PinTheme defaultTheme = getDefaultTheme(context);
    return defaultTheme.copyWith(
      decoration: defaultTheme.decoration!.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  static PinTheme getErrorTheme(BuildContext context) {
    final PinTheme defaultTheme = getDefaultTheme(context);
    return defaultTheme.copyWith(
      decoration: defaultTheme.decoration!.copyWith(
        border: Border.all(
          color: Theme.of(context).colorScheme.error,
          width: 2,
        ),
      ),
    );
  }
}
