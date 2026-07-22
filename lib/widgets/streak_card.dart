import 'package:flutter/material.dart';

import 'progress_card.dart';

class StreakCard extends StatelessWidget {
  const StreakCard({
    super.key,
    required this.streak,
  });

  final int streak;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ProgressCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _IconBadge(
            icon: Icons.local_fire_department_rounded,
            color: Color(0xFFE3A63E),
          ),
          const SizedBox(height: 16),
          Text(
            'Daily streak',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$streak day${streak == 1 ? '' : 's'}',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            streak == 0
                ? 'Log study today to begin'
                : 'Keep the run alive today',
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

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  static const double _badgeSize = 38;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _badgeSize,
      height: _badgeSize,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: color,
        size: _badgeSize * 0.56,
      ),
    );
  }
}
