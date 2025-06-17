import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_export.dart';
import './widgets/language_option_card.dart';
import './widgets/preview_text_widget.dart';

class LanguageSettings extends StatefulWidget {
  const LanguageSettings({super.key});

  @override
  State<LanguageSettings> createState() => _LanguageSettingsState();
}

class _LanguageSettingsState extends State<LanguageSettings> {
  String _selectedLanguage = 'es';
  bool _isLoading = false;

  final List<Map<String, dynamic>> _languages = [
    {
      'code': 'es',
      'name': 'Español (España)',
      'flag': '🇪🇸',
      'isDefault': true,
    },
    {
      'code': 'en',
      'name': 'English (United States)',
      'flag': '🇺🇸',
      'isDefault': false,
    },
    {
      'code': 'pt',
      'name': 'Português (Brasil)',
      'flag': '🇧🇷',
      'isDefault': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('selected_language') ?? 'es';
    });
  }

  Future<void> _saveLanguagePreference(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', languageCode);
  }

  void _onLanguageSelected(String languageCode) async {
    if (_selectedLanguage == languageCode) return;

    HapticFeedback.lightImpact();

    setState(() {
      _isLoading = true;
      _selectedLanguage = languageCode;
    });

    await _saveLanguagePreference(languageCode);

    // Simulate loading time for language change
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_getLocalizedText('language_changed')),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  String _getLocalizedText(String key) {
    final Map<String, Map<String, String>> translations = {
      'language_changed': {
        'es': 'Idioma cambiado exitosamente',
        'en': 'Language changed successfully',
        'pt': 'Idioma alterado com sucesso',
      },
      'apply_changes': {
        'es': 'Aplicar Cambios',
        'en': 'Apply Changes',
        'pt': 'Aplicar Alterações',
      },
      'done': {
        'es': 'Hecho',
        'en': 'Done',
        'pt': 'Concluído',
      },
    };

    return translations[key]?[_selectedLanguage] ??
        translations[key]?['es'] ??
        '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryDark,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.onSurfacePrimary,
            size: 24,
          ),
        ),
        title: Text(
          'Language / Idioma / Idioma',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.onSurfacePrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Language options
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _languages.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final language = _languages[index];
                        return LanguageOptionCard(
                          languageCode: language['code'] as String,
                          languageName: language['name'] as String,
                          flagEmoji: language['flag'] as String,
                          isSelected: _selectedLanguage == language['code'],
                          isLoading: _isLoading &&
                              _selectedLanguage == language['code'],
                          onTap: () =>
                              _onLanguageSelected(language['code'] as String),
                        );
                      },
                    ),

                    const SizedBox(height: 32),

                    // Preview text section
                    PreviewTextWidget(selectedLanguage: _selectedLanguage),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom action button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceElevated,
                border: Border(
                  top: BorderSide(
                    color: AppTheme.borderSubtle,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _isLoading ? null : () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondaryGold,
                        foregroundColor: AppTheme.primaryDark,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryDark,
                                ),
                              ),
                            )
                          : Text(
                              _getLocalizedText('done'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
