import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/audio_service.dart';

class DragDropPage extends StatefulWidget {
  const DragDropPage({super.key});

  @override
  State<DragDropPage> createState() => _DragDropPageState();
}

class _DragDropPageState extends State<DragDropPage> {
  int score = 0;
  int totalAnswered = 0;
  List<Map<String, dynamic>> availableItems = [];
  List<Map<String, dynamic>> alamItems = [];
  List<Map<String, dynamic>> buatanItems = [];
  bool showFeedback = false;
  bool lastCorrect = false;
  String feedbackMessage = '';

  final List<Map<String, dynamic>> allItems = [
    {'nama': 'Gunung', 'icon': Icons.landscape, 'image': 'assets/images/gunung.png', 'jenis': 'alam', 'color': AppColors.pastelGreen},
    {'nama': 'Sungai', 'icon': Icons.water, 'image': 'assets/images/sungai.png', 'jenis': 'alam', 'color': AppColors.waterBlue},
    {'nama': 'Hutan', 'icon': Icons.forest, 'image': 'assets/images/hutan.png', 'jenis': 'alam', 'color': AppColors.primaryDark},
    {'nama': 'Laut', 'icon': Icons.waves, 'image': 'assets/images/laut.png', 'jenis': 'alam', 'color': AppColors.skyBlue},
    {'nama': 'Danau', 'icon': Icons.water_drop, 'image': 'assets/images/danau.png', 'jenis': 'alam', 'color': AppColors.pastelTeal},
    {'nama': 'Pantai', 'icon': Icons.beach_access, 'image': 'assets/images/pantai.png', 'jenis': 'alam', 'color': AppColors.sunYellow},
    {'nama': 'Rumah', 'icon': Icons.home, 'image': 'assets/images/rumah.png', 'jenis': 'buatan', 'color': AppColors.pastelOrange},
    {'nama': 'Jembatan', 'icon': Icons.architecture, 'image': 'assets/images/jembatan.png', 'jenis': 'buatan', 'color': AppColors.pastelBlue},
    {'nama': 'Gedung', 'icon': Icons.business, 'image': 'assets/images/gedung.png', 'jenis': 'buatan', 'color': AppColors.earthBrown},
    {'nama': 'Taman', 'icon': Icons.park, 'image': 'assets/images/taman.png', 'jenis': 'buatan', 'color': AppColors.accent},
    {'nama': 'Sawah', 'icon': Icons.grass, 'image': 'assets/images/sawah.png', 'jenis': 'buatan', 'color': AppColors.primaryLight},
    {'nama': 'Bendungan', 'icon': Icons.flood, 'image': 'assets/images/bendungan.png', 'jenis': 'buatan', 'color': AppColors.pastelPurple},
  ];

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    availableItems = List.from(allItems)..shuffle(Random());
    alamItems = [];
    buatanItems = [];
    score = 0;
    totalAnswered = 0;
  }

  void _onItemDropped(Map<String, dynamic> item, String category) {
    final isCorrect = item['jenis'] == category;
    
    setState(() {
      availableItems.remove(item);
      if (category == 'alam') {
        alamItems.add(item);
      } else {
        buatanItems.add(item);
      }
      
      if (isCorrect) {
        score++;
        lastCorrect = true;
        feedbackMessage = 'Benar! ${item['nama']} adalah lingkungan ${category == 'alam' ? 'alam' : 'buatan'}! 🎉';
      } else {
        lastCorrect = false;
        feedbackMessage = 'Kurang tepat! ${item['nama']} seharusnya lingkungan ${item['jenis']}. 😊';
      }
      
      totalAnswered++;
      showFeedback = true;
      
      if (availableItems.isEmpty) {
        AudioService().playWinSound();
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() => showFeedback = false);
      }
    });
  }

  void _resetGame() {
    setState(() {
      _initGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameComplete = availableItems.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            if (showFeedback) _buildFeedback(),
            Expanded(
              child: gameComplete ? _buildGameComplete() : _buildGameArea(),
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
              'Seret & Lepas',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
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
                  '$score / $totalAnswered',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedback() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: lastCorrect ? AppColors.success.withOpacity(0.15) : AppColors.error.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: lastCorrect ? AppColors.success.withOpacity(0.3) : AppColors.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            lastCorrect ? Icons.check_circle : Icons.info,
            color: lastCorrect ? AppColors.success : AppColors.error,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feedbackMessage,
              style: TextStyle(
                color: lastCorrect ? AppColors.success : AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.2, end: 0);
  }

  Widget _buildGameArea() {
    return Column(
      children: [
        // Draggable items
        Container(
          height: 120,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.touch_app, color: AppColors.primary, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Seret ke kategori yang tepat',
                    style: TextStyle(
                      color: AppColors.textSecondary.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: availableItems.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final item = availableItems[index];
                    return _buildDraggableItem(item);
                  },
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Drop targets
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildDropTarget('alam', 'Lingkungan Alam', Icons.eco, AppColors.primary, alamItems)),
              const SizedBox(width: 12),
              Expanded(child: _buildDropTarget('buatan', 'Lingkungan Buatan', Icons.location_city, AppColors.earthBrown, buatanItems)),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDraggableItem(Map<String, dynamic> item) {
    return Draggable<Map<String, dynamic>>(
      data: item,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: (item['color'] as Color).withOpacity(0.5),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Column(
              children: [
                Expanded(
                  child: Image.asset(
                    item['image'],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: (item['color'] as Color).withOpacity(0.9),
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    item['nama'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: _buildItemCard(item),
      ),
      child: _buildItemCard(item),
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    return Container(
      width: 65,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (item['color'] as Color).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                item['image'],
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: (item['color'] as Color).withOpacity(0.2),
                  child: Icon(item['icon'], color: item['color']),
                ),
              ),
            ),
            Container(
               width: double.infinity,
               color: (item['color'] as Color).withOpacity(0.85),
               padding: const EdgeInsets.symmetric(vertical: 4),
               child: Text(
                item['nama'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropTarget(String category, String title, IconData icon, Color color, List<Map<String, dynamic>> items) {
    return DragTarget<Map<String, dynamic>>(
      onAcceptWithDetails: (details) => _onItemDropped(details.data, category),
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;
        
        return Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isHovering ? color : color.withOpacity(0.3),
              width: isHovering ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(isHovering ? 0.3 : 0.1),
                blurRadius: isHovering ? 20 : 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.9), color],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                ),
                child: Column(
                  children: [
                    Icon(icon, color: Colors.white, size: 28),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Text(
                          'Seret kesini',
                          style: TextStyle(
                            color: AppColors.textSecondary.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8),
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: items.map((item) => Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: (item['color'] as Color).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(item['icon'], color: item['color'], size: 20),
                          )).toList(),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '${items.length} item',
                  style: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.6),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGameComplete() {
    final percentage = (score / allItems.length * 100).toInt();
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.15),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 60)),
                  const SizedBox(height: 16),
                  const Text(
                    'Selesai!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Skor: $score / ${allItems.length}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$percentage% Benar',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _resetGame,
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    label: const Text(
                      'Main Lagi',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ],
              ),
            ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
          ],
        ),
      ),
    );
  }
}
