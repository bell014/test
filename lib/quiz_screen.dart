import 'package:flutter/material.dart';
import 'package:myapp/result_screen.dart';
import 'package:myapp/question.dart'; // Import the Question class

// Import the Question class
class QuizScreen extends StatefulWidget {
  final String playerName;

  QuizScreen({required this.playerName});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<Question>> futureQuestions; // Get the list of questions
  int currentQuestionIndex = 0;
  int score = 0;
  bool answerChecked = false;
  int? selectedAnswerIndex;
  @override
  void initState() {
    super.initState();
    futureQuestions = fetchQuestionsFromMongo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: FutureBuilder<List<Question>>(
        future: futureQuestions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No questions available."));
          } else {
            List<Question> questions = snapshot.data!;
             if (currentQuestionIndex >= questions.length) {
              // All questions have been answered, navigate to results screen
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResultScreen(
                          playerName: widget.playerName, score: score)),
                );
              });
              return Container(); // Return an empty container if navigated
            }
            Question currentQuestion = questions[currentQuestionIndex];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    currentQuestion.question,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ...currentQuestion.options.asMap().entries.map((entry) {
                    int index = entry.key;
                    String option = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: answerChecked ? null : () {
                          setState(() {
                            selectedAnswerIndex = index;
                            answerChecked = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedAnswerIndex == index
                              ? (index == currentQuestion.answer
                                  ? Colors.green
                                  : Colors.red)
                              : null,
                        ),
                        child: Text(option),
                      ),
                    );
                  }).toList(),
                  SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: answerChecked
                          ? () {
                              _nextQuestion(questions);
                            }
                          : null,
                      child: Text(currentQuestionIndex < questions.length - 1
                          ? 'Next Question'
                          : 'Show Result'))
                ],
              ),
            );
          }
        },
      ),
    );
  }

    void _nextQuestion(List<Question> questions) {
    if (selectedAnswerIndex == questions[currentQuestionIndex].answer) {
      score++;
    }
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        answerChecked = false;
        selectedAnswerIndex = null;
      });
    } else {
      // All questions answered, navigate to results (this now shouldn't be reached as handled in build)
    }
  }
}