import 'package:mongo_dart/mongo_dart.dart';


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

Future<List<Question>> fetchQuestionsFromMongo() async {
    // Connection string
    final db = await Db.create(
      'mongodb+srv://hboubaker59:aSMsAY9OApz0hjcM@apps.tkxquq8.mongodb.net/quiz_app?retryWrites=true&w=majority',
    );

    try {
      // Open connection
      await db.open();
      // Access collection 'questions'
      final questionsCollection = db.collection('questions');
      // Fetch all documents
      final questions = await questionsCollection.find().toList();
      return questions.map((e) => Question.fromJson(e)).toList();
    } catch (e) {
      print('Error connecting to MongoDB: $e');
      return [];
    } finally {
      await db.close();
    }
  }







