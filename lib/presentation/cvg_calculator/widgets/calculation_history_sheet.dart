import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CalculationHistorySheet extends StatelessWidget {
  final List<Map<String, dynamic>> history;
  final Function(int) onDeleteCalculation;

  const CalculationHistorySheet({
    super.key,
    required this.history,
    required this.onDeleteCalculation,
  });

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  String _formatAmount(double amount) {
    if (amount < 1) {
      return amount.toStringAsFixed(2);
    } else if (amount < 10) {
      return amount.toStringAsFixed(1);
    } else {
      return amount.toStringAsFixed(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.borderSubtle,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'history',
                  color: AppTheme.secondaryGold,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Calculation History',
                  style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                    color: AppTheme.onSurfacePrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          Divider(
            color: AppTheme.borderSubtle,
            height: 1,
          ),

          // History list
          Expanded(
            child: history.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'history_toggle_off',
                          color: AppTheme.disabledGray,
                          size: 48,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'No calculations saved yet',
                          style:
                              AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.all(4.w),
                    itemCount: history.length,
                    separatorBuilder: (context, index) => SizedBox(height: 2.h),
                    itemBuilder: (context, index) {
                      final calculation = history[index];
                      return Dismissible(
                        key: Key('calc_${calculation["id"]}'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 4.w),
                          decoration: BoxDecoration(
                            color: AppTheme.errorWarm,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CustomIconWidget(
                            iconName: 'delete',
                            color: AppTheme.onSurfacePrimary,
                            size: 24,
                          ),
                        ),
                        onDismissed: (direction) {
                          onDeleteCalculation(calculation["id"] as int);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Calculation deleted'),
                              backgroundColor: AppTheme.errorWarm,
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryDark,
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
                                children: [
                                  CustomIconWidget(
                                    iconName: 'calculate',
                                    color: AppTheme.secondaryGold,
                                    size: 20,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    '${_formatAmount(calculation["cocoCoirAmount"] as double)} ${calculation["unit"]}',
                                    style: AppTheme
                                        .darkTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      color: AppTheme.onSurfacePrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    _formatDateTime(
                                        calculation["timestamp"] as DateTime),
                                    style: AppTheme
                                        .darkTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: AppTheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildResultItem(
                                      'Water',
                                      calculation["waterAmount"] as double,
                                      'ml',
                                      AppTheme.successTeal,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: _buildResultItem(
                                      'Vermiculite',
                                      calculation["vermiculiteAmount"]
                                          as double,
                                      'g',
                                      AppTheme.secondaryGold,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Expanded(
                                    child: _buildResultItem(
                                      'Gypsum',
                                      calculation["gypsumAmount"] as double,
                                      'g',
                                      AppTheme.accentGold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(
      String title, double amount, String unit, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            '${_formatAmount(amount)} $unit',
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
