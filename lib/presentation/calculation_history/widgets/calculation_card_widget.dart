import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CalculationCardWidget extends StatelessWidget {
  final Map<String, dynamic> calculation;
  final Function(String action, Map<String, dynamic> calculation) onAction;

  const CalculationCardWidget({
    super.key,
    required this.calculation,
    required this.onAction,
  });

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

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

  Widget _buildCVGContent() {
    final inputs = calculation['inputs'] as Map<String, dynamic>;
    final results = calculation['results'] as Map<String, dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Coco Coir',
                    style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '${inputs['cocoCoir']} g',
                    style:
                        AppTheme.dataDisplayStyle(isDark: true, fontSize: 16),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Volume',
                    style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '${results['totalVolume']} ml',
                    style:
                        AppTheme.dataDisplayStyle(isDark: true, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Text(
          'Ratio: ${results['ratio']}',
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.secondaryGold,
          ),
        ),
      ],
    );
  }

  Widget _buildLCContent() {
    final inputs = calculation['inputs'] as Map<String, dynamic>;
    final results = calculation['results'] as Map<String, dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Water',
                    style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '${inputs['water']} ml',
                    style:
                        AppTheme.dataDisplayStyle(isDark: true, fontSize: 16),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Extract',
                    style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '${results['extractAmount']} g',
                    style:
                        AppTheme.dataDisplayStyle(isDark: true, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Text(
          '${inputs['extractType']} - ${inputs['ratio']}',
          style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.secondaryGold,
          ),
        ),
      ],
    );
  }

  void _showActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            _buildActionTile(
              context,
              'Reuse Values',
              'refresh',
              () => onAction('reuse', calculation),
            ),
            _buildActionTile(
              context,
              'Share',
              'share',
              () => onAction('share', calculation),
            ),
            _buildActionTile(
              context,
              'Duplicate',
              'content_copy',
              () => onAction('duplicate', calculation),
            ),
            _buildActionTile(
              context,
              'Delete',
              'delete',
              () => onAction('delete', calculation),
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context,
    String title,
    String iconName,
    VoidCallback onTap, {
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: isDestructive ? AppTheme.errorWarm : AppTheme.onSurfacePrimary,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
          color: isDestructive ? AppTheme.errorWarm : AppTheme.onSurfacePrimary,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final timestamp = calculation['timestamp'] as DateTime;
    final type = calculation['type'] as String;

    return GestureDetector(
      onLongPress: () => _showActionMenu(context),
      child: Dismissible(
        key: Key(calculation['id'].toString()),
        background: Container(
          decoration: BoxDecoration(
            color: AppTheme.successTeal,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.primaryDark,
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Reuse',
                style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.primaryDark,
                ),
              ),
            ],
          ),
        ),
        secondaryBackground: Container(
          decoration: BoxDecoration(
            color: AppTheme.errorWarm,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'delete',
                color: AppTheme.onSurfacePrimary,
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Delete',
                style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.onSurfacePrimary,
                ),
              ),
            ],
          ),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            onAction('reuse', calculation);
            return false;
          } else {
            onAction('delete', calculation);
            return false;
          }
        },
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
              // Header
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: type == 'CVG'
                          ? AppTheme.secondaryGold.withValues(alpha: 0.2)
                          : AppTheme.successTeal.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      type,
                      style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                        color: type == 'CVG'
                            ? AppTheme.secondaryGold
                            : AppTheme.successTeal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatTimestamp(timestamp),
                    style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  GestureDetector(
                    onTap: () => _showActionMenu(context),
                    child: CustomIconWidget(
                      iconName: 'more_vert',
                      color: AppTheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Content
              type == 'CVG' ? _buildCVGContent() : _buildLCContent(),
            ],
          ),
        ),
      ),
    );
  }
}
