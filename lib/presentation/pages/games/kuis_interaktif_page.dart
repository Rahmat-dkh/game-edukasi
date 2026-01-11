import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import 'dart:math';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/audio_service.dart';

class KuisInteraktifPage extends StatefulWidget {
  const KuisInteraktifPage({super.key});

  @override
  State<KuisInteraktifPage> createState() => _KuisInteraktifPageState();
}

class _KuisInteraktifPageState extends State<KuisInteraktifPage> {
  int currentQuestion = 0;
  int score = 0;
  int timeLeft = 15;
  Timer? timer;
  bool answered = false;
  int? selectedAnswer;
  bool gameEnded = false;

  final List<Map<String, dynamic>> questions = [
    {
      'soal': 'Manakah yang termasuk lingkungan alam?',
      'opsi': ['Gedung Sekolah', 'Gunung Merapi', 'Jembatan Suramadu', 'Sawah Terasering'],
      'image': 'assets/images/gunung.png',
      'jawaban': 1,
      'penjelasan': 'Gunung terbentuk secara alami oleh aktivitas tektonik bumi.',
    },
    {
      'soal': 'Sungai termasuk lingkungan?',
      'opsi': ['Buatan', 'Alam', 'Campuran', 'Tidak tahu'],
      'image': 'assets/images/sungai.png',
      'jawaban': 1,
      'penjelasan': 'Sungai adalah aliran air yang terbentuk secara alami.',
    },
    {
      'soal': 'Sawah terasering dibuat oleh?',
      'opsi': ['Alam', 'Manusia', 'Hewan', 'Tumbuhan'],
      'image': 'assets/images/sawah.png',
      'jawaban': 1,
      'penjelasan': 'Sawah terasering dibuat petani dengan membentuk lahan bertingkat.',
    },
    {
      'soal': 'Hutan hujan tropis adalah contoh?',
      'opsi': ['Lingkungan buatan', 'Lingkungan alam', 'Taman kota', 'Kebun binatang'],
      'image': 'assets/images/hutan.png',
      'jawaban': 1,
      'penjelasan': 'Hutan hujan tropis tumbuh secara alami selama ribuan tahun.',
    },
    {
      'soal': 'Bendungan termasuk lingkungan?',
      'opsi': ['Alam', 'Buatan', 'Laut', 'Sungai'],
      'image': 'assets/images/bendungan.png',
      'jawaban': 1,
      'penjelasan': 'Bendungan dibangun manusia untuk menampung air.',
    },
    {
      'soal': 'Mana yang BUKAN lingkungan alam?',
      'opsi': ['Danau Toba', 'Pantai Kuta', 'Taman Kota', 'Gunung Bromo'],
      'image': 'assets/images/taman.png',
      'jawaban': 2,
      'penjelasan': 'Taman kota dirancang dan dibangun oleh manusia.',
    },
    {
      'soal': 'Laut terbentuk karena?',
      'opsi': ['Dibuat manusia', 'Proses alam', 'Hujan buatan', 'Kebocoran air'],
      'image': 'assets/images/laut.png',
      'jawaban': 1,
      'penjelasan': 'Laut terbentuk secara alami jutaan tahun lalu.',
    },
    {
      'soal': 'Rumah termasuk lingkungan?',
      'opsi': ['Alam', 'Buatan', 'Hutan', 'Sungai'],
      'image': 'assets/images/rumah.png',
      'jawaban': 1,
      'penjelasan': 'Rumah dibangun manusia sebagai tempat tinggal.',
    },
    {
      'soal': 'Manakah pasangan lingkungan alam yang benar?',
      'opsi': ['Rumah & Gedung', 'Gunung & Sungai', 'Jembatan & Sawah', 'Taman & Bendungan'],
      'image': 'assets/images/gunung.png',
      'jawaban': 1,
      'penjelasan': 'Gunung dan sungai keduanya terbentuk secara alami.',
    },
    {
      'soal': 'Danau vulkanik terbentuk dari?',
      'opsi': ['Dibangun manusia', 'Letusan gunung berapi', 'Air hujan', 'Irigasi'],
      'image': 'assets/images/danau.png',
      'jawaban': 1,
      'penjelasan': 'Danau vulkanik terbentuk dari kawah gunung berapi yang terisi air.',
    },
  ];

