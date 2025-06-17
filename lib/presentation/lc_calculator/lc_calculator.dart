import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/calculation_history_sheet_widget.dart';
import './widgets/calculation_result_widget.dart';
import './widgets/extract_type_selector_widget.dart';
import './widgets/ratio_selector_widget.dart';
import './widgets/unit_selector_widget.dart';
import './widgets/water_amount_input_widget.dart';

class LcCalculator extends StatefulWidget {
  const LcCalculator({super.key});

  @override
  State<LcCalculator> createState() => _LcCalculatorState();
}

class _LcCalculatorState extends State<LcCalculator>
    with TickerProviderStateMixin {
  final TextEditingController _waterAmountController = TextEditingController();
  final FocusNode _waterAmountFocusNode = FocusNode();

  String _selectedUnit = 'ml';
  String _selectedExtractType = 'honey';
  double _selectedRatio = 2.0;
  double _calculatedAmount = 0.0;
  bool _isCalculated = false;

  late AnimationController _resultAnimationController;
  late Animation<double> _resultAnimation;

  // Mock calculation history data
  final List<Map<String, dynamic>> _calculationHistory = [
    {
      "id": 1,
      "waterAmount": 500.0,
      "unit": "ml",
      "extractType": "honey",
      "ratio": 2.0,
      "extractAmount": 10.0,
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "title": "Honey LC - 500ml"
    },
    {
      "id": 2,
      "waterAmount": 1.0,
      "unit": "L",
      "extractType": "malt",
      "ratio": 4.0,
      "extractAmount": 40.0,
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "title": "Malt Extract LC - 1L"
    },
    {
      "id": 3,
      "waterAmount": 16.0,
      "unit": "fl oz",
      "extractType": "honey",
      "ratio": 2.0,
      "extractAmount": 9.47,
      "timestamp": DateTime.now().subtract(const Duration(days: 3)),
      "title": "Honey LC - 16 fl oz"
    }
  ];

  @override
  void initState() {
    super.initState();
    _resultAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _resultAnimation = CurvedAnimation(
      parent: _resultAnimationController,
      curve: Curves.elasticOut,
    );

    _waterAmountController.addListener(_calculateAmount);
  }

  @override
  void dispose() {
    _waterAmountController.dispose();
    _waterAmountFocusNode.dispose();
    _resultAnimationController.dispose();
    super.dispose();
  }

  void _calculateAmount() {
    final waterAmountText = _waterAmountController.text.replaceAll(',', '.');
    final waterAmount = double.tryParse(waterAmountText);

    if (waterAmount != null && waterAmount > 0) {
      double waterInMl = _convertToMilliliters(waterAmount, _selectedUnit);
      double extractAmount = (waterInMl * _selectedRatio) / 100;

      setState(() {
        _calculatedAmount = extractAmount;
        _isCalculated = true;
      });

      _resultAnimationController.forward();
    } else {
      setState(() {
        _calculatedAmount = 0.0;
        _isCalculated = false;
      });
      _resultAnimationController.reset();
    }
  }

  double _convertToMilliliters(double amount, String unit) {
    switch (unit) {
      case 'L':
        return amount * 1000;
      case 'fl oz':
        return amount * 29.5735;
      default:
        return amount;
    }
  }

  void _onUnitChanged(String unit) {
    setState(() {
      _selectedUnit = unit;
    });
    _calculateAmount();
  }

  void _onExtractTypeChanged(String extractType) {
    setState(() {
      _selectedExtractType = extractType;
    });
    HapticFeedback.selectionClick();
  }

  void _onRatioChanged(double ratio) {
    setState(() {
      _selectedRatio = ratio;
    });
    _calculateAmount();
    HapticFeedback.selectionClick();
  }

  void _saveCalculation() {
    if (!_isCalculated) return;

    final waterAmountText = _waterAmountController.text.replaceAll(',', '.');
    final waterAmount = double.tryParse(waterAmountText);

    if (waterAmount != null && waterAmount > 0) {
      final newCalculation = {
        "id": _calculationHistory.length + 1,
        "waterAmount": waterAmount,
        "unit": _selectedUnit,
        "extractType": _selectedExtractType,
        "ratio": _selectedRatio,
        "extractAmount": _calculatedAmount,
        "timestamp": DateTime.now(),
        "title":
            "${_selectedExtractType == 'honey' ? 'Honey' : 'Malt Extract'} LC - $waterAmount $_selectedUnit"
      };

      setState(() {
        _calculationHistory.insert(0, newCalculation);
      });

      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Calculation saved successfully'),
          backgroundColor: AppTheme.successTeal,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showCalculationHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CalculationHistorySheetWidget(
        calculations: _calculationHistory,
        onDeleteCalculation: _deleteCalculation,
      ),
    );
  }

  void _deleteCalculation(int id) {
    setState(() {
      _calculationHistory.removeWhere((calc) => calc['id'] == id);
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryDark,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pushNamed(context, '/dashboard'),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.onSurfacePrimary,
            size: 24,
          ),
        ),
        title: Text(
          'LC Calculator',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.onSurfacePrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _isCalculated ? _saveCalculation : null,
            icon: CustomIconWidget(
              iconName: 'save',
              color: _isCalculated
                  ? AppTheme.secondaryGold
                  : AppTheme.disabledGray,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: _showCalculationHistory,
            icon: CustomIconWidget(
              iconName: 'history',
              color: AppTheme.onSurfacePrimary,
              size: 24,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header image
              Container(
                height: 20.h,
                margin: EdgeInsets.only(bottom: 3.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadowDark,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CustomImageWidget(
                    imageUrl:
                        "https://images.pexels.com/photos/6157049/pexels-photo-6157049.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
                    width: double.infinity,
                    height: 20.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Water amount input
              WaterAmountInputWidget(
                controller: _waterAmountController,
                focusNode: _waterAmountFocusNode,
                onChanged: (value) => _calculateAmount(),
              ),

              SizedBox(height: 3.h),

              // Unit selector
              UnitSelectorWidget(
                selectedUnit: _selectedUnit,
                onUnitChanged: _onUnitChanged,
              ),

              SizedBox(height: 3.h),

              // Extract type selector
              ExtractTypeSelectorWidget(
                selectedExtractType: _selectedExtractType,
                onExtractTypeChanged: _onExtractTypeChanged,
              ),

              SizedBox(height: 3.h),

              // Ratio selector
              RatioSelectorWidget(
                selectedRatio: _selectedRatio,
                onRatioChanged: _onRatioChanged,
              ),

              SizedBox(height: 4.h),

              // Calculation result
              AnimatedBuilder(
                animation: _resultAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _resultAnimation.value,
                    child: CalculationResultWidget(
                      calculatedAmount: _calculatedAmount,
                      extractType: _selectedExtractType,
                      isVisible: _isCalculated,
                    ),
                  );
                },
              ),

              SizedBox(height: 4.h),

              // Calculate button
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: _isCalculated
                      ? () {
                          HapticFeedback.mediumImpact();
                          _resultAnimationController.forward();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isCalculated
                        ? AppTheme.secondaryGold
                        : AppTheme.disabledGray,
                    foregroundColor: AppTheme.primaryDark,
                    elevation: _isCalculated ? 4 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Calculate',
                    style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }
}