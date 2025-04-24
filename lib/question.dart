import 'dart:convert';
import 'package:http/http.dart' as http;


class Question {
  final String question;
  final List<String> options;
  final int answer;

  Question({required this.question, required this.options, required this.answer});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'] as String,
      options: List<String>.from(json['options']),
      answer: json['answer'] as int,
    );
  }
}

Future<List<Question>> fetchQuestions() async {
  final response = await http.get(Uri.parse('https://flutter-quiz-app-production.up.railway.app/getQuestions'));

  if (response.statusCode == 200) {
    List<dynamic> body = jsonDecode(response.body);
    List<Question> questions = body.map((dynamic item) => Question.fromJson(
        item)).toList();
    return questions;
  } else {
    throw Exception('Failed to load questions');
  }
}







