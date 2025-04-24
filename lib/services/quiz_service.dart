import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:myapp/models/question.dart';

class QuizService {
  final String _connectionString = 'mongodb+srv://hboubaker59:aSMsAY9OApz0hjcM@apps.tkxquq8.mongodb.net/quiz_app?retryWrites=true&w=majority';

  Future<List<Question>> fetchQuestions() async {
    final db = await mongo.Db.create(_connectionString);
    try {
      print("1. Opening database connection...");
      await db.open();
      print("2. Database connection opened.");

      final questionsCollection = db.collection('questions');
      print("3. Accessed 'questions' collection.");

      final questions = await questionsCollection.find().toList();
      print("4. Fetched questions: $questions");

      List<Question> list = questions
              .map((e) => Question.fromJson({
                    'question': e['question'],
                    'options': List<String>.from(e['options']),
                    'answer': e['answer']
                  }))
              .toList();
      print("5. Converted to Question objects: $list");
      return list;
    } catch (e) {
      print('Error connecting to MongoDB: $e');
      return [];
    } finally {
      print("6. Closing database connection.");
      await db.close();
    }
  }

  Future<void> sendResult(String playerName, int score) async {
    final db = await mongo.Db.create(_connectionString);
    try {
      await db.open();

      final resultsCollection = db.collection('results');

      await resultsCollection.insertOne({
        'joueur': playerName,
        'score': score,
        'date': DateTime.now().toIso8601String(),
      });
      print("result stored correctly");
    } catch (e) {
      print('Error connecting to MongoDB: $e');
    } finally {
      await db.close();
    }
  }
}