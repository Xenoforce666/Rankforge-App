import 'package:hive_flutter/hive_flutter.dart';

import '../../models/daily_study_log.dart';

class LocalStorage {
  static const String _boxName = 'prepquest_box';
  static const String _usernameKey = 'username';
  static const String _selectedExamKey = 'selected_exam_id';
  static const String _darkModeKey = 'dark_mode';
  static const String _topicCompletionKey = 'topic_completion';
  static const String _dailyLogsKey = 'daily_logs';

  Box<dynamic>? _box;

  Future<void> init() async {
    _box = await Hive.openBox<dynamic>(_boxName);
  }

  Box<dynamic> get _store {
    final box = _box;
    if (box == null) {
      throw StateError('LocalStorage.init must be called before reading data.');
    }
    return box;
  }

  String getUsername() {
    return _store.get(_usernameKey, defaultValue: 'Aspirant').toString();
  }

  Future<void> saveUsername(String username) {
    return _store.put(_usernameKey, username);
  }

  String? getSelectedExamId() {
    final value = _store.get(_selectedExamKey);
    return value is String && value.isNotEmpty ? value : null;
  }

  Future<void> saveSelectedExamId(String examId) {
    return _store.put(_selectedExamKey, examId);
  }

  bool getDarkMode() {
    final value = _store.get(_darkModeKey, defaultValue: true);
    return value is bool ? value : true;
  }

  Future<void> saveDarkMode(bool value) {
    return _store.put(_darkModeKey, value);
  }

  Map<String, bool> getTopicCompletion() {
    final raw = _store.get(_topicCompletionKey);
    final completion = <String, bool>{};

    // Hive stores dynamic maps without generated adapters, so each value is
    // normalized before it reaches the app state.
    if (raw is Map) {
      raw.forEach((key, value) {
        completion[key.toString()] = value == true;
      });
    }

    return completion;
  }

  Future<void> saveTopicCompletion(Map<String, bool> completion) {
    return _store.put(_topicCompletionKey, completion);
  }

  Map<String, DailyStudyLog> getDailyLogs() {
    final raw = _store.get(_dailyLogsKey);
    final logs = <String, DailyStudyLog>{};

    if (raw is Map) {
      raw.forEach((key, value) {
        if (value is Map) {
          final normalized = <String, dynamic>{};
          value.forEach((entryKey, entryValue) {
            normalized[entryKey.toString()] = entryValue;
          });

          final log = DailyStudyLog.fromMap(normalized);
          if (log.dateKey.isNotEmpty) {
            logs[log.dateKey] = log;
          }
        }
      });
    }

    return logs;
  }

  Future<void> saveDailyLogs(Map<String, DailyStudyLog> logs) {
    final serializable = logs.map(
      (key, value) => MapEntry(key, value.toMap()),
    );
    return _store.put(_dailyLogsKey, serializable);
  }

  Future<void> clearAll() {
    return _store.clear();
  }
}
