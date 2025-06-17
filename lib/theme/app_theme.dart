import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the mushroom cultivation application.
/// Implements Contemporary Scientific Minimalism with Organic Professional color scheme.
class AppTheme {
  AppTheme._();

  // Organic Professional Color Palette
  static const Color primaryDark = Color(0xFF1A1A1A); // Deep black background
  static const Color secondaryGold = Color(0xFFF4C430); // Warm golden yellow
  static const Color accentGold =
      Color(0xFFFFD700); // Bright gold for active states
  static const Color surfaceElevated =
      Color(0xFF2D2D2D); // Elevated surface color
  static const Color onSurfacePrimary = Color(0xFFE8E8E8); // Primary text color
  static const Color onSurfaceVariant = Color(0xFFB8B8B8); // Secondary text
  static const Color errorWarm = Color(0xFFFF6B6B); // Warm red for errors
  static const Color successTeal = Color(0xFF4ECDC4); // Muted teal for success
  static const Color borderSubtle = Color(0xFF404040); // Subtle border color
  static const Color disabledGray = Color(0xFF666666); // Inactive elements

  // Shadow colors with 20% opacity
  static const Color shadowDark = Color(0x33000000); // 20% opacity black
  static const Color shadowLight = Color(0x33FFFFFF); // 20% opacity white

