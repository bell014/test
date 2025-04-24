import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

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
  try {
    final String response = await rootBundle.loadString('questions.json');
    final data = json.decode(response) as List<dynamic>;
    return data.map((item) => Question.fromJson(item)).toList();
  } catch (e) {
    // Handle errors here, like logging or showing an error message
    print('Error fetching questions: $e');
    // You might want to return an empty list or throw an error
    return []; // Returning an empty list to avoid crashing
  }
}







