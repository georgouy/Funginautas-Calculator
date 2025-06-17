import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/language_settings/language_settings.dart';
import '../presentation/dashboard/dashboard.dart';
import '../presentation/cvg_calculator/cvg_calculator.dart';
import '../presentation/calculation_history/calculation_history.dart';
import '../presentation/lc_calculator/lc_calculator.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String dashboard = '/dashboard';
  static const String cvgCalculator = '/cvg-calculator';
  static const String lcCalculator = '/lc-calculator';
  static const String languageSettings = '/language-settings';
  static const String calculationHistory = '/calculation-history';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    dashboard: (context) => const Dashboard(),
    cvgCalculator: (context) => const CvgCalculator(),
    lcCalculator: (context) => const LcCalculator(),
    languageSettings: (context) => const LanguageSettings(),
    calculationHistory: (context) => const CalculationHistory(),
  };
}
