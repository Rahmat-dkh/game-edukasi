import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';

class HitungCepatPage extends StatefulWidget {
  const HitungCepatPage({super.key});

  @override
  State<HitungCepatPage> createState() => _HitungCepatPageState();
}

class _HitungCepatPageState extends State<HitungCepatPage> {
  int _questionCount = 1;
  int _score = 0;
  int _timeLeft = 10;
  Timer? _timer;
  
  // Current Question
  String _question = "5 + 3";
  List<int> _options = [6, 7, 8, 9];
  int _correctAnswer = 8;
  
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _handleWrongAnswer();
      }
    });
  }

  void _generateQuestion() {
    // Determine complexity based on simple logic for now
    // In real app, this would be more dynamic
    setState(() {
      _questionCount++;
      _question = "10 - 2"; // Mock
      _options = [6, 8, 4, 12];
      _correctAnswer = 8;
      _timeLeft = 10;
    });
    _startTimer();
  }

  void _handleAnswer(int answer) {
    _timer?.cancel();
    if (answer == _correctAnswer) {
      // Correct
      setState(() {
        _score += 10;
      });
      
      // Save XP
      final user = AuthService().currentUser;
      if (user != null) {
        FirestoreService().updateUserXP(user.uid, 10);
      }

      _showFeedback(true);
    } else {
      // Wrong
      _handleWrongAnswer();
    }
  }

  void _handleWrongAnswer() {
    _timer?.cancel();
    _showFeedback(false);
  }

  void _showFeedback(bool isCorrect) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(isCorrect ? "Benar! 🎉" : "Salah 😔"),
        content: Text(isCorrect ? "+10 XP" : "Coba lagi ya!"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (isCorrect) {
                _generateQuestion();
              } else {
                // Restart or Back
                Navigator.pop(context);
              }
            },
            child: const Text("Lanjut"),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Soal $_questionCount/10"),
        backgroundColor: AppColors.pastelRed,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                "Skor: $_score",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: _timeLeft / 30,
              color: AppColors.pastelRed,
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(height: 20),
            Text("Skor: $_score", style: Theme.of(context).textTheme.headlineMedium),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Text(
                _question,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ),
            const Spacer(),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                return ElevatedButton(
                  onPressed: () => _handleAnswer(_options[index]), // Changed from _checkAnswer to _handleAnswer to match existing method
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pastelRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    "${_options[index]}",
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
