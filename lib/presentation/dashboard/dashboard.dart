import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/calculator_card_widget.dart';
import './widgets/language_selector_widget.dart';
import './widgets/recent_calculations_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String selectedLanguage = 'Spanish';

  // Mock recent calculations data
  final List<Map<String, dynamic>> recentCalculations = [
    {
      "id": 1,
      "type": "CVG",
      "input": "500g Coco Coir",
      "result": "Water: 1.25L, Vermiculite: 250g, Gypsum: 25g",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      "id": 2,
      "type": "LC",
      "input": "1L Water + Honey",
      "result": "Honey: 20g (2% ratio)",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
    },
  ];

  void _onLanguageChanged(String language) {
    setState(() {
      selectedLanguage = language;
    });
  }

  void _onCalculatorTap(String calculatorType) {
    HapticFeedback.lightImpact();

    if (calculatorType == 'CVG') {
      Navigator.pushNamed(context, '/cvg-calculator');
    } else if (calculatorType == 'LC') {
      Navigator.pushNamed(context, '/lc-calculator');
    }
  }

  void _onCalculatorLongPress(String calculatorType) {
    HapticFeedback.mediumImpact();
    _showQuickMenu(calculatorType);
  }

  void _showQuickMenu(String calculatorType) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '$calculatorType Calculator',
              style: AppTheme.darkTheme.textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'history',
                color: AppTheme.secondaryGold,
                size: 24,
              ),
              title: Text(
                'View Last Calculation',
                style: AppTheme.darkTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/calculation-history');
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'clear_all',
                color: AppTheme.errorWarm,
                size: 24,
              ),
              title: Text(
                'Clear History',
                style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.errorWarm,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _clearHistory();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _clearHistory() {
    setState(() {
      recentCalculations.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Calculation history cleared',
          style: AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        backgroundColor: AppTheme.surfaceElevated,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Refresh any cached data here
    });
  }

  void _deleteCalculation(int index) {
    setState(() {
      recentCalculations.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Calculation deleted',
          style: AppTheme.darkTheme.textTheme.bodyMedium,
        ),
        backgroundColor: AppTheme.surfaceElevated,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppTheme.secondaryGold,
          backgroundColor: AppTheme.surfaceElevated,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),

                  // Header with logo and language selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 12.w,
                            height: 12.w,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryDark,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: CustomIconWidget(
                                iconName: 'eco',
                                color: AppTheme.secondaryGold,
                                size: 8.w,
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'FungiNautas',
                                style: AppTheme.darkTheme.textTheme.titleLarge
                                    ?.copyWith(
                                  color: AppTheme.secondaryGold,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Calculator',
                                style: AppTheme.darkTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      LanguageSelectorWidget(
                        selectedLanguage: selectedLanguage,
                        onLanguageChanged: _onLanguageChanged,
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Welcome text
                  Text(
                    selectedLanguage == 'Spanish'
                        ? 'Calculadoras de Cultivo'
                        : selectedLanguage == 'English'
                            ? 'Cultivation Calculators'
                            : 'Calculadoras de Cultivo',
                    style:
                        AppTheme.darkTheme.textTheme.headlineMedium?.copyWith(
                      color: AppTheme.onSurfacePrimary,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  Text(
                    selectedLanguage == 'Spanish'
                        ? 'Herramientas precisas para el cultivo profesional de hongos'
                        : selectedLanguage == 'English'
                            ? 'Precise tools for professional mushroom cultivation'
                            : 'Ferramentas precisas para cultivo profissional de cogumelos',
                    style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  // Calculator cards
                  CalculatorCardWidget(
                    title: selectedLanguage == 'Spanish'
                        ? 'Calculadora CVG'
                        : selectedLanguage == 'English'
                            ? 'CVG Calculator'
                            : 'Calculadora CVG',
                    description: selectedLanguage == 'Spanish'
                        ? 'Calcula proporciones de coco coir, vermiculita y yeso'
                        : selectedLanguage == 'English'
                            ? 'Calculate coco coir, vermiculite and gypsum ratios'
                            : 'Calcule proporções de fibra de coco, vermiculita e gesso',
                    imageUrl:
                        'https://images.pexels.com/photos/4750270/pexels-photo-4750270.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                    calculatorType: 'CVG',
                    onTap: () => _onCalculatorTap('CVG'),
                    onLongPress: () => _onCalculatorLongPress('CVG'),
                  ),

                  SizedBox(height: 4.h),

                  CalculatorCardWidget(
                    title: selectedLanguage == 'Spanish'
                        ? 'Calculadora LC'
                        : selectedLanguage == 'English'
                            ? 'LC Calculator'
                            : 'Calculadora LC',
                    description: selectedLanguage == 'Spanish'
                        ? 'Calcula cultivos líquidos con miel o extracto de malta'
                        : selectedLanguage == 'English'
                            ? 'Calculate liquid cultures with honey or malt extract'
                            : 'Calcule culturas líquidas com mel ou extrato de malte',
                    imageUrl:
                        'https://images.pixabay.com/photo-2019/09/26/18/23/honey-4506835_1280.jpg',
                    calculatorType: 'LC',
                    onTap: () => _onCalculatorTap('LC'),
                    onLongPress: () => _onCalculatorLongPress('LC'),
                  ),

                  SizedBox(height: 4.h),

                  // Recent calculations section
                  if (recentCalculations.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedLanguage == 'Spanish'
                              ? 'Cálculos Recientes'
                              : selectedLanguage == 'English'
                                  ? 'Recent Calculations'
                                  : 'Cálculos Recentes',
                          style:
                              AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                            color: AppTheme.onSurfacePrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pushNamed(
                              context, '/calculation-history'),
                          child: Text(
                            selectedLanguage == 'Spanish'
                                ? 'Ver Todo'
                                : selectedLanguage == 'English'
                                    ? 'View All'
                                    : 'Ver Tudo',
                            style: AppTheme.darkTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.secondaryGold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    RecentCalculationsWidget(
                      calculations: recentCalculations,
                      onDelete: _deleteCalculation,
                      selectedLanguage: selectedLanguage,
                    ),
                  ],

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}