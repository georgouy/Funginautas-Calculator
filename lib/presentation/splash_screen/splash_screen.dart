import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _screenFadeAnimation;

  bool _isInitialized = false;
  String _loadingText = '';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Screen fade animation controller
    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Logo scale animation
    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: Curves.elasticOut,
    ));

    // Logo fade animation
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    // Screen fade out animation
    _screenFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start logo animation
    _logoAnimationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Hide system UI for immersive experience
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

      // Initialize localization services
      setState(() {
        _loadingText = 'Cargando idioma...';
      });
      await Future.delayed(const Duration(milliseconds: 500));

      // Initialize CVG calculation formulas
      setState(() {
        _loadingText = 'Inicializando calculadoras...';
      });
      await Future.delayed(const Duration(milliseconds: 500));

      // Load saved calculations
      setState(() {
        _loadingText = 'Cargando cálculos guardados...';
      });
      await Future.delayed(const Duration(milliseconds: 500));

      // Prepare mushroom imagery assets
      setState(() {
        _loadingText = 'Preparando recursos...';
      });
      await Future.delayed(const Duration(milliseconds: 500));

      // Mark initialization as complete
      setState(() {
        _isInitialized = true;
        _loadingText = 'Completado';
      });

      // Wait a moment before transitioning
      await Future.delayed(const Duration(milliseconds: 500));

      // Start fade out animation
      await _fadeAnimationController.forward();

      // Navigate to dashboard
      if (mounted) {
        // Restore system UI
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (error) {
      // Handle initialization errors gracefully
      setState(() {
        _loadingText = 'Error de inicialización';
      });

      // Wait and retry or proceed to dashboard
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    }
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _fadeAnimationController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: AnimatedBuilder(
        animation: _screenFadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _screenFadeAnimation.value,
            child: SafeArea(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryDark,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo section
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _logoAnimationController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _logoScaleAnimation.value,
                              child: Opacity(
                                opacity: _logoFadeAnimation.value,
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.primaryDark,
                                    border: Border.all(
                                      color: AppTheme.secondaryGold,
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppTheme.secondaryGold
                                            .withValues(alpha: 0.3),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomIconWidget(
                                          iconName: 'eco',
                                          color: AppTheme.secondaryGold,
                                          size: 80,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'FungiNautas',
                                          style: AppTheme
                                              .darkTheme.textTheme.titleMedium
                                              ?.copyWith(
                                            color: AppTheme.secondaryGold,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // Loading section
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Loading indicator
                          SizedBox(
                            width: 32,
                            height: 32,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.secondaryGold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Loading text
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Text(
                              _loadingText,
                              key: ValueKey(_loadingText),
                              style: AppTheme.darkTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.onSurfaceVariant,
                                letterSpacing: 0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Progress indicator
                          Container(
                            width: 200,
                            height: 2,
                            decoration: BoxDecoration(
                              color: AppTheme.borderSubtle,
                              borderRadius: BorderRadius.circular(1),
                            ),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              width: _isInitialized ? 200 : 50,
                              height: 2,
                              decoration: BoxDecoration(
                                color: AppTheme.secondaryGold,
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bottom spacing
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
