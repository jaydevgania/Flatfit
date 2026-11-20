/// FlatFit spacing, radii, and size constants.
///
/// Use these everywhere instead of magic numbers so the design stays
/// consistent and is easy to tweak globally.
class AppDimensions {
  const AppDimensions._();

  // ── Spacing scale (4-point grid) ──────────────────────────────────────
  static const double spacingXxs = 2;
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 12;
  static const double spacingLg = 16;
  static const double spacingXl = 20;
  static const double spacingXxl = 24;
  static const double spacing3xl = 32;
  static const double spacing4xl = 40;
  static const double spacing5xl = 48;
  static const double spacing6xl = 64;

  // ── Page padding ──────────────────────────────────────────────────────
  static const double pagePaddingHorizontal = 20;
  static const double pagePaddingVertical = 16;

  // ── Border radii ──────────────────────────────────────────────────────
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
  static const double radiusRound = 999;

  static const double cardRadius = 16;
  static const double buttonRadius = 12;
  static const double chipRadius = 20;
  static const double inputRadius = 12;
  static const double bottomSheetRadius = 24;

  // ── Elevation ─────────────────────────────────────────────────────────
  static const double elevationNone = 0;
  static const double elevationLow = 2;
  static const double elevationMedium = 4;
  static const double elevationHigh = 8;

  // ── Tap target & component sizes ──────────────────────────────────────
  static const double minTapTarget = 48;
  static const double buttonHeight = 52;
  static const double buttonHeightSmall = 40;
  static const double inputHeight = 56;
  static const double bottomNavHeight = 64;
  static const double appBarHeight = 56;

  // ── Avatar sizes ──────────────────────────────────────────────────────
  static const double avatarSm = 32;
  static const double avatarMd = 48;
  static const double avatarLg = 72;
  static const double avatarXl = 96;
  static const double avatarXxl = 120;

  // ── Icon sizes ────────────────────────────────────────────────────────
  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;
  static const double iconXl = 32;

  // ── Misc ──────────────────────────────────────────────────────────────
  static const double dividerThickness = 1;
  static const double maxContentWidth = 600; // for tablet / web
}