  @override
  void initState() {
    super.initState();
    questions.shuffle(Random());
    _startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    timer?.cancel();
    timeLeft = 15;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (mounted) {
        setState(() {
          if (timeLeft > 0) {
            timeLeft--;
          } else {
            t.cancel();
            if (!answered) {
              _selectAnswer(-1); // Time's up
            }
          }
        });
      }
    });
  }

  void _selectAnswer(int index) {
    if (answered) return;
    
    timer?.cancel();
    setState(() {
      answered = true;
      selectedAnswer = index;
      if (index == questions[currentQuestion]['jawaban']) {
        score++;
      }
    });
  }

  void _nextQuestion() {
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        answered = false;
        selectedAnswer = null;
      });
      _startTimer();
    } else {
      setState(() {
        gameEnded = true;
        AudioService().playWinSound();
      });
    }
  }

  void _resetGame() {
    setState(() {
      currentQuestion = 0;
      score = 0;
      answered = false;
      selectedAnswer = null;
      gameEnded = false;
      questions.shuffle(Random());
    });
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    if (gameEnded) {
      return _buildResultScreen();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTimer(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildQuestionCard(),
                    const SizedBox(height: 24),
                    _buildOptions(),
                    if (answered) ...[
                      const SizedBox(height: 20),
                      _buildExplanation(),
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
              'Kuis Interaktif',
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
                const Icon(Icons.stars, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text(
                  '$score',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimer() {
    final isLow = timeLeft <= 5;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Soal ${currentQuestion + 1} dari ${questions.length}',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              Row(
                children: [
                  Icon(
                    Icons.timer,
                    color: isLow ? AppColors.error : AppColors.primary,
                    size: 18,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$timeLeft detik',
                    style: TextStyle(
                      color: isLow ? AppColors.error : AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: timeLeft / 15,
              backgroundColor: isLow ? AppColors.error.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation(isLow ? AppColors.error : AppColors.primary),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    final question = questions[currentQuestion];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                   color: AppColors.primary.withOpacity(0.2),
                   blurRadius: 10,
                   offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
               borderRadius: BorderRadius.circular(18),
               child: Image.asset(
                  question['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: AppColors.natureGradient),
                    ),
                    child: const Center(child: Icon(Icons.quiz, color: Colors.white, size: 50)),
                  ),
               ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            question['soal'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
        ],
      ),
    ).animate(key: ValueKey(currentQuestion)).fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildOptions() {
    final question = questions[currentQuestion];
    final options = question['opsi'] as List<String>;
    final correctAnswer = question['jawaban'] as int;

    return Column(
      children: options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        
        Color bgColor = Colors.white;
        Color borderColor = AppColors.primary.withOpacity(0.2);
        Color textColor = AppColors.textPrimary;

        if (answered) {
          if (index == correctAnswer) {
            bgColor = AppColors.success.withOpacity(0.15);
            borderColor = AppColors.success;
            textColor = AppColors.success;
          } else if (index == selectedAnswer && index != correctAnswer) {
            bgColor = AppColors.error.withOpacity(0.15);
            borderColor = AppColors.error;
            textColor = AppColors.error;
          }
        } else if (selectedAnswer == index) {
          borderColor = AppColors.primary;
        }

        return GestureDetector(
          onTap: () => _selectAnswer(index),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: answered && index == correctAnswer
                        ? AppColors.success
                        : answered && index == selectedAnswer
                            ? AppColors.error
                            : AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: answered
                        ? Icon(
                            index == correctAnswer ? Icons.check : (index == selectedAnswer ? Icons.close : null),
                            color: Colors.white,
                            size: 18,
                          )
                        : Text(
                            String.fromCharCode(65 + index),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).animate(key: ValueKey('opt_${currentQuestion}_$index'))
            .fadeIn(delay: (100 * index).ms)
            .slideX(begin: 0.1, end: 0);
      }).toList(),
    );
  }

  Widget _buildExplanation() {
    final question = questions[currentQuestion];
    final isCorrect = selectedAnswer == question['jawaban'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isCorrect 
            ? AppColors.success.withOpacity(0.1) 
            : selectedAnswer == -1 
                ? AppColors.pastelOrange.withOpacity(0.1)
                : AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCorrect 
              ? AppColors.success.withOpacity(0.3) 
              : selectedAnswer == -1
                  ? AppColors.pastelOrange.withOpacity(0.3)
                  : AppColors.error.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : selectedAnswer == -1 ? Icons.timer_off : Icons.info,
                color: isCorrect ? AppColors.success : selectedAnswer == -1 ? AppColors.pastelOrange : AppColors.error,
              ),
              const SizedBox(width: 10),
              Text(
                isCorrect ? 'Benar! Hebat! 🎉' : selectedAnswer == -1 ? 'Waktu Habis! ⏰' : 'Kurang Tepat 😊',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isCorrect ? AppColors.success : selectedAnswer == -1 ? AppColors.pastelOrange : AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            question['penjelasan'],
            style: const TextStyle(color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildNextButton() {
    final isLast = currentQuestion >= questions.length - 1;
    return ElevatedButton(
      onPressed: _nextQuestion,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isLast ? 'Lihat Hasil' : 'Soal Berikutnya',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward, color: Colors.white),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildResultScreen() {
    final percentage = (score / questions.length * 100).toInt();
    String message;
    String emoji;

    if (percentage >= 80) {
      message = 'Luar Biasa!';
      emoji = '🏆';
    } else if (percentage >= 60) {
      message = 'Bagus Sekali!';
      emoji = '⭐';
    } else if (percentage >= 40) {
      message = 'Tetap Semangat!';
      emoji = '💪';
    } else {
      message = 'Ayo Belajar Lagi!';
      emoji = '📚';
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 80))
                    .animate().scale(duration: 600.ms, curve: Curves.elasticOut),
                const SizedBox(height: 24),
                Text(
                  message,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text('Skor Akhir', style: TextStyle(color: AppColors.textSecondary)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$score',
                            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                          Text(
                            ' / ${questions.length}',
                            style: const TextStyle(fontSize: 24, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      Text('$percentage% Benar', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ).animate().fadeIn(delay: 400.ms).scale(),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _resetGame,
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text('Main Lagi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Kembali', style: TextStyle(color: AppColors.textSecondary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
