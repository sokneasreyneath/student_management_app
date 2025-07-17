import 'package:flutter/material.dart';
import 'package:sqlite_demo/screens/add_student_screen/add_student_screens.dart';
import 'package:sqlite_demo/screens/homescreen/homescreen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "SQLite Demo",
      debugShowCheckedModeBanner: false,
      initialRoute: "/home",
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      routes: {
        "/home": (context) => Homescreen(),
        "/addStudent": (context) => AddStudentScreens(),
      },
    );
  }
}

// data[index]["id"];
// data[index]["api_feature_image"];
// data.id;
// data.name;
// data.image;
