class ExamModel {
  const ExamModel({
    required this.id,
    required this.title,
    required this.shortTitle,
    required this.description,
    required this.dailyTargetHours,
    required this.baseTargetTasks,
    required this.subjects,
  });

  final String id;
  final String title;
  final String shortTitle;
  final String description;
  final double dailyTargetHours;
  final int baseTargetTasks;
  final List<SubjectModel> subjects;

  int get topicCount {
    return subjects.fold<int>(0, (total, subject) => total + subject.topics.length);
  }
}

class SubjectModel {
  const SubjectModel({
    required this.id,
    required this.title,
    required this.topics,
  });

  final String id;
  final String title;
  final List<TopicModel> topics;
}

class TopicModel {
  const TopicModel({
    required this.id,
    required this.title,
  });

  final String id;
  final String title;
}
