import 'package:flutter/material.dart';
import 'package:myapp/viewmodels/result_viewmodel.dart';
import 'package:provider/provider.dart';

class ResultScreen extends StatefulWidget {
  final String playerName;
  final int score;

  const ResultScreen({
    Key? key,
    required this.playerName,
    required this.score,
  }) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    super.initState();
    // Send the result after the widget has been built
    Future.microtask(() {
      context.read<ResultViewModel>().sendResult(widget.playerName, widget.score);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Player Name: ${widget.playerName}',
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              'Score: ${widget.score}',
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
