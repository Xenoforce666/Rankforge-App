import 'dart:math';

import 'package:flutter/foundation.dart';

import '../core/constants/exam_data.dart';
import '../core/utils/date_keys.dart';
import '../data/local/local_storage.dart';
import '../models/daily_study_log.dart';
import '../models/exam_model.dart';

class PrepQuestProvider extends ChangeNotifier {
  PrepQuestProvider(this._storage);

  static const int xpPerLevel = 250;

  final LocalStorage _storage;

  bool _isLoaded = false;
  bool _isDarkMode = true;
  String _username = 'Aspirant';
  String? _selectedExamId;
  Map<String, bool> _topicCompletion = {};
  Map<String, DailyStudyLog> _dailyLogs = {};

  bool get isLoaded => _isLoaded;
  bool get isDarkMode => _isDarkMode;
  String get username => _username;
  String? get selectedExamId => _selectedExamId;
  List<ExamModel> get exams => ExamData.exams;

  ExamModel? get selectedExam => ExamData.byId(_selectedExamId);
  bool get hasSelectedExam => selectedExam != null;

  Future<void> load() async {
    _username = _storage.getUsername();
    _selectedExamId = _storage.getSelectedExamId();
    _isDarkMode = _storage.getDarkMode();
    _topicCompletion = _storage.getTopicCompletion();
    _dailyLogs = _storage.getDailyLogs();
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> selectExam(String examId) async {
    _selectedExamId = examId;
    await _storage.saveSelectedExamId(examId);
    notifyListeners();
  }

  Future<void> setUsername(String username) async {
    final cleanName = username.trim().isEmpty ? 'Aspirant' : username.trim();
    _username = cleanName;
    await _storage.saveUsername(cleanName);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    await _storage.saveDarkMode(value);
    notifyListeners();
  }

  String _completionKey(ExamModel exam, SubjectModel subject, TopicModel topic) {
    return '${exam.id}.${subject.id}.${topic.id}';
  }

  bool isTopicComplete(ExamModel exam, SubjectModel subject, TopicModel topic) {
    return _topicCompletion[_completionKey(exam, subject, topic)] == true;
  }

  Future<void> toggleTopic(
    ExamModel exam,
    SubjectModel subject,
    TopicModel topic,
    bool isComplete,
  ) async {
    _topicCompletion[_completionKey(exam, subject, topic)] = isComplete;
    await _storage.saveTopicCompletion(_topicCompletion);
    notifyListeners();
  }

  int completedTopicsForSubject(ExamModel exam, SubjectModel subject) {
    return subject.topics.where((topic) => isTopicComplete(exam, subject, topic)).length;
  }

  double subjectProgress(ExamModel exam, SubjectModel subject) {
    if (subject.topics.isEmpty) {
      return 0;
    }
    return completedTopicsForSubject(exam, subject) / subject.topics.length;
  }

  int get completedTopicCount {
    final exam = selectedExam;
    if (exam == null) {
      return 0;
    }

    var count = 0;
    for (final subject in exam.subjects) {
      count += completedTopicsForSubject(exam, subject);
    }
    return count;
  }

  double get syllabusProgress {
    final exam = selectedExam;
    if (exam == null || exam.topicCount == 0) {
      return 0;
    }
    return completedTopicCount / exam.topicCount;
  }

  int get progressPercent => (syllabusProgress * 100).round();

  DailyStudyLog? logForDate(DateTime date) {
    return _dailyLogs[DateKeys.forDate(date)];
  }

  DailyStudyLog? get todayLog => logForDate(DateTime.now());

  double get todayHours => todayLog?.hoursStudied ?? 0;
  int get todayTasks => todayLog?.tasksCompleted ?? 0;

  double get todayTargetHours {
    return selectedExam?.dailyTargetHours ?? 4;
  }

  int get todayTargetTasks {
    return selectedExam?.baseTargetTasks ?? 4;
  }

  double get todayTargetProgress {
    if (todayTargetHours <= 0) {
      return 0;
    }
    return min(todayHours / todayTargetHours, 1);
  }

  Future<void> saveDailyLog({
    required double hoursStudied,
    required int tasksCompleted,
  }) async {
    final key = DateKeys.forDate(DateTime.now());
    final log = DailyStudyLog(
      dateKey: key,
      hoursStudied: hoursStudied,
      tasksCompleted: tasksCompleted,
      updatedAt: DateTime.now(),
    );

    _dailyLogs[key] = log;
    await _storage.saveDailyLogs(_dailyLogs);
    notifyListeners();
  }

  bool _hasProductiveLogOn(DateTime date) {
    return logForDate(date)?.isProductiveDay ?? false;
  }

  int get currentStreak {
    final today = DateKeys.startOfDay(DateTime.now());
    var cursor = _hasProductiveLogOn(today) ? today : today.subtract(const Duration(days: 1));
    var streak = 0;

    // The streak remains alive during the current day until the user misses
    // the whole day. Saving today's study immediately extends it.
    while (_hasProductiveLogOn(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }

    return streak;
  }

  List<DateTime> get weekDays => DateKeys.lastSevenDays();

  double hoursForDate(DateTime date) {
    return logForDate(date)?.hoursStudied ?? 0;
  }

  int tasksForDate(DateTime date) {
    return logForDate(date)?.tasksCompleted ?? 0;
  }

  double get weeklyConsistency {
    final productiveDays = weekDays.where(_hasProductiveLogOn).length;
    return productiveDays / 7;
  }

  double get totalHours {
    return _dailyLogs.values.fold<double>(0, (total, log) => total + log.hoursStudied);
  }

  int get totalTasks {
    return _dailyLogs.values.fold<int>(0, (total, log) => total + log.tasksCompleted);
  }

  int get totalXp {
    return (completedTopicCount * 15) +
        (totalHours * 10).round() +
        (totalTasks * 5) +
        (currentStreak * 20);
  }

  int get level => (totalXp ~/ xpPerLevel) + 1;
  int get xpIntoLevel => totalXp % xpPerLevel;
  int get xpToNextLevel => xpPerLevel - xpIntoLevel;
  double get levelProgress => xpIntoLevel / xpPerLevel;

  Future<void> resetData() async {
    await _storage.clearAll();
    _isDarkMode = true;
    _username = 'Aspirant';
    _selectedExamId = null;
    _topicCompletion = {};
    _dailyLogs = {};
    notifyListeners();
  }
}
