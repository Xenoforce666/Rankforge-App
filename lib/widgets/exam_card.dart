import 'package:flutter/material.dart';

import 'progress_card.dart';

class ExamCard extends StatelessWidget {
  const ExamCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.label = 'Selected exam',
    this.icon = Icons.workspace_premium_rounded,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: ProgressCard(
          child: Row(
            children: [
              _IconBadge(
                icon: icon,
                size: 42,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurface.withValues(alpha: 0.72),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
    final badgeColor = Theme.of(context).colorScheme.primary;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.16),
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
