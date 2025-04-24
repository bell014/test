import 'package:flutter/material.dart';
import 'package:myapp/player_name_screen.dart'; //  Import PlayerNameScreen
import 'package:myapp/quiz_screen.dart';       //  Import QuizScreen
import 'package:http/http.dart' as http;

import 'package:myapp/result_screen.dart';     //  Import ResultsScreen
 
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tunis Quiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PlayerNameScreen(), //  Start with the PlayerNameScreen
    );
  }
}