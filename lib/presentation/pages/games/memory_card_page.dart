import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/audio_service.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';

class MemoryCardPage extends StatefulWidget {
  const MemoryCardPage({super.key});

  @override
  State<MemoryCardPage> createState() => _MemoryCardPageState();
}

class _MemoryCardPageState extends State<MemoryCardPage> {
  final List<String> _images = [
    'assets/images/gunung.png', 'assets/images/gunung.png',
    'assets/images/sungai.png', 'assets/images/sungai.png',
    'assets/images/hutan.png', 'assets/images/hutan.png',
    'assets/images/laut.png', 'assets/images/laut.png',
    'assets/images/danau.png', 'assets/images/danau.png',
    'assets/images/pantai.png', 'assets/images/pantai.png',
    'assets/images/rumah.png', 'assets/images/rumah.png',
    'assets/images/jembatan.png', 'assets/images/jembatan.png',
  ];

  late List<bool> _isFlipped;
  late List<bool> _isMatched;
  late List<String> _shuffledImages;
  
  int _score = 0;
  int _previousIndex = -1;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    _shuffledImages = List.from(_images)..shuffle();
    _isFlipped = List.generate(16, (index) => false);
    _isMatched = List.generate(16, (index) => false);
    _score = 0;
    _previousIndex = -1;
    _isProcessing = false;
    setState(() {});
  }

  void _onCardTap(int index) {
    if (_isProcessing || _isFlipped[index] || _isMatched[index]) return;

    setState(() {
      _isFlipped[index] = true;
    });

    if (_previousIndex == -1) {
      // First card flipped
      _previousIndex = index;
    } else {
      // Second card flipped, check match
      _isProcessing = true;
      if (_shuffledImages[index] == _shuffledImages[_previousIndex]) {
        // Match!
        Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              _isMatched[index] = true;
              _isMatched[_previousIndex] = true;
              _score += 100;
              _previousIndex = -1;
              _isProcessing = false;
            });
            _checkWin();
        });
      } else {
        // No Match
        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            _isFlipped[index] = false;
            _isFlipped[_previousIndex] = false;
            _previousIndex = -1;
            _isProcessing = false;
          });
        });
      }
    }
  }

  void _checkWin() {
    if (_isMatched.every((bool matched) => matched)) {
      // Save Score
      final user = AuthService().currentUser;
      if (user != null) {
        FirestoreService().updateUserXP(user.uid, _score);
      }

      AudioService().playWinSound();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Menang! 🎉", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text("Skor Akhir: $_score\nKamu hebat banget!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _startNewGame();
              },
              child: const Text("Main Lagi", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
             TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Keluar"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Memory Card"),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
             Text(
              "Cari pasangan gambar yang sama!",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: 16,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => _onCardTap(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutBack,
                      decoration: BoxDecoration(
                        color: _isFlipped[index] || _isMatched[index] 
                            ? Colors.white 
                            : AppColors.primary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                           BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: _isFlipped[index] ? 2 : 8,
                            offset: _isFlipped[index] ? const Offset(0, 2) : const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Center(
                          child: _isFlipped[index] || _isMatched[index]
                              ? Image.asset(
                                  _shuffledImages[index], 
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ).animate().scale(duration: 300.ms, curve: Curves.elasticOut)
                              : Icon(
                                  Icons.question_mark_rounded,
                                  color: Colors.white.withOpacity(0.5),
                                  size: 24,
                                ),
                        ),
                      ),
                    ),
                  ).animate().fadeIn(delay: (50 * index).ms).slideY(begin: 0.2, end: 0);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
