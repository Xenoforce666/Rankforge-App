import 'package:flutter/material.dart';

import '../providers/prepquest_provider.dart';
import 'progress_card.dart';

class XpBar extends StatelessWidget {
  const XpBar({
    super.key,
    required this.level,
    required this.totalXp,
    required this.progress,
    required this.xpIntoLevel,
    required this.xpToNextLevel,
  });

  final int level;
  final int totalXp;
  final double progress;
  final int xpIntoLevel;
  final int xpToNextLevel;

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
              const _IconBadge(icon: Icons.bolt_rounded),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'XP level',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$totalXp XP earned',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurface.withOpacity(0.72),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Lv $level',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: scheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 12,
              value: progress,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$xpIntoLevel/${PrepQuestProvider.xpPerLevel} XP in this level | $xpToNextLevel XP to next level',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurface.withOpacity(0.72),
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
