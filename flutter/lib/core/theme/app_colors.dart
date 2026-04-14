import 'package:flutter/material.dart';

/// Pulse color palette — ported from frontend/src/index.css CSS custom properties.
class AppColors {
  AppColors._();

  // ── Core ──
  static const Color background = Color(0xFF050505);
  static const Color surface = Color(0x0DFFFFFF); // rgba(255,255,255,0.05)
  static const Color surfaceHover = Color(0x1AFFFFFF); // rgba(255,255,255,0.1)
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFAAAAAA);
  static const Color danger = Color(0xFFFF4D4D);

  // ── Default accent colors (user-configurable) ──
  static const Color defaultAccentCyan = Color(0xFF865AA4);
  static const Color defaultAccentPink = Color(0xFFD01CFF);

  // ── Glass ──
  static const Color glassBackground = Color(0xA60F0F0F); // rgba(15,15,15,0.65)
  static const Color glassBorder = Color(0x1FFFFFFF); // rgba(255,255,255,0.12)
  static const Color glassFallback = Color(0xEB0F0F0F); // rgba(15,15,15,0.92)

  /// Compute a harmonious secondary color from a primary accent (port of getSecondaryColor).
  static Color computeSecondary(Color primary) {
    final HSLColor hsl = HSLColor.fromColor(primary);
    return HSLColor.fromAHSL(
      1.0,
      (hsl.hue + 40) % 360, // Shift hue by ~40 degrees
      (hsl.saturation * 1.1).clamp(0.0, 1.0),
      (hsl.lightness * 0.9).clamp(0.1, 0.9),
    ).toColor();
  }
}
