import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/prepquest_provider.dart';
import '../widgets/exam_card.dart';
import '../widgets/progress_card.dart';
import '../widgets/streak_card.dart';
import '../widgets/xp_bar.dart';
import 'daily_study_tracker_screen.dart';
import 'exam_selection_screen.dart';
import 'progress_dashboard_screen.dart';
import 'settings_screen.dart';
import 'syllabus_tracker_screen.dart';

class PrepQuestShell extends StatefulWidget {
  const PrepQuestShell({super.key});

  @override
  State<PrepQuestShell> createState() => _PrepQuestShellState();
}

class _PrepQuestShellState extends State<PrepQuestShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PrepQuestProvider>();
    final selectedExam = provider.selectedExam;

    final pages = <Widget>[
      _HomeDashboardScreen(provider: provider),
      const ExamSelectionScreen(),
      const _TrackerHubScreen(),
      const ProgressDashboardScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.workspace_premium_outlined),
            selectedIcon: Icon(Icons.workspace_premium_rounded),
            label: 'Exams',
          ),
          NavigationDestination(
            icon: Icon(Icons.checklist_outlined),
            selectedIcon: Icon(Icons.checklist_rounded),
            label: 'Tracker',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.insights_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _TrackerHubScreen extends StatelessWidget {
  const _TrackerHubScreen();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: TabBar(
              indicatorColor: scheme.primary,
              labelColor: scheme.primary,
              unselectedLabelColor: scheme.onSurface.withOpacity(0.7),
              tabs: const [
                Tab(
                  icon: Icon(Icons.checklist_rounded),
                  text: 'Syllabus',
                ),
                Tab(
                  icon: Icon(Icons.today_rounded),
                  text: 'Daily',
                ),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [
                SyllabusTrackerScreen(),
                DailyStudyTrackerScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShellPlaceholderScreen extends StatelessWidget {
  const _ShellPlaceholderScreen({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 56,
                color: scheme.primary,
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                subtitle,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurface.withOpacity(0.75),
                  height: 1.45,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeDashboardScreen extends StatelessWidget {
  const _HomeDashboardScreen({
    required this.provider,
  });

  final PrepQuestProvider provider;

  @override
  Widget build(BuildContext context) {
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
                  'Welcome back, ${provider.username}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  selectedExam == null
                      ? 'Pick an exam to start tracking your preparation with focus.'
                      : 'Stay consistent today and keep your ${selectedExam.shortTitle} prep moving.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurface.withOpacity(0.72),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),
                ExamCard(
                  title: selectedExam?.title ?? 'Choose your target exam',
                  subtitle: selectedExam == null
                      ? 'Your dashboard gets sharper once an exam is selected.'
                      : 'Your study target, progress, and XP reflect this exam.',
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: StreakCard(streak: provider.currentStreak),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricCard(
                        icon: Icons.percent_rounded,
                        label: 'Progress',
                        value: '${provider.progressPercent}%',
                        tone: scheme.primary,
                        subtitle: selectedExam == null
                            ? 'No exam selected'
                            : '${provider.completedTopicCount} topics done',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _TodayTargetCard(provider: provider),
                const SizedBox(height: 16),
                XpBar(
                  level: provider.level,
                  totalXp: provider.totalXp,
                  progress: provider.levelProgress,
                  xpIntoLevel: provider.xpIntoLevel,
                  xpToNextLevel: provider.xpToNextLevel,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TodayTargetCard extends StatelessWidget {
  const _TodayTargetCard({
    required this.provider,
  });

  final PrepQuestProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hoursDone = provider.todayHours;
    final targetHours = provider.todayTargetHours;
    final tasksDone = provider.todayTasks;
    final targetTasks = provider.todayTargetTasks;

    return ProgressCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _IconBadge(icon: Icons.track_changes_rounded),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Today target',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                '${(provider.todayTargetProgress * 100).round()}%',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: scheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _TargetProgressRow(
            label: 'Study hours',
            current: hoursDone.toStringAsFixed(hoursDone % 1 == 0 ? 0 : 1),
            target: targetHours.toStringAsFixed(targetHours % 1 == 0 ? 0 : 1),
            progress: targetHours == 0 ? 0.0 : (hoursDone / targetHours).clamp(0, 1).toDouble(),
          ),
          const SizedBox(height: 14),
          _TargetProgressRow(
            label: 'Tasks completed',
            current: '$tasksDone',
            target: '$targetTasks',
            progress: targetTasks == 0 ? 0.0 : (tasksDone / targetTasks).clamp(0, 1).toDouble(),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.tone,
    required this.subtitle,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color tone;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ProgressCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconBadge(
            icon: icon,
            color: tone,
          ),
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
              color: theme.colorScheme.onSurface.withOpacity(0.72),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _TargetProgressRow extends StatelessWidget {
  const _TargetProgressRow({
    required this.label,
    required this.current,
    required this.target,
    required this.progress,
  });

  final String label;
  final String current;
  final String target;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              '$current / $target',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 10,
            value: progress,
          ),
        ),
      ],
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    this.color,
    this.size = 38,
  });

  final IconData icon;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final badgeColor = color ?? scheme.primary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.16),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: badgeColor,
        size: size * 0.56,
      ),
    );
  }
}
