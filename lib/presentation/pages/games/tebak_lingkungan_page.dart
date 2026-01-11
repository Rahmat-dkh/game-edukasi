import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/audio_service.dart';

class TebakLingkunganPage extends StatefulWidget {
  const TebakLingkunganPage({super.key});

  @override
  State<TebakLingkunganPage> createState() => _TebakLingkunganPageState();
}

class _TebakLingkunganPageState extends State<TebakLingkunganPage>
    with TickerProviderStateMixin {
  int currentQuestion = 0;
  int score = 0;
  bool showResult = false;
  bool? isCorrect;
  bool gameEnded = false;

  late AnimationController _shakeController;
  late AnimationController _bounceController;

  final List<Map<String, dynamic>> questions = [
    {
      'nama': 'Gunung Bromo',
      'icon': Icons.landscape,
      'image': 'assets/images/gunung.png',
      'color': AppColors.pastelGreen,
      'jawaban': 'alam',
      'penjelasan': 'Gunung adalah bentuk permukaan bumi yang terbentuk secara alami oleh aktivitas tektonik.',
    },
    {
      'nama': 'Jembatan Suramadu',
      'icon': Icons.architecture,
      'image': 'assets/images/jembatan.png',
      'color': AppColors.pastelBlue,
      'jawaban': 'buatan',
      'penjelasan': 'Jembatan dibangun oleh manusia untuk menghubungkan dua tempat yang terpisah.',
    },
    {
      'nama': 'Sungai Kapuas',
      'icon': Icons.water,
      'image': 'assets/images/sungai.png',
      'color': AppColors.waterBlue,
      'jawaban': 'alam',
      'penjelasan': 'Sungai adalah aliran air yang terbentuk secara alami dari hujan dan mata air.',
    },
    {
      'nama': 'Sawah Terasering',
      'icon': Icons.grass,
      'image': 'assets/images/sawah.png',
      'color': AppColors.primaryLight,
      'jawaban': 'buatan',
      'penjelasan': 'Sawah terasering dibuat oleh petani dengan membentuk lahan bertingkat di lereng bukit.',
    },
    {
      'nama': 'Hutan Kalimantan',
      'icon': Icons.forest,
      'image': 'assets/images/hutan.png',
      'color': AppColors.primaryDark,
      'jawaban': 'alam',
      'penjelasan': 'Hutan hujan tropis tumbuh secara alami selama ribuan tahun.',
    },
    {
      'nama': 'Taman Kota',
      'icon': Icons.park,
      'image': 'assets/images/taman.png',
      'color': AppColors.accent,
      'jawaban': 'buatan',
      'penjelasan': 'Taman kota dirancang dan dibangun manusia untuk ruang hijau di perkotaan.',
    },
    {
      'nama': 'Danau Toba',
      'icon': Icons.water_drop,
      'image': 'assets/images/danau.png',
      'color': AppColors.pastelTeal,
      'jawaban': 'alam',
      'penjelasan': 'Danau Toba terbentuk dari letusan gunung berapi super sekitar 74.000 tahun lalu.',
    },
    {
      'nama': 'Gedung Sekolah',
      'icon': Icons.school,
      'image': 'assets/images/gedung.png',
      'color': AppColors.pastelOrange,
      'jawaban': 'buatan',
      'penjelasan': 'Gedung sekolah dibangun manusia sebagai tempat belajar mengajar.',
    },
    {
      'nama': 'Pantai Bali',
      'icon': Icons.beach_access,
      'image': 'assets/images/pantai.png',
      'color': AppColors.sunYellow,
      'jawaban': 'alam',
      'penjelasan': 'Pantai terbentuk secara alami dari erosi air laut terhadap daratan.',
    },
    {
      'nama': 'Bendungan Jatiluhur',
      'icon': Icons.flood,
      'image': 'assets/images/bendungan.png',
      'color': AppColors.skyBlue,
      'jawaban': 'buatan',
      'penjelasan': 'Bendungan dibangun manusia untuk menampung air dan menghasilkan listrik.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    // Shuffle questions
    questions.shuffle(Random());
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _checkAnswer(String answer) {
    if (showResult) return;

    final correct = questions[currentQuestion]['jawaban'] == answer;
    setState(() {
      isCorrect = correct;
      showResult = true;
      if (correct) {
        score++;
        _bounceController.forward(from: 0);
      } else {
        _shakeController.forward(from: 0);
      }
    });
  }

  void _nextQuestion() {
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        showResult = false;
        isCorrect = null;
      });
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
      showResult = false;
      isCorrect = null;
      gameEnded = false;
      questions.shuffle(Random());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (gameEnded) {
      return _buildGameEndScreen();
    }

    final question = questions[currentQuestion];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgressBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    _buildQuestionCard(question),
                    const SizedBox(height: 32),
                    _buildAnswerButtons(),
                    if (showResult) ...[
                      const SizedBox(height: 24),
                      _buildExplanation(question),
                      const SizedBox(height: 24),
                      _buildNextButton(),
                    ],
                    const SizedBox(height: 40),
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
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.textPrimary,
                size: 18,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Tebak Lingkungan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stars, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text(
                  '$score',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Soal ${currentQuestion + 1} dari ${questions.length}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${((currentQuestion + 1) / questions.length * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: (currentQuestion + 1) / questions.length,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Map<String, dynamic> question) {
    return AnimatedBuilder(
      animation: _shakeController,
      builder: (context, child) {
        final shakeOffset = sin(_shakeController.value * pi * 4) * 10;
        return Transform.translate(
          offset: Offset(isCorrect == false ? shakeOffset : 0, 0),
          child: child,
        );
      },
      child: AnimatedBuilder(
        animation: _bounceController,
        builder: (context, child) {
          final bounceScale = 1.0 + (sin(_bounceController.value * pi) * 0.05);
          return Transform.scale(
            scale: isCorrect == true ? bounceScale : 1.0,
            child: child,
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: showResult
                ? Border.all(
                    color: isCorrect == true
                        ? AppColors.success
                        : AppColors.error,
                    width: 3,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: (question['color'] as Color).withOpacity(0.2),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Use min size to avoid spanning unnecessarily
            children: [
              Container(
                width: 200,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: (question['color'] as Color).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    question['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                           gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                (question['color'] as Color).withOpacity(0.8),
                                question['color'] as Color,
                              ],
                           ),
                        ),
                        child: Center(
                           child: Icon(
                            question['icon'],
                            color: Colors.white,
                            size: 60,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
                  .animate(key: ValueKey('image_$currentQuestion'))
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1, 1),
                    duration: 400.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(),
              const SizedBox(height: 20),
              Flexible( // Use Flexible for text to avoid overflow
                child: Text(
                  question['nama'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
                  .animate(key: ValueKey('text_$currentQuestion'))
                  .fadeIn(delay: 100.ms)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: 12),
              Container( // Wrap with Flexible or constrain width if needed, but it's just text
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Ini lingkungan Alam atau Buatan? 🤔',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
                  .animate(key: ValueKey('hint_$currentQuestion'))
                  .fadeIn(delay: 200.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildAnswerButton(
            'Alam',
            Icons.eco,
            AppColors.primary,
            'alam',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildAnswerButton(
            'Buatan',
            Icons.construction,
            AppColors.earthBrown,
            'buatan',
          ),
        ),
      ],
    )
        .animate(key: ValueKey('buttons_$currentQuestion'))
        .fadeIn(delay: 300.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildAnswerButton(
    String label,
    IconData icon,
    Color color,
    String answer,
  ) {
    final isSelected = showResult && questions[currentQuestion]['jawaban'] == answer;
    final isWrongSelected = showResult &&
        questions[currentQuestion]['jawaban'] != answer &&
        ((answer == 'alam' && isCorrect == false && questions[currentQuestion]['jawaban'] == 'buatan') ||
         (answer == 'buatan' && isCorrect == false && questions[currentQuestion]['jawaban'] == 'alam'));

    return GestureDetector(
      onTap: () => _checkAnswer(answer),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: showResult
                ? (isSelected
                    ? [AppColors.success.withOpacity(0.8), AppColors.success]
                    : isWrongSelected
                        ? [AppColors.error.withOpacity(0.8), AppColors.error]
                        : [Colors.grey.shade300, Colors.grey.shade400])
                : [color.withOpacity(0.8), color],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (showResult
                      ? (isSelected
                          ? AppColors.success
                          : isWrongSelected
                              ? AppColors.error
                              : Colors.grey)
                      : color)
                  .withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              showResult
                  ? (isSelected
                      ? Icons.check_circle
                      : isWrongSelected
                          ? Icons.cancel
                          : icon)
                  : icon,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExplanation(Map<String, dynamic> question) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isCorrect == true
            ? AppColors.success.withOpacity(0.1)
            : AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCorrect == true
              ? AppColors.success.withOpacity(0.3)
              : AppColors.error.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isCorrect == true ? AppColors.success : AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCorrect == true ? Icons.check : Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isCorrect == true ? 'Benar! Hebat! 🎉' : 'Oops! Kurang tepat 😊',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isCorrect == true ? AppColors.success : AppColors.error,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            question['penjelasan'],
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildNextButton() {
    return ElevatedButton(
      onPressed: _nextQuestion,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            currentQuestion < questions.length - 1 ? 'Soal Berikutnya' : 'Lihat Hasil',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward, color: Colors.white),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildGameEndScreen() {
    final percentage = (score / questions.length * 100).toInt();
    String message;
    String emoji;
    Color bgColor;

    if (percentage >= 80) {
      message = 'Luar Biasa!';
      emoji = '🏆';
      bgColor = AppColors.success;
    } else if (percentage >= 60) {
      message = 'Bagus Sekali!';
      emoji = '⭐';
      bgColor = AppColors.primary;
    } else if (percentage >= 40) {
      message = 'Tetap Semangat!';
      emoji = '💪';
      bgColor = AppColors.pastelOrange;
    } else {
      message = 'Ayo Belajar Lagi!';
      emoji = '📚';
      bgColor = AppColors.earthBrown;
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
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: bgColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 60),
                    ),
                  ),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1, 1),
                      duration: 600.ms,
                      curve: Curves.elasticOut,
                    ),
                const SizedBox(height: 32),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: bgColor,
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Skor Kamu',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$score',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: bgColor,
                            ),
                          ),
                          Text(
                            ' / ${questions.length}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$percentage% Benar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: bgColor,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 400.ms).scale(),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: _resetGame,
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text(
                    'Main Lagi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(200, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Kembali ke Menu',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ).animate().fadeIn(delay: 700.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
