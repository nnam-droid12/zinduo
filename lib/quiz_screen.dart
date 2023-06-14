import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> questions = [
    Question('sweet mother', ['a. Ke', 'b. Nnem oma', 'c. amofia'], 1),
    Question('cap', ['a. Ke', 'b. okpu', 'c. amofia'], 1),
    Question('school', ['a. Ke', 'b. Nnem oma', 'c. amofia'], 0),
  ];

  int selectedAnswerIndex = -1;
  int score = 0;
  FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zinduo'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: _getTileColor(index),
                  title: Text(
                    questions[index].question,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    children: [
                      for (int i = 0; i < questions[index].answers.length; i++)
                        ListTile(
                          title: Text(
                            questions[index].answers[i],
                            style: TextStyle(
                              color: _getTextColor(index, i),
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              selectedAnswerIndex = i;
                              if (questions[index].correctAnswerIndex == i) {
                                score++;
                              }
                            });
                          },
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _speakResults();
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.green),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            child: const Text('Check Results',
                style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  Color _getTileColor(int index) {
    if (selectedAnswerIndex != -1) {
      if (selectedAnswerIndex == questions[index].correctAnswerIndex) {
        return Colors.green;
      } else {
        return Colors.red;
      }
    }
    return Colors.green;
  }

  Color _getTextColor(int index, int answerIndex) {
    if (selectedAnswerIndex != -1) {
      if (selectedAnswerIndex == questions[index].correctAnswerIndex &&
          selectedAnswerIndex == answerIndex) {
        return Colors.white;
      } else if (selectedAnswerIndex != questions[index].correctAnswerIndex &&
          selectedAnswerIndex == answerIndex) {
        return Colors.white;
      }
    }
    return Colors.white;
  }

  void _speakResults() {
    String message;
    if (score == 3) {
      message = 'Congratulations! You got 3 out of 3!';
    } else {
      message = 'Better luck next time! You got $score out of 3.';
    }

    flutterTts.speak(message);
  }
}

class Question {
  final String question;
  final List<String> answers;
  final int correctAnswerIndex;

  Question(this.question, this.answers, this.correctAnswerIndex);
}
