import 'package:flutter/material.dart';

import 'tokens.dart';
import 'typography.dart';

abstract final class AppTheme {
  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: TColor.bg,
      canvasColor: TColor.bg,
      colorScheme: base.colorScheme.copyWith(
        brightness: Brightness.dark,
        primary: TColor.accent,
        onPrimary: TColor.textBright,
        secondary: TColor.accentLight,
        surface: TColor.surface,
        onSurface: TColor.text,
        outline: TColor.border,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: TColor.text,
        displayColor: TColor.textBright,
      ),
      // The prototype's ripples are accent tints, never the Material default.
      splashFactory: InkSparkle.splashFactory,
      highlightColor: const Color(0x1A9184D9),
      splashColor: const Color(0x1A9184D9),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: TColor.accent,
        selectionColor: Color(0x409184D9),
        selectionHandleColor: TColor.accent,
      ),
      sliderTheme: SliderThemeData(
        trackHeight: 2,
        activeTrackColor: TColor.accent,
        inactiveTrackColor: TColor.border,
        thumbColor: TColor.accentLight,
        overlayColor: const Color(0x1F9184D9),
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
      ),
      dividerTheme: const DividerThemeData(
        color: TColor.line,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        isDense: true,
        contentPadding: EdgeInsets.zero,
        hintStyle: TType.input.copyWith(color: TColor.textFaint),
      ),
    );
  }
}
