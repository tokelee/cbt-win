import 'package:flutter/material.dart';

class TestProvider extends ChangeNotifier{
  String subject;

  TestProvider({
    this.subject = "Mathematics",
  });

  void changeSubject({
    required String newSubject,
  }) async {
    subject = newSubject;
    notifyListeners();
  }
}