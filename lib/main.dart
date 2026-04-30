import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/local/local_storage.dart';
import 'providers/prepquest_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  final storage = LocalStorage();
  await storage.init();

  final provider = PrepQuestProvider(storage);
  await provider.load();

  runApp(
    ChangeNotifierProvider.value(
      value: provider,
      child: const PrepQuestApp(),
    ),
  );
}
