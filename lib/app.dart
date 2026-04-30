import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'providers/prepquest_provider.dart';
import 'screens/prepquest_shell.dart';

class PrepQuestApp extends StatelessWidget {
  const PrepQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<PrepQuestProvider>().isDarkMode;

    return MaterialApp(
      title: 'PrepQuest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const PrepQuestShell(),
    );
  }
}
