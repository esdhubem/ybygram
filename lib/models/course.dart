class LessonItem {
  final String id;
  final String title;
  final String duration;
  final String videoEmbedUrl;
  final String summary;
  bool isCompleted;

  LessonItem({
    required this.id,
    required this.title,
    required this.duration,
    required this.videoEmbedUrl,
    required this.summary,
    this.isCompleted = false,
  });
}

class CourseModule {
  final String id;
  final String title;
  final String description;
  final List<LessonItem> lessons;

  const CourseModule({
    required this.id,
    required this.title,
    required this.description,
    required this.lessons,
  });

  int get totalLessons => lessons.length;
  int get completedLessons => lessons.where((l) => l.isCompleted).length;
  bool get isCompleted => completedLessons == totalLessons;
}
