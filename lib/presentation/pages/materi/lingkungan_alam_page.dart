import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';

class LingkunganAlamPage extends StatelessWidget {
  const LingkunganAlamPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> lingkunganAlam = [
      {
        'nama': 'Gunung',
        'deskripsi': 'Gunung adalah bentuk permukaan bumi yang menjulang tinggi. Gunung terbentuk secara alami oleh aktivitas tektonik bumi.',
        'icon': Icons.landscape,
        'image': 'assets/images/gunung.png',
        'color': AppColors.pastelGreen,
        'fakta': 'Indonesia memiliki lebih dari 400 gunung berapi!',
      },
      {
        'nama': 'Sungai',
        'deskripsi': 'Sungai adalah aliran air yang mengalir dari dataran tinggi ke dataran rendah menuju laut.',
        'icon': Icons.water,
        'image': 'assets/images/sungai.png',
        'color': AppColors.waterBlue,
        'fakta': 'Sungai Kapuas adalah sungai terpanjang di Indonesia.',
      },
      {
        'nama': 'Hutan',
        'deskripsi': 'Hutan adalah kawasan yang ditumbuhi berbagai macam pohon dan tanaman. Hutan adalah paru-paru dunia.',
        'icon': Icons.forest,
        'image': 'assets/images/hutan.png',
        'color': AppColors.primaryDark,
        'fakta': 'Hutan hujan Indonesia adalah yang terbesar ketiga di dunia.',
      },
      {
        'nama': 'Laut',
        'deskripsi': 'Laut adalah kumpulan air asin yang sangat luas. Laut menjadi rumah bagi berbagai makhluk hidup.',
        'icon': Icons.waves,
        'image': 'assets/images/laut.png',
        'color': AppColors.skyBlue,
        'fakta': 'Indonesia memiliki 17.000+ pulau yang dikelilingi laut.',
      },
      {
        'nama': 'Danau',
        'deskripsi': 'Danau adalah cekungan di permukaan bumi yang berisi air. Danau bisa terbentuk dari kawah gunung berapi.',
        'icon': Icons.water_drop,
        'image': 'assets/images/danau.png',
        'color': AppColors.pastelTeal,
        'fakta': 'Danau Toba adalah danau vulkanik terbesar di Asia Tenggara.',
      },
      {
        'nama': 'Pantai',
        'deskripsi': 'Pantai adalah daerah pertemuan antara daratan dan lautan. Pantai biasanya memiliki pasir atau bebatuan.',
        'icon': Icons.beach_access,
        'image': 'assets/images/pantai.png',
        'color': AppColors.sunYellow,
        'fakta': 'Indonesia memiliki garis pantai sepanjang 99.000+ km.',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = lingkunganAlam[index];
                  return _buildEnvironmentCard(context, item, index);
                },
                childCount: lingkunganAlam.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Lingkungan Alam',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primaryLight,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -30,
                bottom: 20,
                child: Icon(
                  Icons.eco,
                  size: 150,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
              Positioned(
                left: 20,
                bottom: 70,
                child: Icon(
                  Icons.forest,
                  size: 80,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
              Positioned(
                right: 100,
                top: 60,
                child: Icon(
                  Icons.water_drop,
                  size: 40,
                  color: Colors.white.withOpacity(0.25),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnvironmentCard(BuildContext context, Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (item['color'] as Color).withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showDetailDialog(context, item),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Image container
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: (item['color'] as Color).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      item['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: (item['color'] as Color).withOpacity(0.2),
                          child: Icon(item['icon'], color: item['color'], size: 35),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['nama'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['deskripsi'],
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (100 * index).ms, duration: 400.ms)
        .slideX(begin: 0.1, end: 0);
  }

  void _showDetailDialog(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75, // Increased height
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),
              // Large Image
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: (item['color'] as Color).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    item['image'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                       return Container(
                         color: (item['color'] as Color).withOpacity(0.2),
                         child: Center(
                           child: Icon(item['icon'], color: item['color'], size: 60),
                         ),
                       );
                    },
                  ),
                ),
              ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
              const SizedBox(height: 24),
              Text(
                item['nama'],
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, end: 0),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  item['deskripsi'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 24),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.sunYellow.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.sunYellow.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb, color: AppColors.sunYellow, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tahukah Kamu?',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['fakta'],
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.all(24),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Mengerti!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
