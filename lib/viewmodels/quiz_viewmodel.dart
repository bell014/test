// lib/viewmodels/quiz_viewmodel.dart
import 'package:flutter/foundation.dart';
import 'package:myapp/models/question.dart';
import 'package:myapp/services/quiz_service.dart';

class QuizViewModel extends ChangeNotifier {
  final QuizService _quizService = QuizService();
  List<Question> _questions = [];
  List<Question> get questions => _questions;
  int _currentQuestionIndex = 0;
  int get currentQuestionIndex => _currentQuestionIndex;
  int _score = 0;
  int get score => _score;
  bool _answerChecked = false;
  bool get answerChecked => _answerChecked;
  int? _selectedAnswerIndex;
  int? get selectedAnswerIndex => _selectedAnswerIndex;

  Future<void> fetchQuestions() async {
    _questions = await _quizService.fetchQuestions();
    notifyListeners();
  }

  void checkAnswer() {
    if (!_answerChecked) {
      _answerChecked = true;
      if (_selectedAnswerIndex == _questions[_currentQuestionIndex].answer) {
        _score++;
      }
    }
    notifyListeners();
  }

  void goToNextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      _answerChecked = false;
      _selectedAnswerIndex = null;
    }
    notifyListeners();
  }

  void selectAnswer(int index) {
    if (!_answerChecked) {
      _selectedAnswerIndex = index;
      notifyListeners();
    }
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    _answerChecked = false;
    _selectedAnswerIndex = null;
    notifyListeners();
  }

    bool isLastQuestion() {
    return _currentQuestionIndex == _questions.length - 1;
  }
}