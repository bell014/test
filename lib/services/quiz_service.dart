import 'dart:convert';
import 'package:myapp/models/question.dart';
import 'package:http/http.dart' as http;

class QuizService {
  final String _baseUrl = 'http://localhost:3000';

  Future<List<Question>> fetchQuestions() async {
    final url = Uri.parse('$_baseUrl/questions');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> questionsJson = json.decode(response.body);
        List<Question> list = questionsJson.map((questionJson) {
          final List<String> options =
              List<String>.from(questionJson['options']);
          return Question.fromJson({
            'question': questionJson['question'],
            'options': options,
            'answer': questionJson['answer'],
          });
                
              }).
            .toList();
        return list;
      } else {
        print(
            'Failed to load questions. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching questions: $e');
      return [];
    }
  }

  Future<void> sendResult(String playerName, int score) async {
    final url = Uri.parse('$_baseUrl/results');
    try {
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'joueur': playerName, 'score': score}));
      if (response.statusCode == 200) {
        print('Result sent successfully');
      }
    } catch (e) {
      print('Error sending result: $e');
    }
  }
}