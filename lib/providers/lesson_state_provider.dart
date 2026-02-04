import 'package:flutter/material.dart';
import '../core/helper/lesson_state_object.dart';

class LessonStateProvider extends ChangeNotifier {
  final LessonState _lessonStateItems = lessonStates;

  LessonState get lessonStateItems => _lessonStateItems;

  void changeLessonMode(String mode) {
    _lessonStateItems.lessonMode = mode;
    notifyListeners();
  }

  void changeLessonType(String type) {
    _lessonStateItems.lessonType = type;
    notifyListeners();
  }
}