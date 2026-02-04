class LessonState {
  String lessonMode;
  String lessonType;
  int duration;

  LessonState({
    required this.lessonMode,
    required this.lessonType,
    required this.duration,
  });
}

LessonState lessonStates = LessonState(lessonMode: "", lessonType: "", duration: 2);