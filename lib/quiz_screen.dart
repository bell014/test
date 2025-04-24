import 'package:flutter/material.dart';
import 'package:myapp/result_screen.dart';
import 'package:myapp/models/question.dart';
import 'package:myapp/viewmodels/quiz_viewmodel.dart';
import 'package:provider/provider.dart';

class QuizScreen extends StatefulWidget {
  final String playerName;

  const QuizScreen({Key? key, required this.playerName}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  void initState() {
    super.initState();
    context.read<QuizViewModel>().fetchQuestions();
  }

  @override
  Widget build(BuildContext context) {
    final quizViewModel = context.watch<QuizViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: quizViewModel.questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Consumer<QuizViewModel>(
              builder: (context, viewModel, child) {
                Question currentQuestion = viewModel.questions[viewModel.currentQuestionIndex];

                return SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              currentQuestion.question,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          ...currentQuestion.options.map((option) {
                            int optionIndex = currentQuestion.options.indexOf(option);
                            Color? tileColor;

                            if (viewModel.selectedAnswerIndex == optionIndex) {
                              if (viewModel.answerChecked) {
                                tileColor = optionIndex == currentQuestion.answer
                                    ? Colors.green
                                    : Colors.red;
                              } else {
                                tileColor = Colors.blue[200];
                              }
                            } else {
                              tileColor = Colors.white;
                            }

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                tileColor: tileColor,
                                title: Text(option),
                                onTap: () {
                                  viewModel.selectAnswer(optionIndex);
                                },
                              ),
                            );
                          }).toList(),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                if (!viewModel.answerChecked) {
                                  viewModel.checkAnswer();
                                } else {
                                  if (viewModel.isLastQuestion()) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ResultScreen(
                                          playerName: widget.playerName,
                                          score: viewModel.score,
                                        ),
                                      ),
                                    );
                                  } else {
                                    viewModel.goToNextQuestion();
                                  }
                                }
                              },
                              child: Text(viewModel.answerChecked
                                  ? viewModel.isLastQuestion()
                                      ? "See Result"
                                      : "Next"
                                  : "Check"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
