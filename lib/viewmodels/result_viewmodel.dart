import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:myapp/services/quiz_service.dart';

class ResultViewModel extends ChangeNotifier {
  final QuizService _quizService = QuizService();

   Future<void> sendResult(String playerName, int score) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/results'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{'joueur': playerName, 'score': score}),
      );
      print("result stored correctly");
    } catch (e) {
       print('Error sending result: $e');
    }
  }
}