  /// Dark theme (primary theme for mushroom cultivation professionals)
  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: secondaryGold,
          onPrimary: primaryDark,
          primaryContainer: accentGold,
          onPrimaryContainer: primaryDark,
          secondary: accentGold,
          onSecondary: primaryDark,
          secondaryContainer: secondaryGold,
          onSecondaryContainer: primaryDark,
          tertiary: successTeal,
          onTertiary: primaryDark,
          tertiaryContainer: successTeal,
          onTertiaryContainer: primaryDark,
          error: errorWarm,
          onError: primaryDark,
          surface: primaryDark,
          onSurface: onSurfacePrimary,
          onSurfaceVariant: onSurfaceVariant,
          outline: borderSubtle,
          outlineVariant: disabledGray,
          shadow: shadowDark,
          scrim: shadowDark,
          inverseSurface: onSurfacePrimary,
          onInverseSurface: primaryDark,
          inversePrimary: primaryDark,
          surfaceContainerHighest: surfaceElevated),
      scaffoldBackgroundColor: primaryDark,
      cardColor: surfaceElevated,
      dividerColor: borderSubtle,

      // AppBar theme for professional presentation
      appBarTheme: AppBarTheme(
          backgroundColor: primaryDark,
          foregroundColor: onSurfacePrimary,
          elevation: 2.0,
          shadowColor: shadowDark,
          titleTextStyle: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: onSurfacePrimary,
              letterSpacing: 0.15)),

      // Card theme with subtle elevation
      cardTheme: CardTheme(
          color: surfaceElevated,
          elevation: 2.0,
          shadowColor: shadowDark,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          margin: const EdgeInsets.all(8.0)),

      // Bottom navigation for calculator modes
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: surfaceElevated,
          selectedItemColor: secondaryGold,
          unselectedItemColor: onSurfaceVariant,
          elevation: 4.0,
          type: BottomNavigationBarType.fixed),

      // Contextual action button with morphing capability
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: secondaryGold,
          foregroundColor: primaryDark,
          elevation: 4.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0))),

      // Primary action buttons with subtle gradient capability
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              foregroundColor: primaryDark,
              backgroundColor: secondaryGold,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              elevation: 2.0,
              shadowColor: shadowDark,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5))),

      // Secondary action buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              foregroundColor: secondaryGold,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              side: const BorderSide(color: secondaryGold, width: 1.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5))),

      // Text buttons for tertiary actions
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: secondaryGold,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.25))),

      // Typography optimized for scientific calculations
      textTheme: _buildTextTheme(isDark: true),

      // Input decoration with contextual validation
      inputDecorationTheme: InputDecorationTheme(
          fillColor: surfaceElevated,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: borderSubtle, width: 1.0)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: borderSubtle, width: 1.0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: secondaryGold, width: 2.0)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: errorWarm, width: 1.0)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: errorWarm, width: 2.0)),
          labelStyle: GoogleFonts.inter(color: onSurfaceVariant, fontSize: 16, fontWeight: FontWeight.w400),
          hintStyle: GoogleFonts.inter(color: disabledGray, fontSize: 16, fontWeight: FontWeight.w400),
          errorStyle: GoogleFonts.inter(color: errorWarm, fontSize: 12, fontWeight: FontWeight.w400)),

      // Switch theme for settings
      switchTheme: SwitchThemeData(thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return secondaryGold;
        }
        return disabledGray;
      }), trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return secondaryGold.withValues(alpha: 0.3);
        }
        return borderSubtle;
      })),

      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return secondaryGold;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(primaryDark),
          side: const BorderSide(color: borderSubtle, width: 1.0)),

      // Radio button theme
      radioTheme: RadioThemeData(fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return secondaryGold;
        }
        return borderSubtle;
      })),

      // Progress indicators for calculations
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: secondaryGold, linearTrackColor: borderSubtle, circularTrackColor: borderSubtle),

      // Slider theme for input ranges
      sliderTheme: SliderThemeData(activeTrackColor: secondaryGold, thumbColor: secondaryGold, overlayColor: secondaryGold.withValues(alpha: 0.2), inactiveTrackColor: borderSubtle, valueIndicatorColor: secondaryGold, valueIndicatorTextStyle: GoogleFonts.jetBrainsMono(color: primaryDark, fontSize: 14, fontWeight: FontWeight.w500)),

      // Tab bar theme for calculator modes
      tabBarTheme: TabBarTheme(labelColor: secondaryGold, unselectedLabelColor: onSurfaceVariant, indicatorColor: secondaryGold, indicatorSize: TabBarIndicatorSize.tab, labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.5), unselectedLabelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.5)),

      // Tooltip theme for help information
      tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(color: surfaceElevated, borderRadius: BorderRadius.circular(8.0), border: Border.all(color: borderSubtle, width: 1.0), boxShadow: [
            BoxShadow(
                color: shadowDark, blurRadius: 4.0, offset: const Offset(0, 2)),
          ]),
          textStyle: GoogleFonts.inter(color: onSurfacePrimary, fontSize: 12, fontWeight: FontWeight.w400),
          padding: const EdgeInsets.all(12.0)),

      // Snackbar theme for feedback
      snackBarTheme: SnackBarThemeData(backgroundColor: surfaceElevated, contentTextStyle: GoogleFonts.inter(color: onSurfacePrimary, fontSize: 14, fontWeight: FontWeight.w400), actionTextColor: secondaryGold, behavior: SnackBarBehavior.floating, elevation: 4.0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),

      // Dialog theme for modals
      dialogTheme: DialogTheme(backgroundColor: surfaceElevated, elevation: 4.0, shadowColor: shadowDark, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)), titleTextStyle: GoogleFonts.inter(color: onSurfacePrimary, fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 0.15), contentTextStyle: GoogleFonts.inter(color: onSurfacePrimary, fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.25)),

      // Bottom sheet theme for progressive disclosure
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: surfaceElevated, elevation: 4.0, shadowColor: shadowDark, shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)))));

  /// Light theme (secondary theme for high-light environments)
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: primaryDark,
        onPrimary: onSurfacePrimary,
        primaryContainer: surfaceElevated,
        onPrimaryContainer: onSurfacePrimary,
        secondary: secondaryGold,
        onSecondary: primaryDark,
        secondaryContainer: accentGold,
        onSecondaryContainer: primaryDark,
        tertiary: successTeal,
        onTertiary: primaryDark,
        tertiaryContainer: successTeal,
        onTertiaryContainer: primaryDark,
        error: errorWarm,
        onError: onSurfacePrimary,
        surface: onSurfacePrimary,
        onSurface: primaryDark,
        onSurfaceVariant: surfaceElevated,
        outline: borderSubtle,
        outlineVariant: disabledGray,
        shadow: shadowLight,
        scrim: shadowLight,
        inverseSurface: primaryDark,
        onInverseSurface: onSurfacePrimary,
        inversePrimary: secondaryGold,
        surfaceContainerHighest: Color(0xFFF5F5F5)),
    scaffoldBackgroundColor: onSurfacePrimary,
    cardColor: const Color(0xFFF5F5F5),
    dividerColor: borderSubtle,

    // Similar theme configurations adapted for light mode
    appBarTheme: AppBarTheme(
        backgroundColor: onSurfacePrimary,
        foregroundColor: primaryDark,
        elevation: 2.0,
        shadowColor: shadowLight,
        titleTextStyle: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: primaryDark,
            letterSpacing: 0.15)),

    textTheme: _buildTextTheme(isDark: false), dialogTheme: DialogThemeData(backgroundColor: onSurfacePrimary),

    // Additional light theme configurations would follow the same pattern
    // but with inverted colors for optimal contrast in bright environments
  );

  /// Helper method to build text theme with scientific typography standards
  static TextTheme _buildTextTheme({required bool isDark}) {
    final Color textPrimary = isDark ? onSurfacePrimary : primaryDark;
    final Color textSecondary = isDark ? onSurfaceVariant : surfaceElevated;
    final Color textDisabled = isDark ? disabledGray : disabledGray;

    return TextTheme(
        // Display styles for large headings
        displayLarge: GoogleFonts.inter(
            fontSize: 57,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: -0.25,
            height: 1.12),
        displayMedium: GoogleFonts.inter(
            fontSize: 45,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: 0,
            height: 1.16),
        displaySmall: GoogleFonts.inter(
            fontSize: 36,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            letterSpacing: 0,
            height: 1.22),

        // Headline styles for section headers
        headlineLarge: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: 0,
            height: 1.25),
        headlineMedium: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: 0,
            height: 1.29),
        headlineSmall: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            letterSpacing: 0,
            height: 1.33),

        // Title styles for cards and dialogs
        titleLarge: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            letterSpacing: 0,
            height: 1.27),
        titleMedium: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            letterSpacing: 0.15,
            height: 1.50),
        titleSmall: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            letterSpacing: 0.1,
            height: 1.43),

        // Body text for content
        bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textPrimary,
            letterSpacing: 0.5,
            height: 1.50),
        bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: textPrimary,
            letterSpacing: 0.25,
            height: 1.43),
        bodySmall: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: textSecondary,
            letterSpacing: 0.4,
            height: 1.33),

        // Label styles for UI elements
        labelLarge: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            letterSpacing: 0.1,
            height: 1.43),
        labelMedium: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textSecondary,
            letterSpacing: 0.5,
            height: 1.33),
        labelSmall: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: textDisabled,
            letterSpacing: 0.5,
            height: 1.45));
  }

  /// Custom text styles for numerical data display
  static TextStyle dataDisplayStyle(
      {required bool isDark, required double fontSize}) {
    return GoogleFonts.jetBrainsMono(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: isDark ? onSurfacePrimary : primaryDark,
        letterSpacing: 0.5,
        height: 1.2);
  }

  /// Custom text style for calculation results
  static TextStyle resultStyle({required bool isDark}) {
    return GoogleFonts.jetBrainsMono(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: isDark ? accentGold : secondaryGold,
        letterSpacing: 0.25,
        height: 1.2);
  }

  /// Custom text style for input labels
  static TextStyle inputLabelStyle({required bool isDark}) {
    return GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isDark ? onSurfaceVariant : surfaceElevated,
        letterSpacing: 0.25,
        height: 1.43);
  }
}
