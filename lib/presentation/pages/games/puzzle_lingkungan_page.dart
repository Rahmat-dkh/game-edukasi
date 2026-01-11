import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/audio_service.dart';

class PuzzleLingkunganPage extends StatefulWidget {
  const PuzzleLingkunganPage({super.key});

  @override
  State<PuzzleLingkunganPage> createState() => _PuzzleLingkunganPageState();
}

class _PuzzleLingkunganPageState extends State<PuzzleLingkunganPage> {
  int currentPuzzle = 0;
  List<int> puzzlePieces = [];
  bool puzzleComplete = false;
  bool showInfo = false;
  int moves = 0;

  final List<Map<String, dynamic>> puzzles = [
    {
      'nama': 'Gunung Merapi',
      'jenis': 'Alam',
      'icon': Icons.landscape,
      'image': 'assets/images/gunung.png',
      'color': AppColors.pastelGreen,
      'gridColor': AppColors.primaryLight,
      'deskripsi': 'Gunung adalah bentuk permukaan bumi yang menjulang tinggi. Gunung terbentuk secara alami.',
    },
    {
      'nama': 'Jembatan Besar',
      'jenis': 'Buatan',
      'icon': Icons.architecture,
      'image': 'assets/images/jembatan.png',
      'color': AppColors.pastelBlue,
      'gridColor': AppColors.skyBlue,
      'deskripsi': 'Jembatan dibangun manusia untuk menghubungkan dua tempat yang terpisah.',
    },
    {
      'nama': 'Hutan Lindung',
      'jenis': 'Alam',
      'icon': Icons.forest,
      'image': 'assets/images/hutan.png',
      'color': AppColors.primaryDark,
      'gridColor': AppColors.primary,
      'deskripsi': 'Hutan adalah paru-paru dunia yang tumbuh secara alami.',
    },
    {
      'nama': 'Rumah Warga',
      'jenis': 'Buatan',
      'icon': Icons.home,
      'image': 'assets/images/rumah.png',
      'color': AppColors.pastelOrange,
      'gridColor': AppColors.earthBrown,
      'deskripsi': 'Rumah dibangun manusia sebagai tempat tinggal dan berlindung.',
    },
    {
      'nama': 'Sungai Jernih',
      'jenis': 'Alam',
      'icon': Icons.water,
      'image': 'assets/images/sungai.png',
      'color': AppColors.waterBlue,
      'gridColor': AppColors.pastelTeal,
      'deskripsi': 'Sungai adalah aliran air yang mengalir secara alami ke laut.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initPuzzle();
  }

  void _initPuzzle() {
    puzzlePieces = List.generate(9, (i) => i);
    puzzlePieces.shuffle(Random());
    // Ensure puzzle is solvable
    while (!_isSolvable()) {
      puzzlePieces.shuffle(Random());
    }
    puzzleComplete = false;
    showInfo = false;
    moves = 0;
  }

  bool _isSolvable() {
    int inversions = 0;
    for (int i = 0; i < puzzlePieces.length - 1; i++) {
      for (int j = i + 1; j < puzzlePieces.length; j++) {
        if (puzzlePieces[i] > puzzlePieces[j] && puzzlePieces[i] != 8 && puzzlePieces[j] != 8) {
          inversions++;
        }
      }
    }
    return inversions % 2 == 0;
  }

  void _swapPieces(int index) {
    if (puzzleComplete) return;
    
    int emptyIndex = puzzlePieces.indexOf(8);
    List<int> validMoves = [
      if (emptyIndex % 3 != 0) emptyIndex - 1,
      if (emptyIndex % 3 != 2) emptyIndex + 1,
      if (emptyIndex >= 3) emptyIndex - 3,
      if (emptyIndex < 6) emptyIndex + 3,
    ];

    if (validMoves.contains(index)) {
      setState(() {
        int temp = puzzlePieces[index];
        puzzlePieces[index] = puzzlePieces[emptyIndex];
        puzzlePieces[emptyIndex] = temp;
        moves++;
        
        // Check if puzzle is complete
        bool complete = true;
        for (int i = 0; i < 9; i++) {
          if (puzzlePieces[i] != i) {
            complete = false;
            break;
          }
        }
        if (complete) {
          puzzleComplete = true;
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) setState(() => showInfo = true);
          });
        }
      });
    }
  }

  void _nextPuzzle() {
    if (currentPuzzle < puzzles.length - 1) {
      setState(() {
        currentPuzzle++;
        _initPuzzle();
      });
    } else {
      // Show completion screen
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    AudioService().playWinSound();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            const Text(
              'Semua Puzzle Selesai!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Kamu sudah menyelesaikan semua puzzle lingkungan.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  currentPuzzle = 0;
                  _initPuzzle();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Main Lagi', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final puzzle = puzzles[currentPuzzle];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgress(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildPuzzleGrid(puzzle),
                    const SizedBox(height: 20),
                    if (puzzleComplete && showInfo) _buildInfoCard(puzzle),
                    if (puzzleComplete) ...[
                      const SizedBox(height: 20),
                      _buildNextButton(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
                ],
              ),
              child: const Icon(Icons.arrow_back_ios_new, size: 18),
            ),
          ),
          const Expanded(
            child: Text(
              'Puzzle Lingkungan',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.touch_app, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  '$moves',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgress() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Puzzle ${currentPuzzle + 1} dari ${puzzles.length}',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              Text(
                puzzles[currentPuzzle]['nama'],
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (currentPuzzle + 1) / puzzles.length,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPuzzleGrid(Map<String, dynamic> puzzle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (puzzle['color'] as Color).withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Preview
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (puzzle['gridColor'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      puzzle['image'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        puzzle['nama'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: puzzle['color'],
                        ),
                      ),
                      Text(
                        'Susun gambar hingga utuh',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (puzzleComplete) ...[
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 16),
                  ),
                ],
              ],
            ),
          ),
          // Puzzle Grid
          AspectRatio(
            aspectRatio: 1,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                int pieceIndex = puzzlePieces[index];
                bool isEmpty = pieceIndex == 8;
                
                // Show full solved image if puzzle is complete
                if (puzzleComplete) {
                   // Calculate correct alignment for this grid position
                   double alignX = ((index % 3) - 1.0);
                   double alignY = ((index ~/ 3) - 1.0);
                   return ClipRect(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return OverflowBox(
                          maxWidth: constraints.maxWidth * 3,
                          maxHeight: constraints.maxWidth * 3 * (constraints.maxHeight/constraints.maxWidth), // Maintain aspect
                          alignment: Alignment(alignX, alignY),
                          child: Image.asset(
                            puzzle['image'],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  );
                }

                if (isEmpty) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }

                // Calculate alignment based on original piece position
                double alignX = ((pieceIndex % 3) - 1.0);
                double alignY = ((pieceIndex ~/ 3) - 1.0);

                return GestureDetector(
                  onTap: () => _swapPieces(index),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                         BoxShadow(
                           color: Colors.black.withOpacity(0.2),
                           blurRadius: 2,
                           offset: const Offset(0, 1),
                         ),
                      ],
                    ),
                    child: ClipRect(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              OverflowBox(
                                maxWidth: constraints.maxWidth * 3,
                                maxHeight: constraints.maxWidth * 3,
                                alignment: Alignment(alignX, alignY),
                                child: Image.asset(
                                  puzzle['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Number overlay for help
                              Container(
                                color: Colors.black.withOpacity(0.1),
                                child: Center(
                                  child: Text(
                                    '${pieceIndex + 1}',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.5),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(
            puzzleComplete ? 'Selesai! 🎉' : 'Ketuk kepingan untuk memindahkan',
            style: TextStyle(
              color: puzzleComplete ? AppColors.success : AppColors.textSecondary,
              fontWeight: puzzleComplete ? FontWeight.bold : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    ).animate(key: ValueKey(currentPuzzle)).fadeIn().scale(begin: const Offset(0.95, 0.95));
  }

  Widget _buildInfoCard(Map<String, dynamic> puzzle) {
    final isAlam = puzzle['jenis'] == 'Alam';
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isAlam ? AppColors.primary.withOpacity(0.3) : AppColors.earthBrown.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: (puzzle['color'] as Color).withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      (puzzle['color'] as Color).withOpacity(0.8),
                      puzzle['color'] as Color,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(puzzle['icon'], color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      puzzle['nama'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isAlam
                            ? AppColors.primary.withOpacity(0.15)
                            : AppColors.earthBrown.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Lingkungan ${puzzle['jenis']}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isAlam ? AppColors.primary : AppColors.earthBrown,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            puzzle['deskripsi'],
            style: const TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildNextButton() {
    final isLast = currentPuzzle >= puzzles.length - 1;
    
    return ElevatedButton(
      onPressed: _nextPuzzle,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isLast ? 'Selesai' : 'Puzzle Berikutnya',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward, color: Colors.white),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }
}
