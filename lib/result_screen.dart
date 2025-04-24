import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapp/quiz_screen.dart';
import 'package:http/http.dart' as http;

class ResultScreen extends StatefulWidget {
  final String playerName;
  final int score;

  ResultScreen({required this.playerName, required this.score});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Future<void> sendResult() async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/storeResult'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'joueur': widget.playerName,
        'score': widget.score,
        'date': DateTime.now().toIso8601String(),
      }),
    );
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