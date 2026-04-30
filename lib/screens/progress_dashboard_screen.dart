import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/utils/date_keys.dart';
import '../providers/prepquest_provider.dart';
import '../widgets/exam_card.dart';
import '../widgets/progress_card.dart';
import '../widgets/streak_card.dart';

class ProgressDashboardScreen extends StatelessWidget {
  const ProgressDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PrepQuestProvider>();
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final selectedExam = provider.selectedExam;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Progress dashboard',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  selectedExam == null
                      ? 'Choose an exam to unlock complete progress insights.'
                      : 'Your ${selectedExam.shortTitle} preparation snapshot over the last 7 days.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.72),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),
                ExamCard(
                  title: selectedExam?.title ?? 'Choose your target exam',
                  subtitle: selectedExam == null
                      ? 'Dashboard metrics become more meaningful after exam selection.'
                      : selectedExam.description,
                  label: 'Selected exam',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _MetricSummaryCard(
                        icon: Icons.percent_rounded,
                        label: 'Syllabus',
                        value: '${provider.progressPercent}%',
                        subtitle: selectedExam == null
                            ? 'No exam selected'
                            : 'Overall completion',
                        tone: scheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: StreakCard(streak: provider.currentStreak),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _MetricSummaryCard(
                  icon: Icons.task_alt_rounded,
                  label: 'Completed topics',
                  value: '${provider.completedTopicCount}',
                  subtitle: selectedExam == null
                      ? 'No syllabus tracked yet'
                      : 'Across ${selectedExam.subjects.length} subjects',
                  tone: const Color(0xFFE3A63E),
                ),
                const SizedBox(height: 16),
                _HoursChartCard(provider: provider),
                const SizedBox(height: 16),
                _TasksSummaryCard(provider: provider),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricSummaryCard extends StatelessWidget {
  const _MetricSummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.subtitle,
    required this.tone,
  });

  final IconData icon;
  final String label;
  final String value;
  final String subtitle;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ProgressCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBadge(icon: icon, color: tone),
          const SizedBox(height: 16),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _HoursChartCard extends StatelessWidget {
  const _HoursChartCard({
    required this.provider,
  });

  final PrepQuestProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final days = provider.weekDays;
    final maxHours = days.map(provider.hoursForDate).fold<double>(
        provider.todayTargetHours, (max, hours) => hours > max ? hours : max);

    return ProgressCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _IconBadge(icon: Icons.bar_chart_rounded),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Study hours',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${provider.totalHours.toStringAsFixed(1)} h total',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurface.withValues(alpha: 0.72),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 150,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final day in days)
                  Expanded(
                    child: _HourBar(
                      label: DateKeys.weekdayLabel(day),
                      hours: provider.hoursForDate(day),
                      maxHours: maxHours == 0 ? 1 : maxHours,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TasksSummaryCard extends StatelessWidget {
  const _TasksSummaryCard({
    required this.provider,
  });

  final PrepQuestProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final days = provider.weekDays;
    final lastSevenTasks =
        days.fold<int>(0, (sum, day) => sum + provider.tasksForDate(day));
    final productiveDays = days
        .where((day) =>
            provider.hoursForDate(day) > 0 || provider.tasksForDate(day) > 0)
        .length;

    return ProgressCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _IconBadge(icon: Icons.checklist_rounded),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tasks summary',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _TasksMetric(
                  value: '$lastSevenTasks',
                  label: 'Tasks in last 7 days',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _TasksMetric(
                  value: '$productiveDays/7',
                  label: 'Active days this week',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '${provider.totalTasks} tasks completed overall',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.72),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TasksMetric extends StatelessWidget {
  const _TasksMetric({
    required this.value,
    required this.label,
  });

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
            ),
          ),
        ],
      ),
    );
  }
}

class _HourBar extends StatelessWidget {
  const _HourBar({
    required this.label,
    required this.hours,
    required this.maxHours,
  });

  final String label;
  final double hours;
  final double maxHours;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final height =
        hours == 0 ? 18.0 : 22 + (hours / maxHours).clamp(0, 1).toDouble() * 82;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              color: hours > 0
                  ? scheme.primary
                  : scheme.onSurface.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.72),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            hours == 0 ? '-' : hours.toStringAsFixed(hours % 1 == 0 ? 0 : 1),
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.56),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    this.color,
  });

  final IconData icon;
  final Color? color;

  static const double _badgeSize = 38;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final badgeColor = color ?? scheme.primary;

    return Container(
      width: _badgeSize,
      height: _badgeSize,
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: badgeColor,
        size: _badgeSize * 0.56,
      ),
    );
  }
}
