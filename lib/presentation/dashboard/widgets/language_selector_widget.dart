import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class LanguageSelectorWidget extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;

  const LanguageSelectorWidget({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
  });

  void _showLanguageSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Select Language / Seleccionar Idioma',
              style: AppTheme.darkTheme.textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            _buildLanguageOption(
              context,
              'Spanish',
              'Español',
              '🇪🇸',
              selectedLanguage == 'Spanish',
            ),
            const SizedBox(height: 8),
            _buildLanguageOption(
              context,
              'English',
              'English',
              '🇺🇸',
              selectedLanguage == 'English',
            ),
            const SizedBox(height: 8),
            _buildLanguageOption(
              context,
              'Portuguese',
              'Português',
              '🇧🇷',
              selectedLanguage == 'Portuguese',
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String languageCode,
    String languageName,
    String flag,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        onLanguageChanged(languageCode);
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.secondaryGold.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppTheme.secondaryGold : AppTheme.borderSubtle,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                languageName,
                style: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                  color: isSelected
                      ? AppTheme.secondaryGold
                      : AppTheme.onSurfacePrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected)
              CustomIconWidget(
                iconName: 'check',
                color: AppTheme.secondaryGold,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String flagEmoji = selectedLanguage == 'Spanish'
        ? '🇪🇸'
        : selectedLanguage == 'English'
            ? '🇺🇸'
            : '🇧🇷';

    return GestureDetector(
      onTap: () => _showLanguageSelector(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.surfaceElevated,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.borderSubtle,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              flagEmoji,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 8),
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: AppTheme.onSurfaceVariant,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
