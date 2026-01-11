import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math';
import '../../../core/constants/app_colors.dart';

class PetualanganPage extends StatefulWidget {
  const PetualanganPage({super.key});

  @override
  State<PetualanganPage> createState() => _PetualanganPageState();
}

class _PetualanganPageState extends State<PetualanganPage> {
  // Character position
  double characterX = 0.5;
  double characterY = 0.5;
  
  // Selected location info
  Map<String, dynamic>? selectedLocation;
  bool showInfo = false;

  final List<Map<String, dynamic>> locations = [
    {
      'id': 'gunung',
      'nama': 'Gunung Merapi',
      'jenis': 'Alam',
      'icon': Icons.landscape,
      'image': 'assets/images/gunung.png',
      'color': AppColors.pastelGreen,
      'x': 0.15,
      'y': 0.2,
      'deskripsi': 'Gunung adalah bentuk permukaan bumi yang menjulang tinggi. Gunung terbentuk secara alami oleh aktivitas tektonik.',
    },
    {
      'id': 'sungai',
      'nama': 'Sungai Ciliwung',
      'jenis': 'Alam',
      'icon': Icons.water,
      'image': 'assets/images/sungai.png',
      'color': AppColors.waterBlue,
      'x': 0.5,
      'y': 0.35,
      'deskripsi': 'Sungai adalah aliran air alami yang mengalir dari dataran tinggi ke laut.',
    },
    {
      'id': 'rumah',
      'nama': 'Perumahan Warga',
      'jenis': 'Buatan',
      'icon': Icons.home,
      'image': 'assets/images/rumah.png',
      'color': AppColors.pastelOrange,
      'x': 0.8,
      'y': 0.25,
      'deskripsi': 'Rumah adalah bangunan yang dibangun manusia sebagai tempat tinggal.',
    },
    {
      'id': 'hutan',
      'nama': 'Hutan Lindung',
      'jenis': 'Alam',
      'icon': Icons.forest,
      'image': 'assets/images/hutan.png',
      'color': AppColors.primaryDark,
      'x': 0.25,
      'y': 0.55,
      'deskripsi': 'Hutan adalah kawasan yang ditumbuhi pohon-pohon secara alami. Hutan adalah paru-paru dunia.',
    },
    {
      'id': 'jembatan',
      'nama': 'Jembatan Besar',
      'jenis': 'Buatan',
      'icon': Icons.architecture,
      'image': 'assets/images/jembatan.png',
      'color': AppColors.pastelBlue,
      'x': 0.65,
      'y': 0.5,
      'deskripsi': 'Jembatan dibangun manusia untuk menghubungkan dua tempat yang terpisah.',
    },
    {
      'id': 'sawah',
      'nama': 'Sawah Terasering',
      'jenis': 'Buatan',
      'icon': Icons.grass,
      'image': 'assets/images/sawah.png',
      'color': AppColors.primaryLight,
      'x': 0.4,
      'y': 0.7,
      'deskripsi': 'Sawah adalah lahan pertanian yang dibuat manusia untuk menanam padi.',
    },
    {
      'id': 'danau',
      'nama': 'Danau Alami',
      'jenis': 'Alam',
      'icon': Icons.water_drop,
      'image': 'assets/images/danau.png',
      'color': AppColors.pastelTeal,
      'x': 0.75,
      'y': 0.75,
      'deskripsi': 'Danau adalah cekungan berisi air yang terbentuk secara alami.',
    },
    {
      'id': 'gedung',
      'nama': 'Gedung Sekolah',
      'jenis': 'Buatan',
      'icon': Icons.school,
      'image': 'assets/images/gedung.png',
      'color': AppColors.earthBrown,
      'x': 0.1,
      'y': 0.8,
      'deskripsi': 'Gedung sekolah dibangun manusia sebagai tempat belajar mengajar.',
    },
  ];

