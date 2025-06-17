import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class PreviewTextWidget extends StatelessWidget {
  final String selectedLanguage;

  const PreviewTextWidget({
    super.key,
    required this.selectedLanguage,
  });

  Map<String, String> _getPreviewTexts() {
    final Map<String, Map<String, String>> previewTexts = {
      'title': {
        'es': 'Vista Previa',
        'en': 'Preview',
        'pt': 'Visualização',
      },
      'cvg_calculator': {
        'es': 'Calculadora CVG',
        'en': 'CVG Calculator',
        'pt': 'Calculadora CVG',
      },
      'lc_calculator': {
        'es': 'Calculadora LC',
        'en': 'LC Calculator',
        'pt': 'Calculadora LC',
      },
      'coco_coir_amount': {
        'es': 'Cantidad de Fibra de Coco',
        'en': 'Coco Coir Amount',
        'pt': 'Quantidade de Fibra de Coco',
      },
      'water_amount': {
        'es': 'Cantidad de Agua',
        'en': 'Water Amount',
        'pt': 'Quantidade de Água',
      },
      'calculate': {
        'es': 'Calcular',
        'en': 'Calculate',
        'pt': 'Calcular',
      },
      'grams': {
        'es': 'gramos',
        'en': 'grams',
        'pt': 'gramas',
      },
      'milliliters': {
        'es': 'mililitros',
        'en': 'milliliters',
        'pt': 'mililitros',
      },
    };

    return previewTexts.map((key, value) => MapEntry(
          key,
          value[selectedLanguage] ?? value['es'] ?? '',
        ));
  }

  @override
  Widget build(BuildContext context) {
    final texts = _getPreviewTexts();

    return Container(
      padding: const EdgeInsets.all(20),
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
            children: [
              CustomIconWidget(
                iconName: 'visibility',
                color: AppTheme.secondaryGold,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                texts['title'] ?? '',
                style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.onSurfacePrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Sample calculator labels
          _buildPreviewItem(
            icon: 'calculate',
            title: texts['cvg_calculator'] ?? '',
            subtitle: '${texts['coco_coir_amount']} (${texts['grams']})',
          ),

          const SizedBox(height: 12),

          _buildPreviewItem(
            icon: 'science',
            title: texts['lc_calculator'] ?? '',
            subtitle: '${texts['water_amount']} (${texts['milliliters']})',
          ),

          const SizedBox(height: 16),

          // Sample button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.secondaryGold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.secondaryGold.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                texts['calculate'] ?? '',
                style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.secondaryGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewItem({
    required String icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppTheme.secondaryGold.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: icon,
              color: AppTheme.secondaryGold,
              size: 16,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.onSurfacePrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                subtitle,
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
