import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final bool hasCalculations;
  final bool isFiltered;

  const EmptyStateWidget({
    super.key,
    required this.hasCalculations,
    required this.isFiltered,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mushroom illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.surfaceElevated,
                borderRadius: BorderRadius.circular(20.w),
                border: Border.all(
                  color: AppTheme.borderSubtle,
                  width: 2,
                ),
              ),
              child: Center(
                child: CustomImageWidget(
                  imageUrl:
                      "https://images.pexels.com/photos/1161547/pexels-photo-1161547.jpeg?auto=compress&cs=tinysrgb&w=800",
                  width: 25.w,
                  height: 25.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              isFiltered
                  ? 'No Results Found'
                  : hasCalculations
                      ? 'No Calculations Match Your Filter'
                      : 'No Calculations Yet',
              style: AppTheme.darkTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.onSurfacePrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Description
            Text(
              isFiltered
                  ? 'Try adjusting your search or filter criteria to find what you\'re looking for.'
                  : hasCalculations
                      ? 'Change your filter to see more calculations.'
                      : 'Start your first calculation to see your history here. All your CVG and LC calculations will be saved for easy reference.',
              style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Action button
            if (!hasCalculations || !isFiltered)
              ElevatedButton.icon(
                onPressed: () {
                  if (!hasCalculations) {
                    Navigator.pushNamed(context, '/dashboard');
                  } else {
                    // Clear filters logic would go here
                  }
                },
                icon: CustomIconWidget(
                  iconName: !hasCalculations ? 'calculate' : 'clear',
                  color: AppTheme.primaryDark,
                  size: 20,
                ),
                label: Text(
                  !hasCalculations
                      ? 'Start Your First Calculation'
                      : 'Clear Filters',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryGold,
                  foregroundColor: AppTheme.primaryDark,
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

            if (!hasCalculations) ...[
              SizedBox(height: 2.h),

              // Secondary actions
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/cvg-calculator'),
                    icon: CustomIconWidget(
                      iconName: 'science',
                      color: AppTheme.secondaryGold,
                      size: 18,
                    ),
                    label: const Text('CVG Calculator'),
                  ),
                  SizedBox(width: 4.w),
                  TextButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/lc-calculator'),
                    icon: CustomIconWidget(
                      iconName: 'water_drop',
                      color: AppTheme.secondaryGold,
                      size: 18,
                    ),
                    label: const Text('LC Calculator'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
