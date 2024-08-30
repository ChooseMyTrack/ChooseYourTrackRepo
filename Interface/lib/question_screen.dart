import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'final.dart';
import 'package:percent_indicator/percent_indicator.dart';

class QuestionScreen extends StatefulWidget {
  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  final List<Question> questions = [
    Question(text: "Do you have a strong interest in studying genes, proteins, and DNA?"),
    Question(text: "Are you interested in biological research and modern technologies in the medical field?"),
    // Add the rest of the questions...
  ];

  int currentQuestionIndex = 0;
  bool isSubmitting = false;
  List<int> answers = [];
  late double progress;

  @override
  void initState() {
    super.initState();
    answers = List.filled(questions.length, -1);
    progress = 0.0;
  }

  void _saveAnswer(bool answer) {
    setState(() {
      answers[currentQuestionIndex] = answer ? 1 : 0;
      _updateProgress();
    });
  }

  void _updateProgress() {
    int answered = answers.where((a) => a != -1).length;
    setState(() {
      progress = answered / questions.length;
    });
  }

  void _goToQuestion(int index) {
    setState(() {
      currentQuestionIndex = index;
    });
  }

  Future<void> _submitAnswers() async {
    setState(() {
      isSubmitting = true;
    });

    try {
      var response = await http.post(
        Uri.parse('http://localhost:5000/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'answers': answers}),
      );

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body)['track'];
        _showResult(result);
      } else {
        throw Exception('Failed to load prediction');
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  void _showResult(String result) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FinalScreen(track: result),
      ),
    );
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Color _getQuestionColor(int index) {
    if (index == currentQuestionIndex) {
      return Colors.blue;
    } else if (answers[index] != -1) {
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }

  bool _allQuestionsAnswered() {
    return !answers.contains(-1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Questionnaire',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: isSubmitting
          ? Center(child: CircularProgressIndicator())
          : Row(
        children: [
          // Sidebar with quiz info and question navigation
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('QUIZ INFO'),
                  _buildInfoCard([
                    _buildQuizInfoRow('Topic:', 'Which Track Suits you'),
                    _buildQuizInfoRow('Quiz:', 'Track Prediction'),
                    _buildQuizInfoRow('Time Limit:', 'Varies'),
                  ]),
                  SizedBox(height: 20),
                  _buildSectionTitle('TIMING INFO'),
                  _buildInfoCard([
                    CircularPercentIndicator(
                      radius: 60.0,
                      lineWidth: 8.0,
                      percent: progress,
                      center: Text(
                        "${(progress * 100).toStringAsFixed(0)}%",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.deepPurple,
                        ),
                      ),
                      progressColor: Colors.deepPurpleAccent,
                      backgroundColor: Colors.black,
                    ),
                    SizedBox(height: 10),
                    Text(
                      '${answers.where((a) => a != -1).length} of ${questions.length} Answered',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ]),
                  SizedBox(height: 20),
                  Divider(color: Colors.grey),
                  _buildSectionTitle('Question Navigation'),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5, // 5 questions per row
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _goToQuestion(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _getQuestionColor(index),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: index == currentQuestionIndex
                                    ? Colors.deepPurpleAccent
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Separation line
          Container(
            width: 2,
            color: Colors.grey[300],
          ),
          // Main content
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(24.0), // Slightly increased padding
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: (currentQuestionIndex + 1) / questions.length,
                    backgroundColor: Colors.grey[300],
                    color: Colors.deepPurpleAccent,
                    minHeight: 8,
                  ),
                  SizedBox(height: 24), // Increased space
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0), // Increased padding inside the card
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Question ${currentQuestionIndex + 1}',
                            style: TextStyle(
                              fontSize: 24, // Slightly increased font size
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple,
                            ),
                          ),
                          SizedBox(height: 16), // Increased space
                          Text(
                            questions[currentQuestionIndex].text,
                            style: TextStyle(
                              fontSize: 26, // Slightly increased font size
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20), // Increased space
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () => _saveAnswer(true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32), // Adjusted buttons
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'Yes',
                                  style: TextStyle(
                                    fontSize: 20, // Slightly increased font size
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(width: 20), // Adjusted space between buttons
                              ElevatedButton(
                                onPressed: () => _saveAnswer(false),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32), // Adjusted buttons
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  'No',
                                  style: TextStyle(
                                    fontSize: 20, // Slightly increased font size
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24), // Increased space
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: currentQuestionIndex > 0
                            ? _previousQuestion
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey,
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Previous',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => currentQuestionIndex == questions.length - 1
                            ? _submitAnswers()
                            : _nextQuestion(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          currentQuestionIndex == questions.length - 1 ? 'Submit' : 'Next',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _nextQuestion() {
    setState(() {
      currentQuestionIndex++;
    });
  }

  void _previousQuestion() {
    setState(() {
      currentQuestionIndex--;
    });
  }

  Widget _buildQuizInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

class Question {
  final String text;

  Question({required this.text});
}
