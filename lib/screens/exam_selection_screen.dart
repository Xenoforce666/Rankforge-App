import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/exam_model.dart';
import '../providers/prepquest_provider.dart';
import '../widgets/exam_card.dart';

class ExamSelectionScreen extends StatelessWidget {
  const ExamSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PrepQuestProvider>();
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose your exam',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your daily targets, syllabus progress, and XP will follow the exam you select.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurface.withOpacity(0.72),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),
                for (final exam in provider.exams) ...[
                  _SelectableExamCard(
                    exam: exam,
                    isSelected: provider.selectedExamId == exam.id,
                    onTap: () async {
                      await provider.selectExam(exam.id);
                      if (!context.mounted) {
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${exam.title} selected'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 14),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectableExamCard extends StatelessWidget {
  const _SelectableExamCard({
    required this.exam,
    required this.isSelected,
    required this.onTap,
  });

  final ExamModel exam;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ExamCard(
          label: isSelected ? 'Current exam' : 'Available exam',
          title: exam.title,
          subtitle: exam.description,
          icon: _iconForExam(exam.id),
          onTap: onTap,
        ),
        if (isSelected)
          Positioned(
            top: 14,
            right: 14,
            child: Icon(
              Icons.check_circle_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 22,
            ),
          ),
      ],
    );
  }

  IconData _iconForExam(String examId) {
    return switch (examId) {
      'upsc' => Icons.account_balance_rounded,
      'jpsc' => Icons.terrain_rounded,
      'rbi_grade_b' => Icons.currency_rupee_rounded,
      _ => Icons.workspace_premium_rounded,
    };
  }
}
