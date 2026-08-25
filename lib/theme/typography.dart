import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tokens.dart';

/// The three families: Bricolage Grotesque for display, Inter for UI,
/// JetBrains Mono for metadata. Sizes and tracking are final — match them.
abstract final class TType {
  static TextStyle _display(
    double size, {
    FontWeight weight = FontWeight.w600,
    required double tracking,
    double height = 1,
    Color color = TColor.textBright,
  }) =>
      GoogleFonts.bricolageGrotesque(
        fontSize: size,
        fontWeight: weight,
        // CSS letter-spacing is em-relative; Flutter's is absolute px.
        letterSpacing: tracking * size,
        height: height,
        color: color,
      );

  static TextStyle _ui(
    double size, {
    FontWeight weight = FontWeight.w400,
    double height = 1,
    required Color color,
  }) =>
      GoogleFonts.inter(
        fontSize: size,
        fontWeight: weight,
        height: height,
        color: color,
      );

  static TextStyle _mono(
    double size, {
    FontWeight weight = FontWeight.w400,
    required double tracking,
    double height = 1,
    required Color color,
  }) =>
      GoogleFonts.jetBrainsMono(
        fontSize: size,
        fontWeight: weight,
        letterSpacing: tracking * size,
        height: height,
        color: color,
      );

  // ── Display ───────────────────────────────────────────────────────────────
  /// The feed's date numeral.
  static TextStyle get dateXL => _display(54, tracking: -0.05, height: 0.86);

  /// Post author headline.
  static TextStyle get name => _display(26,
      tracking: -0.04, height: 0.9, color: TColor.text);

  /// Archive owner name, and the search headline's scale.
  static TextStyle get displayL => _display(30, tracking: -0.04, height: 0.95);

  /// "What's on / repeat today?"
  static TextStyle get question => _display(30, tracking: -0.035, height: 1.02);

  /// Sheet track title.
  static TextStyle get sheetTitle => _display(19, tracking: -0.03, height: 1.1);

  /// The streak count.
  static TextStyle get streak => _display(22,
      tracking: -0.03, color: TColor.accentSoft);

  /// Month/year beside the big date.
  static TextStyle get dateSide => _display(13,
      weight: FontWeight.w400, tracking: 0, height: 1.1, color: TColor.textMuted);

  /// Archive tile day number.
  static TextStyle get tileDay => _display(15,
      tracking: -0.03, color: Color(0xBFF3F5FE));

  /// The camera's translucent date stamp.
  static TextStyle get stamp => _display(30,
      tracking: -0.04, height: 0.9, color: Color(0x47F3F5FE));

  static TextStyle wordmark(double size) =>
      _display(size, tracking: -0.05, height: 0.9);

  // ── Body / UI ─────────────────────────────────────────────────────────────
  static TextStyle get body =>
      _ui(14, height: 1.5, color: TColor.caption);

  static TextStyle get rowTitle =>
      _ui(14, weight: FontWeight.w500, height: 1.15, color: TColor.text);

  static TextStyle get rowArtist =>
      _ui(11.5, height: 1, color: TColor.textMuted);

  static TextStyle get input =>
      _ui(13.5, height: 1.45, color: TColor.text);

  static TextStyle get button =>
      _ui(13, weight: FontWeight.w500, color: TColor.accentSoft);

  static TextStyle get buttonLarge =>
      _ui(15, weight: FontWeight.w500, color: TColor.accentSoft);

  static TextStyle get cta =>
      _ui(13.5, weight: FontWeight.w500, color: TColor.accentSoft);

  static TextStyle get serviceRow =>
      _ui(13.5, weight: FontWeight.w500, color: TColor.text);

  /// Player card title — on-photo, so it uses the bright ramp.
  static TextStyle get cardTitle =>
      _ui(12, weight: FontWeight.w500, height: 1.2, color: TColor.textBright);

  static TextStyle get cardArtist =>
      _ui(10, height: 1.2, color: const Color(0xB3F3F5FE));

  /// Archive tile song name — the 10px floor.
  static TextStyle get tileSong =>
      _ui(10, height: 1.15, color: const Color(0xE6F3F5FE));

  static TextStyle get mostPlayed =>
      _ui(11, height: 1.3, color: TColor.caption);

  // ── Mono / metadata ───────────────────────────────────────────────────────
  /// Weekday kicker above the date.
  static TextStyle get monoKicker => _mono(9.5,
      weight: FontWeight.w500, tracking: 0.16, color: TColor.accentLight);

  /// "YOU · JUST NOW".
  static TextStyle get monoNow => _mono(10,
      weight: FontWeight.w500, tracking: 0.14, color: TColor.accentLight);

  /// Bottom-bar and header nav labels.
  static TextStyle monoNav(Color color) =>
      _mono(9, weight: FontWeight.w500, tracking: 0.12, color: color);

  /// Top-row labels on Camera / Song / Compose.
  static TextStyle monoTop(Color color) =>
      _mono(10, weight: FontWeight.w500, tracking: 0.12, color: color);

  static TextStyle monoTopLight(Color color) =>
      _mono(10, tracking: 0.12, color: color);

  /// Section label: "DAY STREAK", "OPEN IN YOUR APP", "AUGUST", slider labels.
  static TextStyle monoLabel(Color color, {double size = 9}) =>
      _mono(size, weight: FontWeight.w500, tracking: 0.14, color: color);

  /// Friend rail name.
  static TextStyle monoFriend(Color color) =>
      _mono(10, weight: FontWeight.w500, tracking: 0, color: color);

  /// Post timestamp and track duration in the feed.
  static TextStyle monoMeta(Color color, {double size = 9.5}) =>
      _mono(size, tracking: 0, color: color);

  /// The location chip on a photo.
  static TextStyle get monoPlace => _mono(8.5,
      tracking: 0.1, color: const Color(0xCCF3F5FE));

  /// The centred placeholder label on a photo / viewfinder.
  static TextStyle monoPhoto(Color color, {double tracking = 0.14}) =>
      _mono(9.5, tracking: tracking, color: color);

  /// Slider value readouts and the footer's selected-track line.
  static TextStyle get monoValue =>
      _mono(9.5, tracking: 0, color: TColor.textMuted);

  static TextStyle get monoFooter =>
      _mono(10.5, tracking: 0, height: 1.4, color: TColor.textFaint);

  static TextStyle get monoHandle =>
      _mono(10.5, tracking: 0, color: TColor.textMuted);
}
