import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentCalculationsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> calculations;
  final Function(int) onDelete;
  final String selectedLanguage;

  const RecentCalculationsWidget({
    super.key,
    required this.calculations,
    required this.onDelete,
    required this.selectedLanguage,
  });

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inHours < 1) {
      return selectedLanguage == 'Spanish'
          ? 'Hace ${difference.inMinutes} min'
          : selectedLanguage == 'English'
              ? '${difference.inMinutes} min ago'
              : 'Há ${difference.inMinutes} min';
    } else if (difference.inDays < 1) {
      return selectedLanguage == 'Spanish'
          ? 'Hace ${difference.inHours} h'
          : selectedLanguage == 'English'
              ? '${difference.inHours}h ago'
              : 'Há ${difference.inHours}h';
    } else {
      return selectedLanguage == 'Spanish'
          ? 'Hace ${difference.inDays} días'
          : selectedLanguage == 'English'
              ? '${difference.inDays} days ago'
              : 'Há ${difference.inDays} dias';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: calculations.length > 3 ? 3 : calculations.length,
      separatorBuilder: (context, index) => SizedBox(height: 2.h),
      itemBuilder: (context, index) {
        final calculation = calculations[index];

        return Dismissible(
          key: Key(calculation["id"].toString()),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) => onDelete(index),
          background: Container(
            decoration: BoxDecoration(
              color: AppTheme.errorWarm,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: CustomIconWidget(
              iconName: 'delete',
              color: AppTheme.onSurfacePrimary,
              size: 6.w,
            ),
          ),
          child: Container(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: calculation["type"] == "CVG"
                            ? AppTheme.successTeal.withValues(alpha: 0.2)
                            : AppTheme.secondaryGold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${calculation["type"]} Calculator',
                        style:
                            AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                          color: calculation["type"] == "CVG"
                              ? AppTheme.successTeal
                              : AppTheme.secondaryGold,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      _formatTimestamp(calculation["timestamp"] as DateTime),
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  selectedLanguage == 'Spanish'
                      ? 'Entrada: ${calculation["input"]}'
                      : selectedLanguage == 'English'
                          ? 'Input: ${calculation["input"]}'
                          : 'Entrada: ${calculation["input"]}',
                  style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.onSurfacePrimary,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  selectedLanguage == 'Spanish'
                      ? 'Resultado: ${calculation["result"]}'
                      : selectedLanguage == 'English'
                          ? 'Result: ${calculation["result"]}'
                          : 'Resultado: ${calculation["result"]}',
                  style: AppTheme.dataDisplayStyle(
                    isDark: true,
                    fontSize: 14,
                  ).copyWith(
                    color: AppTheme.secondaryGold,
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        // Navigate to specific calculator with pre-filled data
                        if (calculation["type"] == "CVG") {
                          Navigator.pushNamed(context, '/cvg-calculator');
                        } else {
                          Navigator.pushNamed(context, '/lc-calculator');
                        }
                      },
                      icon: CustomIconWidget(
                        iconName: 'refresh',
                        color: AppTheme.secondaryGold,
                        size: 4.w,
                      ),
                      label: Text(
                        selectedLanguage == 'Spanish'
                            ? 'Recalcular'
                            : selectedLanguage == 'English'
                                ? 'Recalculate'
                                : 'Recalcular',
                        style:
                            AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.secondaryGold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
