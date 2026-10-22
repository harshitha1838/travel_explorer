import 'package:flutter/material.dart';

/// Visual identity of the app: a warm "travel journal" look in light and dark.
class AppColors {
  static const accent = Color(0xFFC65D3B); // terracotta
}

/// Heading font (falls back to the system serif if Georgia is missing).
const serif = 'Georgia';

/// Colours that change with light/dark mode. Use them as `context.card`,
/// `context.ink`, etc. so every screen follows the selected theme.
extension Palette on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  /// Surface colour of cards.
  Color get card => isDark ? const Color(0xFF241F1A) : Colors.white;

  /// Main text colour.
  Color get ink => isDark ? const Color(0xFFF3EBDD) : const Color(0xFF2B2118);

  /// Secondary text colour.
  Color get muted => isDark ? const Color(0xFFB5A998) : const Color(0xFF7A6E62);

  /// Thin border colour.
  Color get line => isDark ? const Color(0xFF3A332B) : const Color(0xFFE8DECB);

  /// Colour of a category, lightened a little in dark mode for contrast.
  Color cat(String category) {
    final base = _categoryBase(category);
    if (!isDark) return base;
    final hsl = HSLColor.fromColor(base);
    return hsl.withLightness((hsl.lightness + 0.15).clamp(0.0, 1.0).toDouble()).toColor();
  }
}

Color _categoryBase(String category) {
  switch (category) {
    case 'Beaches':
      return const Color(0xFF1F8A9E);
    case 'Mountains':
      return const Color(0xFF4C6A92);
    case 'Heritage':
      return const Color(0xFFC65D3B);
    case 'Adventure':
      return const Color(0xFFD98324);
    default:
      return AppColors.accent;
  }
}

String categoryEmoji(String category) {
  switch (category) {
    case 'Beaches':
      return '🏖️';
    case 'Mountains':
      return '⛰️';
    case 'Heritage':
      return '🏛️';
    case 'Adventure':
      return '🧗';
    default:
      return '🧭';
  }
}

/// Builds the light or dark [ThemeData].
ThemeData buildTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final paper = dark ? const Color(0xFF16130F) : const Color(0xFFFBF6EC);
  final ink = dark ? const Color(0xFFF3EBDD) : const Color(0xFF2B2118);
  final surface = dark ? const Color(0xFF1E1A15) : Colors.white;
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accent, brightness: brightness),
    scaffoldBackgroundColor: paper,
    appBarTheme: AppBarTheme(
      backgroundColor: paper,
      elevation: 0,
      scrolledUnderElevation: 0,
      foregroundColor: ink,
      titleTextStyle: TextStyle(
          fontFamily: serif,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: ink),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surface,
      indicatorColor: AppColors.accent.withAlpha(50),
    ),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: surface),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent, foregroundColor: Colors.white),
    ),
  );
}
