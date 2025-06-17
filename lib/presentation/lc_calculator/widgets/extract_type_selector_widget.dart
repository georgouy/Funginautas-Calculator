import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExtractTypeSelectorWidget extends StatelessWidget {
  final String selectedExtractType;
  final Function(String) onExtractTypeChanged;

  const ExtractTypeSelectorWidget({
    super.key,
    required this.selectedExtractType,
    required this.onExtractTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
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
            'Extract Type',
            style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.onSurfacePrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildExtractCard(
                  type: 'honey',
                  title: 'Honey',
                  icon: 'water_drop',
                  imageUrl:
                      'https://images.pexels.com/photos/33162/honey-jar-glass-organic.jpg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                  isSelected: selectedExtractType == 'honey',
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildExtractCard(
                  type: 'malt',
                  title: 'Malt Extract',
                  icon: 'grain',
                  imageUrl:
                      'https://images.pexels.com/photos/1435735/pexels-photo-1435735.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
                  isSelected: selectedExtractType == 'malt',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExtractCard({
    required String type,
    required String title,
    required String icon,
    required String imageUrl,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onExtractTypeChanged(type),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.secondaryGold.withValues(alpha: 0.1)
              : AppTheme.primaryDark,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.secondaryGold : AppTheme.borderSubtle,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 8.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowDark,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CustomImageWidget(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  height: 8.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 1.h),
            CustomIconWidget(
              iconName: icon,
              color: isSelected
                  ? AppTheme.secondaryGold
                  : AppTheme.onSurfaceVariant,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              title,
              style: AppTheme.darkTheme.textTheme.titleSmall?.copyWith(
                color: isSelected
                    ? AppTheme.secondaryGold
                    : AppTheme.onSurfacePrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
