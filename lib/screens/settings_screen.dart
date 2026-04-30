import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/prepquest_provider.dart';
import '../widgets/progress_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _usernameController;
  String? _lastSyncedUsername;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _syncUsername(String username) {
    if (_lastSyncedUsername == username) {
      return;
    }
    _lastSyncedUsername = username;
    _usernameController.text = username;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PrepQuestProvider>();
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    _syncUsername(provider.username);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Settings',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage your local profile, theme, and app data.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.72),
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 24),
                _UsernameCard(
                  controller: _usernameController,
                  onSave: () => _saveUsername(context, provider),
                ),
                const SizedBox(height: 16),
                _ThemeCard(
                  isDarkMode: provider.isDarkMode,
                  onChanged: (value) => provider.setDarkMode(value),
                ),
                const SizedBox(height: 16),
                _ResetCard(
                  onReset: () => _confirmReset(context, provider),
                ),
                const SizedBox(height: 16),
                const _AboutCard(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveUsername(
      BuildContext context, PrepQuestProvider provider) async {
    await provider.setUsername(_usernameController.text);
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Username updated')),
    );
  }

  Future<void> _confirmReset(
      BuildContext context, PrepQuestProvider provider) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) {
            final theme = Theme.of(context);
            return AlertDialog(
              title: const Text('Reset all data?'),
              content: const Text(
                'This will clear your selected exam, topic progress, study logs, streak, and local preferences.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.onError,
                  ),
                  child: const Text('Reset'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!confirmed) {
      return;
    }

    await provider.resetData();
    if (!mounted) {
      return;
    }

    _lastSyncedUsername = null;
    _syncUsername(provider.username);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All app data has been reset')),
    );
  }
}

class _UsernameCard extends StatelessWidget {
  const _UsernameCard({
    required this.controller,
    required this.onSave,
  });

  final TextEditingController controller;
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
              const _IconBadge(icon: Icons.person_rounded),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Username',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Display name',
              prefixIcon: Icon(Icons.badge_rounded),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onSave,
              icon: const Icon(Icons.save_rounded),
              label: const Text('Save username'),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Stored only on this device.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.64),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({
    required this.isDarkMode,
    required this.onChanged,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ProgressCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _IconBadge(icon: Icons.dark_mode_rounded),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dark theme',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Toggle the app between dark and light modes.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.72),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isDarkMode,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ResetCard extends StatelessWidget {
  const _ResetCard({
    required this.onReset,
  });

  final VoidCallback onReset;

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
              _IconBadge(
                icon: Icons.restart_alt_rounded,
                color: scheme.error,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Reset app data',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Remove all local progress, streaks, preferences, and saved study history.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurface.withValues(alpha: 0.72),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.delete_forever_rounded),
              label: const Text('Reset all data'),
              style: OutlinedButton.styleFrom(
                foregroundColor: scheme.error,
                side: BorderSide(color: scheme.error.withValues(alpha: 0.45)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ProgressCard(
      child: Row(
        children: [
          const _IconBadge(icon: Icons.info_rounded),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PrepQuest',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Version 1.0 MVP',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurface.withValues(alpha: 0.72),
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