  void _moveCharacter(double dx, double dy) {
    setState(() {
      characterX = (characterX + dx).clamp(0.1, 0.9);
      characterY = (characterY + dy).clamp(0.15, 0.85);
      showInfo = false;
      
      // Check if near any location
      for (var loc in locations) {
        double distance = sqrt(pow(characterX - loc['x'], 2) + pow(characterY - loc['y'], 2));
        if (distance < 0.12) {
          selectedLocation = loc;
          showInfo = true;
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Stack(
                children: [
                  _buildMap(),
                  _buildLocations(),
                  _buildCharacter(),
                  if (showInfo && selectedLocation != null)
                    _buildInfoCard(),
                  _buildControls(),
                ],
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
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_back_ios_new, size: 18),
            ),
          ),
          const Expanded(
            child: Text(
              'Jelajah Dunia Sekitar',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.explore, color: Colors.white, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${locations.length} Lokasi',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.skyBlue.withOpacity(0.3),
            AppColors.accent.withOpacity(0.4),
            AppColors.primary.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          // Grid pattern
          CustomPaint(
            size: Size.infinite,
            painter: GridPainter(),
          ),
          // Decorative elements
          Positioned(
            right: 20,
            top: 20,
            child: Icon(
              Icons.wb_sunny,
              size: 40,
              color: AppColors.sunYellow.withOpacity(0.6),
            ),
          ),
          Positioned(
            left: 30,
            top: 40,
            child: Icon(
              Icons.cloud,
              size: 30,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          Positioned(
            right: 60,
            top: 50,
            child: Icon(
              Icons.cloud,
              size: 25,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocations() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: locations.map((loc) {
            return Positioned(
              left: constraints.maxWidth * loc['x'] - 25,
              top: constraints.maxHeight * loc['y'] - 25,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedLocation = loc;
                    showInfo = true;
                  });
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: (loc['color'] as Color).withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      loc['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                        Container(
                          decoration: BoxDecoration(
                             gradient: LinearGradient(
                              colors: [
                                (loc['color'] as Color).withOpacity(0.9),
                                loc['color'] as Color,
                              ],
                            ),
                          ),
                          child: Icon(
                            loc['icon'],
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                    ),
                  ),
                )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.08, 1.08),
                      duration: 1500.ms,
                    ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildCharacter() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Positioned(
          left: constraints.maxWidth * characterX - 25,
          top: constraints.maxHeight * characterY - 25,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.child_care,
              color: AppColors.primary,
              size: 30,
            ),
          ).animate().scale(duration: 200.ms),
        );
      },
    );
  }

  Widget _buildInfoCard() {
    final loc = selectedLocation!;
    final isAlam = loc['jenis'] == 'Alam';

    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: (loc['color'] as Color).withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                     boxShadow: [
                      BoxShadow(
                        color: (loc['color'] as Color).withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                       loc['image'],
                       fit: BoxFit.cover,
                       errorBuilder: (context, error, stackTrace) =>
                        Container(
                           decoration: BoxDecoration(
                               gradient: LinearGradient(
                                colors: [
                                  (loc['color'] as Color).withOpacity(0.8),
                                  loc['color'] as Color,
                                ],
                              ),
                           ),
                           child: Icon(loc['icon'], color: Colors.white, size: 28),
                        )
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc['nama'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isAlam
                              ? AppColors.primary.withOpacity(0.15)
                              : AppColors.earthBrown.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Lingkungan ${loc['jenis']}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isAlam ? AppColors.primary : AppColors.earthBrown,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => setState(() => showInfo = false),
                  icon: const Icon(Icons.close, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              loc['deskripsi'],
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ).animate().fadeIn().slideY(begin: 0.2, end: 0),
    );
  }

  Widget _buildControls() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildControlButton(Icons.arrow_back, () => _moveCharacter(-0.08, 0)),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildControlButton(Icons.arrow_upward, () => _moveCharacter(0, -0.08)),
                    const SizedBox(height: 4),
                    _buildControlButton(Icons.arrow_downward, () => _moveCharacter(0, 0.08)),
                  ],
                ),
                _buildControlButton(Icons.arrow_forward, () => _moveCharacter(0.08, 0)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.natureGradient,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1;

    // Draw grid lines
    for (int i = 0; i < 10; i++) {
      double x = size.width * i / 10;
      double y = size.height * i / 10;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
