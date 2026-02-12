import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cbt_software_win/database/helper/app_database_helper.dart';
import 'package:cbt_software_win/database/json/subject_json.dart';
import 'package:cbt_software_win/providers/lesson_state_provider.dart';
import 'package:cbt_software_win/providers/selected_subjects_provider.dart';
import 'package:cbt_software_win/screens/lesson/jamb/cutomize_lesson.dart';
import 'package:cbt_software_win/screens/lesson/jamb/test_screen/mock.dart';
import 'package:cbt_software_win/screens/lesson/jamb/test_screen/practice.dart';
import 'package:cbt_software_win/screens/lesson/jamb/test_screen/study.dart';
import 'package:cbt_software_win/widgets/button.dart';
import 'package:cbt_software_win/widgets/navbar.dart';

class SelectJambCourse extends StatefulWidget {
  const SelectJambCourse({super.key});

  @override
  State<SelectJambCourse> createState() => _SelectJambCourseState();
}

class _SelectJambCourseState extends State<SelectJambCourse> {
  final Set<String> selectedCourses = {};
  final AppDatabaseHelper db = AppDatabaseHelper();

  late Future<List<SubjectJson>> generalSubjects;
  late Future<List<SubjectJson>> scienceSubjects;
  late Future<List<SubjectJson>> businessSubjects;
  late Future<List<SubjectJson>> humanitySubjects;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    generalSubjects = db.getSubjects("general");
    scienceSubjects = db.getSubjects("science");
    businessSubjects = db.getSubjects("business");
    humanitySubjects = db.getSubjects("humanity");
  }

  void _toggleSubject(String subjectName) {
    setState(() {
      if (selectedCourses.contains(subjectName)) {
        selectedCourses.remove(subjectName);
      } else if (selectedCourses.length < 4) {
        selectedCourses.add(subjectName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You can only select up to 4 subjects")),
        );
      }
    });
    // Sync with Provider
    context.read<SelectedSubject>().changeSubject(newSelectedSubjects: selectedCourses);
  }

  void _handleNavigation(String type) {
    Widget target;
    if (type == "study") {
      target = const StudyScreen();
    } else if (type == "practice") target = const PractiseTestScreen();
    else if (type == "mock") target = const MockScreen();
    else return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => target),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final lessonState = context.watch<LessonStateProvider>().lessonStateItems;
    final isCustomized = lessonState.lessonMode == "customized";

    return Scaffold(
      backgroundColor: const Color.fromRGBO(240, 255, 255, 1),
      body: Column(
        children: [
          const Navbar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 800),
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 7)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(isCustomized, lessonState.lessonType),
                      const SizedBox(height: 20),
                      Text(
                        "Selected: ${selectedCourses.length} / 4",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                      ),
                      const Divider(),
                      _buildSubjectSection("General Subjects", generalSubjects),
                      _buildSubjectSection("Science", scienceSubjects),
                      _buildSubjectSection("Business", businessSubjects),
                      _buildSubjectSection("Humanity", humanitySubjects),
                      const SizedBox(height: 30),
                      _buildFooterAction(isCustomized, lessonState.lessonType),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isCustomized, String lessonType) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 16),
          label: const Text("Back"),
          style: buttonAppTheme,
        ),
        const Text("Select Subjects", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        _buildTopAction(isCustomized, lessonType),
      ],
    );
  }

  Widget _buildTopAction(bool isCustomized, String lessonType) {
    if (selectedCourses.isEmpty) return const SizedBox.shrink();
    
    return isCustomized 
      ? ElevatedButton.icon(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CustomizeLessonScreen())),
          icon: const Icon(Icons.edit, color: Colors.white),
          label: const Text("Customize", style: TextStyle(color: Colors.white)),
          style: buttonDefault,
        )
      : ElevatedButton.icon(
          onPressed: () => _handleNavigation(lessonType),
          icon: const Icon(Icons.start, color: Colors.white),
          label: const Text("Start", style: TextStyle(color: Colors.white)),
          style: buttonSuccess,
        );
  }

  Widget _buildSubjectSection(String title, Future<List<SubjectJson>> future) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ),
        FutureBuilder<List<SubjectJson>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator();
            }
            if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text("No subjects available");
            }

            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: snapshot.data!.map((subject) {
                final isSelected = selectedCourses.contains(subject.subject);
                return FilterChip(
                  label: Text(subject.subject),
                  selected: isSelected,
                  selectedColor: Colors.blue.withOpacity(0.2),
                  checkmarkColor: Colors.blue,
                  onSelected: (_) => _toggleSubject(subject.subject),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFooterAction(bool isCustomized, String lessonType) {
    return Align(
      alignment: Alignment.centerRight,
      child: _buildTopAction(isCustomized, lessonType),
    );
  }
}