import 'package:flutter/widgets.dart';

/// Nocturne design tokens — the single source of truth for colour, spacing,
/// radii and elevation. Never hard-code a hex or a raw px value elsewhere.
abstract final class TColor {
  // Ground & surfaces
  static const bg = Color(0xFF161826);
  static const bgCamera = Color(0xFF121422);
  static const surface = Color(0xFF1C1E2C);
  static const surfaceAlt = Color(0xFF232532);

  // Header band gradient (170deg)
  static const section0 = Color(0xFF262A60);
  static const section1 = Color(0xFF1E2140);
  static const section2 = Color(0xFF161826);

  // Text ramp
  static const text = Color(0xFFE9E9ED);
  static const textBright = Color(0xFFF3F5FE);
  static const textMuted = Color(0xFF9397AB);
  static const textFaint = Color(0xFF75798C);
  static const caption = Color(0xFFCFD3E5);

  // Lines & borders
  static const line = Color(0xFF292B31);
  static const border = Color(0xFF3F424D);

  // Accent
  static const accent = Color(0xFF9184D9);
  static const accentLight = Color(0xFFB5ABFC);
  static const accentSoft = Color(0xFFD2CEFD);
  static const accentDeep = Color(0xFF5D5294);
  static const accentMid = Color(0xFF796CBF);
  static const accentDark = Color(0xFF423A6A);

  static const neutral700 = Color(0xFF595D6C);

  /// Equalizer bar backdrop inside the logo mark.
  static const logoBar = Color(0xFF1A1C2B);

  /// Scrim behind the "Open in…" sheet.
  static const scrim = Color(0xA80C0D16); // rgba(12,13,22,0.66)
}

/// Compact spacing scale (0.7x density).
abstract final class TSpace {
  static const xs = 4.0;
  static const sm = 6.0;
  static const md = 8.0;
  static const lg = 11.0;
  static const xl = 14.0;
  static const xxl = 18.0;
  static const xxxl = 22.0;
  static const huge = 32.0;
}

abstract final class TRadius {
  static const thumb = 4.0;
  static const control = 8.0;
  static const tile = 10.0;
  static const logo = 13.0;
  static const card = 12.0;
  static const photo = 16.0;
  static const pill = 999.0;
}

/// Elevation on this ground = a 1px edge plus ambient darkness.
abstract final class TElevation {
  static List<BoxShadow> get sm => const [
        BoxShadow(color: TColor.border, spreadRadius: 1, blurRadius: 0),
      ];

  static List<BoxShadow> get md => const [
        BoxShadow(color: TColor.border, spreadRadius: 1, blurRadius: 0),
        BoxShadow(
          color: Color(0x80000000),
          blurRadius: 44,
          offset: Offset(0, 20),
        ),
      ];

  /// The player card: a brighter hairline over deep ambient shade.
  static List<BoxShadow> get card => const [
        BoxShadow(color: Color(0x33F3F5FE), spreadRadius: 1, blurRadius: 0),
        BoxShadow(
          color: Color(0x80000000),
          blurRadius: 30,
          offset: Offset(0, 12),
        ),
      ];

  /// The bottom sheet — the same shade thrown upward.
  static List<BoxShadow> get sheet => const [
        BoxShadow(color: TColor.border, spreadRadius: 1, blurRadius: 0),
        BoxShadow(
          color: Color(0x99000000),
          blurRadius: 44,
          offset: Offset(0, -18),
        ),
      ];
}

/// Gradients used in more than one place.
abstract final class TGradient {
  /// The header band behind Feed and Archive.
  static const header = LinearGradient(
    begin: Alignment(-0.17, -1),
    end: Alignment(0.17, 1),
    colors: [TColor.section0, TColor.section1, TColor.section2],
    stops: [0, 0.55, 1],
  );

  /// The logo mark, and the camera shutter's inner disc.
  static const logo = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [TColor.accentLight, TColor.accentMid, TColor.accentDark],
    stops: [0, 0.55, 1],
  );

  static const shutter = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [TColor.accentLight, TColor.accentMid],
  );

  /// The ring around a friend who has posted today.
  static const postedRim = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [TColor.accentLight, TColor.accentDeep],
  );

  /// Placeholder avatar fill.
  static const avatar = RadialGradient(
    center: Alignment(-0.4, -0.6),
    radius: 1.2,
    colors: [TColor.neutral700, Color(0xFF2B2741)],
    stops: [0, 0.7],
  );

  /// The "Open in…" sheet ground.
  static const sheet = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF20233A), TColor.surface],
    stops: [0, 0.4],
  );
}

/// Animation durations from the prototype.
abstract final class TMotion {
  static const equalizer = Duration(milliseconds: 800);
  static const equalizerSlow = Duration(seconds: 1);
  static const haloCta = Duration(milliseconds: 3200);
  static const haloShutter = Duration(milliseconds: 2600);
  static const driftPhoto = Duration(seconds: 26);
  static const driftOwn = Duration(seconds: 22);
  static const driftViewfinder = Duration(seconds: 18);
}
