import 'package:flutter/material.dart';
import 'package:myapp/services/quiz_service.dart';

class ResultViewModel extends ChangeNotifier {
  final QuizService _quizService = QuizService();

  Future<void> sendResult(String playerName, int score) async {
    await _quizService.sendResult(playerName, score);
  }
}