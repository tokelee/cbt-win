import 'package:flutter/material.dart';

class SelectedSubject extends ChangeNotifier{
  Set<String> _selectedSubjects = {};
  
  Set<String> get selectedSubjects => _selectedSubjects;

  void changeSubject({
    required Set<String> newSelectedSubjects,
  }) async {
    _selectedSubjects = newSelectedSubjects;
    notifyListeners();
  }

}