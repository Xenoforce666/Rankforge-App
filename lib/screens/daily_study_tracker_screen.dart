import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../core/utils/date_keys.dart';
import '../providers/prepquest_provider.dart';
import '../widgets/progress_card.dart';
import '../widgets/streak_card.dart';

class DailyStudyTrackerScreen extends StatefulWidget {
  const DailyStudyTrackerScreen({super.key});

  @override
  State<DailyStudyTrackerScreen> createState() => _DailyStudyTrackerScreenState();
}

class _DailyStudyTrackerScreenState extends State<DailyStudyTrackerScreen> {
  late final TextEditingController _hoursController;
  late final TextEditingController _tasksController;
  String? _lastSyncedSnapshot;

  @override
  void initState() {
    super.initState();
    _hoursController = TextEditingController();
    _tasksController = TextEditingController();
  }

  @override
  void dispose() {
    _hoursController.dispose();
    _tasksController.dispose();
    super.dispose();
  }

  void _syncTodayFields(PrepQuestProvider provider) {
    final todayLog = provider.todayLog;
    final snapshot = todayLog == null
        ? 'empty'
        : '${todayLog.dateKey}:${todayLog.hoursStudied}:${todayLog.tasksCompleted}';

    if (_lastSyncedSnapshot == snapshot) {
      return;
    }

    _lastSyncedSnapshot = snapshot;
    _hoursController.text = todayLog == null
        ? ''
        : todayLog.hoursStudied.toStringAsFixed(todayLog.hoursStudied % 1 == 0 ? 0 : 1);
    _tasksController.text = todayLog == null ? '' : todayLog.tasksCompleted.toString();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PrepQuestProvider>();
    _syncTodayFields(provider);

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
                  'Daily study tracker',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: scheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Log today once and your streak, XP, and weekly history update instantly.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurface.withOpacity(0.72),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),
                StreakCard(streak: provider.currentStreak),
                const SizedBox(height: 16),
                _TodayEntryCard(
                  hoursController: _hoursController,
                  tasksController: _tasksController,
                  onSave: () => _saveToday(context, provider),
                ),
                const SizedBox(height: 16),
                _SevenDayHistoryCard(provider: provider),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveToday(BuildContext context, PrepQuestProvider provider) async {
    final hours = double.tryParse(_hoursController.text.trim()) ?? 0;
    final tasks = int.tryParse(_tasksController.text.trim()) ?? 0;

    await provider.saveDailyLog(
      hoursStudied: hours < 0 ? 0 : hours,
      tasksCompleted: tasks < 0 ? 0 : tasks,
    );

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Today\'s study log saved')),
    );
  }
}

class _TodayEntryCard extends StatelessWidget {
  const _TodayEntryCard({
    required this.hoursController,
    required this.tasksController,
    required this.onSave,
  });

  final TextEditingController hoursController;
  final TextEditingController tasksController;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ProgressCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _IconBadge(icon: Icons.edit_calendar_rounded),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Today\'s entry',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          TextField(
            controller: hoursController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}')),
            ],
            decoration: const InputDecoration(
              labelText: 'Study hours',
              prefixIcon: Icon(Icons.schedule_rounded),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: tasksController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              labelText: 'Tasks completed',
              prefixIcon: Icon(Icons.task_alt_rounded),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onSave,
              icon: const Icon(Icons.save_rounded),
              label: const Text('Save today'),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'A saved entry with hours or tasks counts toward your streak.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurface.withOpacity(0.64),
            ),
          ),
        ],
      ),
    );
  }
}

class _SevenDayHistoryCard extends StatelessWidget {
  const _SevenDayHistoryCard({
    required this.provider,
  });

  final PrepQuestProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final days = provider.weekDays;
    final maxHours = days
        .map(provider.hoursForDate)
        .fold<double>(provider.todayTargetHours, (max, hours) => hours > max ? hours : max);

    return ProgressCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _IconBadge(icon: Icons.calendar_view_week_rounded),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Last 7 days',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (final day in days)
                Expanded(
                  child: _HistoryBar(
                    label: DateKeys.weekdayLabel(day),
                    hours: provider.hoursForDate(day),
                    tasks: provider.tasksForDate(day),
                    maxHours: maxHours == 0 ? 1 : maxHours,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '${(provider.weeklyConsistency * 100).round()}% weekly consistency',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurface.withOpacity(0.72),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryBar extends StatelessWidget {
  const _HistoryBar({
    required this.label,
    required this.hours,
    required this.tasks,
    required this.maxHours,
  });

  final String label;
  final double hours;
  final int tasks;
  final double maxHours;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasEntry = hours > 0 || tasks > 0;
    final height = hasEntry ? 24 + (hours / maxHours).clamp(0, 1).toDouble() * 62 : 18.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: double.infinity,
            height: height,
            constraints: const BoxConstraints(minHeight: 18),
            decoration: BoxDecoration(
              color: hasEntry ? scheme.primary : scheme.onSurface.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            hours == 0 ? '-' : hours.toStringAsFixed(hours % 1 == 0 ? 0 : 1),
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSurface.withOpacity(0.58),
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
