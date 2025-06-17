import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/calculation_history_sheet.dart';
import './widgets/calculation_result_card.dart';
import './widgets/unit_selector_widget.dart';

class CvgCalculator extends StatefulWidget {
  const CvgCalculator({super.key});

  @override
  State<CvgCalculator> createState() => _CvgCalculatorState();
}

class _CvgCalculatorState extends State<CvgCalculator>
    with TickerProviderStateMixin {
  final TextEditingController _cocoCoirController = TextEditingController();
  final FocusNode _cocoCoirFocusNode = FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _selectedUnit = 'grams';
  double _cocoCoirAmount = 0.0;
  double _waterAmount = 0.0;
  double _vermiculiteAmount = 0.0;
  double _gypsumAmount = 0.0;
  bool _hasError = false;
  String _errorMessage = '';

  late AnimationController _resultAnimationController;
  late Animation<double> _resultAnimation;

  // Mock calculation history data
  final List<Map<String, dynamic>> _calculationHistory = [
    {
      "id": 1,
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "cocoCoirAmount": 500.0,
      "unit": "grams",
      "waterAmount": 2500.0,
      "vermiculiteAmount": 250.0,
      "gypsumAmount": 25.0,
    },
    {
      "id": 2,
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "cocoCoirAmount": 1000.0,
      "unit": "grams",
      "waterAmount": 5000.0,
      "vermiculiteAmount": 500.0,
      "gypsumAmount": 50.0,
    },
    {
      "id": 3,
      "timestamp": DateTime.now().subtract(const Duration(days: 3)),
      "cocoCoirAmount": 2.0,
      "unit": "pounds",
      "waterAmount": 4536.0,
      "vermiculiteAmount": 453.6,
      "gypsumAmount": 45.36,
    },
  ];

  @override
  void initState() {
    super.initState();
    _resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _resultAnimation = CurvedAnimation(
      parent: _resultAnimationController,
      curve: Curves.easeInOut,
    );

    _cocoCoirController.addListener(_onCocoCoirChanged);
  }

  @override
  void dispose() {
    _cocoCoirController.dispose();
    _cocoCoirFocusNode.dispose();
    _resultAnimationController.dispose();
    super.dispose();
  }

  void _onCocoCoirChanged() {
    final text = _cocoCoirController.text.replaceAll(',', '.');
    if (text.isEmpty) {
      setState(() {
        _cocoCoirAmount = 0.0;
        _hasError = false;
        _errorMessage = '';
      });
      _calculateResults();
      return;
    }

    final value = double.tryParse(text);
    if (value == null || value < 0) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Please enter a valid positive number';
      });
      return;
    }

    setState(() {
      _cocoCoirAmount = value;
      _hasError = false;
      _errorMessage = '';
    });
    _calculateResults();
  }

  void _calculateResults() {
    if (_cocoCoirAmount <= 0) {
      setState(() {
        _waterAmount = 0.0;
        _vermiculiteAmount = 0.0;
        _gypsumAmount = 0.0;
      });
      return;
    }

    // Convert to grams for calculation
    double cocoCoirInGrams = _cocoCoirAmount;
    switch (_selectedUnit) {
      case 'ounces':
        cocoCoirInGrams = _cocoCoirAmount * 28.3495;
        break;
      case 'pounds':
        cocoCoirInGrams = _cocoCoirAmount * 453.592;
        break;
    }

    // CVG calculation ratios
    // Water: 5x the coco coir weight
    // Vermiculite: 0.5x the coco coir weight
    // Gypsum: 0.05x the coco coir weight
    setState(() {
      _waterAmount = cocoCoirInGrams * 5;
      _vermiculiteAmount = cocoCoirInGrams * 0.5;
      _gypsumAmount = cocoCoirInGrams * 0.05;
    });

    _resultAnimationController.forward();
  }

  void _onUnitChanged(String unit) {
    setState(() {
      _selectedUnit = unit;
    });
    _calculateResults();
  }

  void _saveCalculation() {
    if (_cocoCoirAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid amount to save'),
          backgroundColor: AppTheme.errorWarm,
        ),
      );
      return;
    }

    // Haptic feedback
    HapticFeedback.lightImpact();

    final newCalculation = {
      "id": _calculationHistory.length + 1,
      "timestamp": DateTime.now(),
      "cocoCoirAmount": _cocoCoirAmount,
      "unit": _selectedUnit,
      "waterAmount": _waterAmount,
      "vermiculiteAmount": _vermiculiteAmount,
      "gypsumAmount": _gypsumAmount,
    };

    setState(() {
      _calculationHistory.insert(0, newCalculation);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Calculation saved successfully'),
        backgroundColor: AppTheme.successTeal,
        action: SnackBarAction(
          label: 'View History',
          onPressed: _showCalculationHistory,
        ),
      ),
    );
  }

  void _showCalculationHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CalculationHistorySheet(
        history: _calculationHistory,
        onDeleteCalculation: _deleteCalculation,
      ),
    );
  }

  void _deleteCalculation(int id) {
    setState(() {
      _calculationHistory.removeWhere((calc) => (calc["id"] as int) == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryDark,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.onSurfacePrimary,
            size: 24,
          ),
        ),
        title: Text(
          'CVG Calculator',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.onSurfacePrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showCalculationHistory,
            icon: CustomIconWidget(
              iconName: 'history',
              color: AppTheme.secondaryGold,
              size: 24,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryDark,
              AppTheme.primaryDark.withValues(alpha: 0.95),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Background mushroom imagery
                Container(
                  height: 15.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppTheme.surfaceElevated.withValues(alpha: 0.3),
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomImageWidget(
                          imageUrl:
                              "https://images.unsplash.com/photo-1518531933037-91b2f5f229cc?q=80&w=2069&auto=format&fit=crop",
                          width: double.infinity,
                          height: 15.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primaryDark.withValues(alpha: 0.8),
                              AppTheme.primaryDark.withValues(alpha: 0.6),
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'calculate',
                              color: AppTheme.secondaryGold,
                              size: 32,
                            ),
                            SizedBox(height: 1.h),
                            Text(
                              'Precise Substrate Calculations',
                              style: AppTheme.darkTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: AppTheme.onSurfacePrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),

                // Input Section
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.borderSubtle,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Coco Coir Amount',
                        style: AppTheme.inputLabelStyle(isDark: true),
                      ),
                      SizedBox(height: 2.h),
                      TextFormField(
                        controller: _cocoCoirController,
                        focusNode: _cocoCoirFocusNode,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        style: AppTheme.dataDisplayStyle(
                            isDark: true, fontSize: 18),
                        decoration: InputDecoration(
                          hintText: 'Enter amount',
                          errorText: _hasError ? _errorMessage : null,
                          suffixIcon: _cocoCoirController.text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    _cocoCoirController.clear();
                                    _cocoCoirFocusNode.unfocus();
                                  },
                                  icon: CustomIconWidget(
                                    iconName: 'clear',
                                    color: AppTheme.onSurfaceVariant,
                                    size: 20,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      UnitSelectorWidget(
                        selectedUnit: _selectedUnit,
                        onUnitChanged: _onUnitChanged,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3.h),

                // Results Section
                AnimatedBuilder(
                  animation: _resultAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.8 + (0.2 * _resultAnimation.value),
                      child: Opacity(
                        opacity: _resultAnimation.value,
                        child: Column(
                          children: [
                            CalculationResultCard(
                              title: 'Water',
                              amount: _waterAmount,
                              unit: 'ml',
                              icon: 'water_drop',
                              color: AppTheme.successTeal,
                            ),
                            SizedBox(height: 2.h),
                            CalculationResultCard(
                              title: 'Vermiculite',
                              amount: _vermiculiteAmount,
                              unit: 'g',
                              icon: 'scatter_plot',
                              color: AppTheme.secondaryGold,
                            ),
                            SizedBox(height: 2.h),
                            CalculationResultCard(
                              title: 'Gypsum',
                              amount: _gypsumAmount,
                              unit: 'g',
                              icon: 'grain',
                              color: AppTheme.accentGold,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 4.h),

                // Calculate Button
                ElevatedButton(
                  onPressed: _cocoCoirAmount > 0
                      ? () {
                          HapticFeedback.mediumImpact();
                          _calculateResults();
                          _resultAnimationController.reset();
                          _resultAnimationController.forward();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryGold,
                    foregroundColor: AppTheme.primaryDark,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'calculate',
                        color: AppTheme.primaryDark,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Calculate',
                        style:
                            AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.primaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),

                // Save Button
                OutlinedButton(
                  onPressed: _cocoCoirAmount > 0 ? _saveCalculation : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.secondaryGold,
                    side: BorderSide(color: AppTheme.secondaryGold, width: 1),
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'save',
                        color: AppTheme.secondaryGold,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Save Calculation',
                        style:
                            AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.secondaryGold,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
