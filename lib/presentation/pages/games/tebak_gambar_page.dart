import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';

class TebakGambarPage extends StatefulWidget {
  const TebakGambarPage({super.key});

  @override
  State<TebakGambarPage> createState() => _TebakGambarPageState();
}

class _TebakGambarPageState extends State<TebakGambarPage> {
  int _currentIndex = 0;
  int _score = 0;
  bool _isAnswered = false;

  final List<Map<String, dynamic>> _questions = [
    {
      'image': 'assets/images/gunung.png',
      'answer': 'Gunung',
      'options': ['Gunung', 'Bukit', 'Lembah', 'Dataran'],
    },
    {
      'image': 'assets/images/sungai.png',
      'answer': 'Sungai',
      'options': ['Danau', 'Sungai', 'Laut', 'Selokan'],
    },
    {
      'image': 'assets/images/hutan.png',
      'answer': 'Hutan',
      'options': ['Taman', 'Kebun', 'Hutan', 'Sawah'],
    },
    {
      'image': 'assets/images/rumah.png',
      'answer': 'Rumah',
      'options': ['Gedung', 'Sekolah', 'Rumah', 'Kantor'],
    },
    {
      'image': 'assets/images/jembatan.png',
      'answer': 'Jembatan',
      'options': ['Jalan', 'Jembatan', 'Terowongan', 'Rel'],
    },
  ];

  void _checkAnswer(String selectedAnswer) {
    if (_isAnswered) return;

    setState(() {
      _isAnswered = true;
      if (selectedAnswer == _questions[_currentIndex]['answer']) {
        _score += 20;
        _showFeedback(true);
      } else {
        _showFeedback(false);
      }
    });
  }

  void _showFeedback(bool isCorrect) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isCorrect ? "Benar! +20 XP" : "Salah! Jawaban: ${_questions[_currentIndex]['answer']}"),
        backgroundColor: isCorrect ? AppColors.success : AppColors.error,
        duration: const Duration(seconds: 1),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        if (_currentIndex < _questions.length - 1) {
          setState(() {
            _currentIndex++;
            _isAnswered = false;
          });
        } else {
          _showResult();
        }
      }
    });
  }

  void _showResult() {
    // Save XP
     final user = AuthService().currentUser;
     if (user != null) {
       FirestoreService().updateUserXP(user.uid, _score);
     }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Selesai!"),
        content: Text("Skor Kamu: $_score"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _currentIndex = 0;
                _score = 0;
                _isAnswered = false;
                _questions.shuffle();
              });
            },
            child: const Text("Main Lagi"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Keluar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Tebak Gambar"),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text("Skor: $_score", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Gambar apakah ini?",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    question['image'],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  final option = question['options'][index];
                  return ElevatedButton(
                    onPressed: () => _checkAnswer(option),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      option,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
