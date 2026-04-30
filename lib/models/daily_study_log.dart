class DailyStudyLog {
  const DailyStudyLog({
    required this.dateKey,
    required this.hoursStudied,
    required this.tasksCompleted,
    required this.updatedAt,
  });

  final String dateKey;
  final double hoursStudied;
  final int tasksCompleted;
  final DateTime updatedAt;

  bool get isProductiveDay => hoursStudied > 0 || tasksCompleted > 0;

  Map<String, dynamic> toMap() {
    return {
      'dateKey': dateKey,
      'hoursStudied': hoursStudied,
      'tasksCompleted': tasksCompleted,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory DailyStudyLog.fromMap(Map<String, dynamic> map) {
    return DailyStudyLog(
      dateKey: map['dateKey']?.toString() ?? '',
      hoursStudied: _readDouble(map['hoursStudied']),
      tasksCompleted: _readInt(map['tasksCompleted']),
      updatedAt: DateTime.tryParse(map['updatedAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  static double _readDouble(dynamic value) {
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int _readInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is double) {
      return value.round();
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
