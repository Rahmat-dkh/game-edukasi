import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';

class SusunHurufPage extends StatefulWidget {
  const SusunHurufPage({super.key});

  @override
  State<SusunHurufPage> createState() => _SusunHurufPageState();
}

class _SusunHurufPageState extends State<SusunHurufPage> {
  // Game Data
  final List<String> _words = ["BUKU", "MEJA", "GURU", "SEKOLAH", "PENSIL", "EDUKASI"];
  late String _targetWord;
  late List<String> _shuffledLetters;
  List<String> _currentAns = [];
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _startNewRound();
  }

  void _startNewRound() {
    _targetWord = _words[Random().nextInt(_words.length)];
    _shuffledLetters = _targetWord.split('')..shuffle();
    _currentAns = [];
    setState(() {});
  }

  void _onLetterTap(String letter) {
    setState(() {
      if (_currentAns.length < _targetWord.length) {
        _currentAns.add(letter);
        
        // Remove one instance of this letter from available options (optional logic, keeping it simple for now)
        // If we want to make it strict, we should find the first index of letter in shuffled and "use" it.
        // For simplicity: We keep allowing taps, but maybe disable used buttons visually?
        // Let's implement "Remove from option" logic for better ux
        int index = _shuffledLetters.indexOf(letter);
        if (index != -1) {
           _shuffledLetters.removeAt(index);
        }
      }
    });

    if (_currentAns.length == _targetWord.length) {
      _checkAnswer();
    }
  }

  void _checkAnswer() {
    if (_currentAns.join() == _targetWord) {
      // Correct!
      setState(() {
        _score += 50;
      });
      
      // Save XP
      final user = AuthService().currentUser;
      if (user != null) {
        FirestoreService().updateUserXP(user.uid, 50);
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text("Hebat! Benar! 🎉"),
          content: Text("Kata yang benar adalah $_targetWord"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _startNewRound();
              },
              child: const Text("Lanjut"),
            )
          ],
        ),
      );
    } else {
      // Wrong
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Masih salah, coba lagi! 😅"), backgroundColor: AppColors.error),
      );
      // Reset current round logic slightly to give chance to retry or just clear
      Future.delayed(const Duration(milliseconds: 1000), () {
        _resetRound();
      });
    }
  }

  void _resetRound() {
    setState(() {
      // Put letters back
      _shuffledLetters.addAll(_currentAns); 
      // Shuffle again or just keep remaining? Let's just restore logic strictly
      // Actually easier: just restart this specific word logic
      _shuffledLetters = _targetWord.split('')..shuffle();
      _currentAns.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Susun Huruf"), backgroundColor: AppColors.pastelGreen),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text("Skor: $_score", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary)),
            ).animate().slideY(begin: -1, end: 0),
            
            const Spacer(),
            
            // Display Slots
            Wrap(
              spacing: 8,
              children: List.generate(_targetWord.length, (index) {
                String? char = index < _currentAns.length ? _currentAns[index] : null;
                return Container(
                  width: 50,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.pastelGreen, width: 2),
                    boxShadow: [
                      BoxShadow(color: AppColors.pastelGreen.withOpacity(0.2), blurRadius: 4, offset:const Offset(0, 4))
                    ]
                  ),
                  child: Center(
                    child: Text(
                      char ?? "",
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ),
                ).animate(target: char != null ? 1 : 0).scale(duration: 200.ms, curve: Curves.elasticOut);
              }),
            ),
            
            const SizedBox(height: 20),
            const Text("Susun huruf menjadi kata yang benar!", style: TextStyle(color: AppColors.textSecondary)),
            const Spacer(),
            
            // Letter Choice Buttons
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: _shuffledLetters.map((letter) {
                return SizedBox(
                  width: 60,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () => _onLetterTap(letter),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pastelGreen,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      letter, 
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                    ),
                  ),
                ).animate().scale();
              }).toList(),
            ),
            
            const SizedBox(height: 40),
            
            TextButton.icon(
              onPressed: _resetRound,
              icon: const Icon(Icons.refresh),
              label: const Text("Reset Kata Ini"),
              style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
