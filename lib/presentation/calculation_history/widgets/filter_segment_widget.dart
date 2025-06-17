import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterSegmentWidget extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;

  const FilterSegmentWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    final filters = ['All', 'CVG', 'LC'];

    return Container(
      height: 6.h,
      decoration: BoxDecoration(
        color: AppTheme.surfaceElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderSubtle,
          width: 1,
        ),
      ),
      child: Row(
        children: filters.map((filter) {
          final isSelected = selectedFilter == filter;
          final isFirst = filter == filters.first;
          final isLast = filter == filters.last;

          return Expanded(
            child: GestureDetector(
              onTap: () => onFilterChanged(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color:
                      isSelected ? AppTheme.secondaryGold : Colors.transparent,
                  borderRadius: BorderRadius.horizontal(
                    left: isFirst ? const Radius.circular(11) : Radius.zero,
                    right: isLast ? const Radius.circular(11) : Radius.zero,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (filter != 'All') ...[
                        CustomIconWidget(
                          iconName: filter == 'CVG' ? 'science' : 'water_drop',
                          color: isSelected
                              ? AppTheme.primaryDark
                              : AppTheme.onSurfaceVariant,
                          size: 18,
                        ),
                        SizedBox(width: 1.w),
                      ],
                      Text(
                        filter,
                        style:
                            AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                          color: isSelected
                              ? AppTheme.primaryDark
                              : AppTheme.onSurfaceVariant,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
