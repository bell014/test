import 'package:flutter/material.dart';
import 'package:myapp/quiz_screen.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:flutter/foundation.dart';
class ResultScreen extends StatefulWidget {
  final String playerName;
  final int score;

  ResultScreen({required this.playerName, required this.score});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
    Future<void> sendResult() async {
        final db = await Db.create(
          'mongodb+srv://hboubaker59:aSMsAY9OApz0hjcM@apps.tkxquq8.mongodb.net/quiz_app?retryWrites=true&w=majority',
        );
        try {
          await db.open();

          final resultsCollection = db.collection('results');

          await resultsCollection.insertOne({
            'joueur': widget.playerName,
            'score': widget.score,
            'date': DateTime.now().toIso8601String(),
          });
          print("result stored correctly");

        } catch (e) {
          print('Error connecting to MongoDB: $e');
        } finally {
          await db.close();
        }
      }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Results'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Player Name: ${widget.playerName}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Score: ${widget.score}',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
                onPressed: sendResult,
                child: Text(
                  "Send Result",
                  style: TextStyle(fontSize: 24),
                )),
          ],
        ),
      ),
    );
  }
}