import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.gold,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.gold,
      secondary: AppColors.emerald,
      tertiary: AppColors.coral,
      surface: AppColors.charcoal,
      onSurface: const Color(0xFFF3F0E8),
    );

    return _baseTheme(scheme).copyWith(
      scaffoldBackgroundColor: AppColors.ink,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.ink,
        foregroundColor: Color(0xFFF7F3EA),
        elevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: _navigationTheme(
        background: AppColors.charcoal,
        selected: AppColors.gold,
        unselected: const Color(0xFFB8BAC5),
      ),
      inputDecorationTheme: _inputTheme(
        fill: AppColors.graphite,
        border: AppColors.line,
        focus: AppColors.gold,
      ),
    );
  }

  static ThemeData get lightTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.goldDeep,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.goldDeep,
      secondary: AppColors.emerald,
      tertiary: AppColors.coral,
      surface: Colors.white,
      onSurface: AppColors.ink,
    );

    return _baseTheme(scheme).copyWith(
      scaffoldBackgroundColor: AppColors.paper,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.paper,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: _navigationTheme(
        background: Colors.white,
        selected: AppColors.goldDeep,
        unselected: const Color(0xFF5A5F6D),
      ),
      inputDecorationTheme: _inputTheme(
        fill: Colors.white,
        border: AppColors.paperLine,
        focus: AppColors.goldDeep,
      ),
    );
  }

  static ThemeData _baseTheme(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'Roboto',
      visualDensity: VisualDensity.adaptivePlatformDensity,
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withOpacity(0.35),
        thickness: 1,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          side: BorderSide(color: scheme.primary.withOpacity(0.55)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.primary;
          }
          return scheme.outline;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.outlineVariant.withOpacity(0.3),
        circularTrackColor: scheme.outlineVariant.withOpacity(0.25),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static NavigationBarThemeData _navigationTheme({
    required Color background,
    required Color selected,
    required Color unselected,
  }) {
    return NavigationBarThemeData(
      backgroundColor: background,
      elevation: 0,
      indicatorColor: selected.withOpacity(0.16),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final color = states.contains(WidgetState.selected) ? selected : unselected;
        return IconThemeData(color: color, size: 22);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final color = states.contains(WidgetState.selected) ? selected : unselected;
        return TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
        );
      }),
    );
  }

  static InputDecorationTheme _inputTheme({
    required Color fill,
    required Color border,
    required Color focus,
  }) {
    final outline = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: border),
    );

    return InputDecorationTheme(
      filled: true,
      fillColor: fill,
      border: outline,
      enabledBorder: outline,
      focusedBorder: outline.copyWith(
        borderSide: BorderSide(color: focus, width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }
}
