import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        children: [
          ListTile(
            leading: const Icon(Icons.dark_mode, color: AppColors.primary),
            title: Text(
              'Tema',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            subtitle: Text(
              'Claro',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.outline,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, color: AppColors.outline),
            onTap: () {},
          ),
          const Divider(height: 1, indent: AppSpacing.lg, endIndent: AppSpacing.md),
          ListTile(
            leading: const Icon(Icons.notifications, color: AppColors.primary),
            title: Text(
              'Notificações',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            subtitle: Text(
              'Ativadas',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.outline,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, color: AppColors.outline),
            onTap: () {},
          ),
          const Divider(height: 1, indent: AppSpacing.lg, endIndent: AppSpacing.md),
          ListTile(
            leading: const Icon(Icons.info, color: AppColors.primary),
            title: Text(
              'Sobre',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            subtitle: Text(
              'Versão 1.0.0',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.outline,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, color: AppColors.outline),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
