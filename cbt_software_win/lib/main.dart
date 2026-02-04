import 'package:cbt_software_win/core/theme/theme.dart';
import 'package:cbt_software_win/providers/lesson_state_provider.dart';
import 'package:cbt_software_win/providers/selected_subjects_provider.dart';
import 'package:cbt_software_win/providers/user_provider.dart';
import 'package:cbt_software_win/screens/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => SelectedSubject()),
        ChangeNotifierProvider(create: (context) => LessonStateProvider()),
      ],
      child: MaterialApp(
      title: 'Computer Based Test',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dartThemeMode,
      home: const IndexScreen(),
      // home: PractiseTestScreen(),
    )
    );
  }
}
