import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/summary_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Início'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo de volta!',
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Aqui está o resumo da sua produtividade hoje.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.outline,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
                children: const [
                  SummaryCard(
                    title: 'Total de tarefas',
                    value: '12',
                  ),
                  SummaryCard(
                    title: 'Concluídas',
                    value: '8',
                  ),
                  SummaryCard(
                    title: 'Pendentes',
                    value: '4',
                  ),
                  SummaryCard(
                    title: 'Em progresso',
                    value: '2',
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
