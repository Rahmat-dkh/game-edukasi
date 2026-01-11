import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';

class PuzzlePage extends StatefulWidget {
  const PuzzlePage({super.key});

  @override
  State<PuzzlePage> createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
  // 3x3 Grid
  List<int> _tiles = List.generate(9, (index) => index); // 0-8
  bool _isSolved = false;

  @override
  void initState() {
    super.initState();
    _shuffle();
  }

  void _shuffle() {
    setState(() {
      _tiles.shuffle();
      _isSolved = false;
    });
  }

  void _checkSolved() {
    bool solved = true;
    for (int i = 0; i < _tiles.length - 1; i++) {
      if (_tiles[i] != i) {
        solved = false;
        break;
      }
    }
    // Check if the last one is 8 (empty)
    if (_tiles[8] != 8) solved = false;

    if (solved) {
      setState(() {
        _isSolved = true;
      });
      
      // Save XP
      final user = AuthService().currentUser;
      if (user != null) {
        FirestoreService().updateUserXP(user.uid, 50); // Fixed 50 XP for puzzle
      }

      _showWinDialog();
    }
  }

  void _showWinDialog() {
    showDialog(
       context: context,
       builder: (context) => AlertDialog(
        title: const Text("Puzzle Selesai! 🎉"),
        content: const Text("Wow! Kamu pintar sekali!"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))
        ],
       )
    );
  }

  void _moveTile(int index) {
    if (_isSolved) return;
    
    // Only moving logic for a simple demo (swap if adjacent to empty)
    // Find empty tile index (8)
    int emptyIndex = _tiles.indexOf(8);
    
    // Check if adjacent (simplified: same row or same column with diff 1/3)
    // This is a rough check for 3x3 grid indices 0..8
    // Row diff
    int row1 = index ~/ 3;
    int row2 = emptyIndex ~/ 3;
    int col1 = index % 3;
    int col2 = emptyIndex % 3;

    if ((row1 == row2 && (col1 - col2).abs() == 1) ||
        (col1 == col2 && (row1 - row2).abs() == 1)) {
       setState(() {
         // Swap
         int temp = _tiles[index];
         _tiles[index] = _tiles[emptyIndex];
         _tiles[emptyIndex] = temp;
       });
       _checkSolved();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Puzzle Jigsaw"), backgroundColor: AppColors.pastelPurple),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _isSolved ? "SELESAI!" : "Urutkan Angka 1-8",
                  style: TextStyle(
                    fontSize: 24, 
                    fontWeight: FontWeight.bold, 
                    color: _isSolved ? Colors.green : AppColors.textPrimary
                  ),
                ),
              ).animate().fadeIn().slideY(),
              const SizedBox(height: 32),
              Container(
                width: 320,
                height: 320,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))
                  ]
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                  ),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    // If tile is 8, it's the empty slot
                    bool isEmpty = _tiles[index] == 8;
                    return GestureDetector(
                      onTap: () => _moveTile(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isEmpty ? Colors.grey[100] : AppColors.pastelPurple,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: isEmpty ? [] : [
                             BoxShadow(color: AppColors.pastelPurple.withOpacity(0.4), blurRadius: 0, offset: const Offset(0, 4))
                          ]
                        ),
                        child: Center(
                          child: Text(
                            isEmpty ? "" : "${_tiles[index] + 1}",
                            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _shuffle,
                icon: const Icon(Icons.refresh),
                label: const Text("Acak Ulang", style: TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  elevation: 0,
                  side: const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
