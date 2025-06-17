import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class UnitSelectorWidget extends StatelessWidget {
  final String selectedUnit;
  final Function(String) onUnitChanged;

  const UnitSelectorWidget({
    super.key,
    required this.selectedUnit,
    required this.onUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    final units = ['grams', 'ounces', 'pounds'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unit',
          style: AppTheme.inputLabelStyle(isDark: true),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.primaryDark,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppTheme.borderSubtle,
              width: 1,
            ),
          ),
          child: Row(
            children: units.map((unit) {
              final isSelected = selectedUnit == unit;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onUnitChanged(unit),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.secondaryGold
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        unit.substring(0, 1).toUpperCase() + unit.substring(1),
                        style:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: isSelected
                              ? AppTheme.primaryDark
                              : AppTheme.onSurfaceVariant,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
