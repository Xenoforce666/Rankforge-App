import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/exam_model.dart';
import '../providers/prepquest_provider.dart';
import '../widgets/progress_card.dart';

class SyllabusTrackerScreen extends StatelessWidget {
  const SyllabusTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PrepQuestProvider>();
    final exam = provider.selectedExam;

    if (exam == null) {
      return const _NoExamSelectedState();
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TrackerHeader(exam: exam),
                const SizedBox(height: 18),
                _OverallProgressSummary(
                  completed: provider.completedTopicCount,
                  total: exam.topicCount,
                  progress: provider.syllabusProgress,
                ),
                const SizedBox(height: 18),
                for (final subject in exam.subjects) ...[
                  _SubjectTrackerSection(
                    exam: exam,
                    subject: subject,
                    provider: provider,
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NoExamSelectedState extends StatelessWidget {
  const _NoExamSelectedState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: ProgressCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.checklist_rounded,
                  color: scheme.primary,
                  size: 52,
                ),
                const SizedBox(height: 18),
                Text(
                  'Select an exam first',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your syllabus checklist will appear here once an exam is selected.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface.withOpacity(0.72),
                    height: 1.45,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TrackerHeader extends StatelessWidget {
  const _TrackerHeader({
    required this.exam,
  });

  final ExamModel exam;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Syllabus tracker',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: scheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${exam.title} preparation checklist',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: scheme.onSurface.withOpacity(0.72),
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _OverallProgressSummary extends StatelessWidget {
  const _OverallProgressSummary({
    required this.completed,
    required this.total,
    required this.progress,
  });

  final int completed;
  final int total;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final percent = (progress * 100).round();

    return ProgressCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _IconBadge(icon: Icons.stacked_bar_chart_rounded),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Overall progress',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '$percent%',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 12,
              value: progress.clamp(0, 1).toDouble(),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$completed of $total topics completed',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurface.withOpacity(0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectTrackerSection extends StatelessWidget {
  const _SubjectTrackerSection({
    required this.exam,
    required this.subject,
    required this.provider,
  });

  final ExamModel exam;
  final SubjectModel subject;
  final PrepQuestProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final completed = provider.completedTopicsForSubject(exam, subject);
    final total = subject.topics.length;
    final progress = provider.subjectProgress(exam, subject);

    return Theme(
      data: theme.copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ProgressCard(
        padding: EdgeInsets.zero,
        child: ExpansionTile(
          tilePadding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
          childrenPadding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
          iconColor: scheme.primary,
          collapsedIconColor: scheme.onSurface.withOpacity(0.72),
          title: Text(
            subject.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    value: progress.clamp(0, 1).toDouble(),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$completed of $total topics complete',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurface.withOpacity(0.66),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          children: [
            for (final topic in subject.topics)
              _TopicCheckboxTile(
                exam: exam,
                subject: subject,
                topic: topic,
                provider: provider,
              ),
          ],
        ),
      ),
    );
  }
}

class _TopicCheckboxTile extends StatelessWidget {
  const _TopicCheckboxTile({
    required this.exam,
    required this.subject,
    required this.topic,
    required this.provider,
  });

  final ExamModel exam;
  final SubjectModel subject;
  final TopicModel topic;
  final PrepQuestProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isComplete = provider.isTopicComplete(exam, subject, topic);

    return CheckboxListTile(
      value: isComplete,
      onChanged: (value) {
        provider.toggleTopic(exam, subject, topic, value ?? false);
      },
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: const EdgeInsets.symmetric(horizontal: 2),
      activeColor: scheme.primary,
      title: Text(
        topic.title,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: isComplete ? scheme.onSurface.withOpacity(0.64) : scheme.onSurface,
          decoration: isComplete ? TextDecoration.lineThrough : null,
          decorationColor: scheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    this.size = 38,
  });

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.16),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: color,
        size: size * 0.56,
      ),
    );
  }
}
