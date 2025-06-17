import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class RatioSelectorWidget extends StatelessWidget {
  final double selectedRatio;
  final Function(double) onRatioChanged;

  const RatioSelectorWidget({
    super.key,
    required this.selectedRatio,
    required this.onRatioChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ratios = [2.0, 4.0];

    return Container(
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
            'Concentration Ratio',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.onSurfacePrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Select the concentration percentage for your liquid culture',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: ratios.map((ratio) {
              final isSelected = selectedRatio == ratio;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onRatioChanged(ratio),
                  child: Container(
                    margin:
                        EdgeInsets.only(right: ratio == ratios.first ? 3.w : 0),
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.secondaryGold
                          : AppTheme.primaryDark,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.accentGold
                            : AppTheme.borderSubtle,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppTheme.secondaryGold
                                    .withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${ratio.toInt()}%',
                          style: AppTheme.dataDisplayStyle(
                                  isDark: true, fontSize: 28)
                              .copyWith(
                            color: isSelected
                                ? AppTheme.primaryDark
                                : AppTheme.onSurfacePrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          ratio == 2.0 ? 'Standard' : 'Strong',
                          style:
                              AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                            color: isSelected
                                ? AppTheme.primaryDark
                                : AppTheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
