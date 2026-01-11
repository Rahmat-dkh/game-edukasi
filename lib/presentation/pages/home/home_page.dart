import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/custom_card.dart';
import '../games/tebak_lingkungan_page.dart';
import '../games/petualangan_page.dart';
import '../games/drag_drop_page.dart';
import '../games/kuis_interaktif_page.dart';
import '../games/puzzle_lingkungan_page.dart';
import '../materi/lingkungan_alam_page.dart';
import '../materi/lingkungan_buatan_page.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/models/user_model.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService().currentUser;

    if (user == null) {
      return const Center(child: Text("Silakan Login Kembali"));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: StreamBuilder<UserModel?>(
        stream: FirestoreService().getUserStream(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data;
          final String userName = userData?.name ?? "Penjelajah";
          final int userLevel = userData?.level ?? 1;
          final int userXP = userData?.xp ?? 0;
          
          double progress = (userXP % 500) / 500; 

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, userName, userLevel, userXP, progress),
                const SizedBox(height: 24),
                _buildRecommendedGame(context),
                const SizedBox(height: 24),
                _buildMateriSection(context),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    "Permainan Lainnya",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildGameList(context),
                const SizedBox(height: 100),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String name, int level, int userXP, double progress) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.natureGradient,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                      "Halo, $name! 🌿",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                     ),
                     const SizedBox(height: 4),
                     const Text(
                      "Ayo jelajahi alam sekitarmu!",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                     ),
                   ],
                 ),
               ),
               const SizedBox(width: 12),
               // Logo
               Container(
                 width: 50,
                 height: 50,
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(15),
                   boxShadow: [
                     BoxShadow(
                       color: Colors.black.withOpacity(0.1),
                       blurRadius: 10,
                       offset: const Offset(0, 4),
                     ),
                   ],
                 ),
                 child: ClipRRect(
                   borderRadius: BorderRadius.circular(15),
                   child: Padding(
                     padding: const EdgeInsets.all(4.0),
                     child: Image.asset(
                       'assets/icone/logo.jpg',
                       fit: BoxFit.cover,
                     ),
                   ),
                 ),
               ),
             ],
           ),
           const SizedBox(height: 20),
           Container(
             padding: const EdgeInsets.all(16),
             decoration: BoxDecoration(
               color: Colors.white,
               borderRadius: BorderRadius.circular(20),
               boxShadow: [
                 BoxShadow(
                   color: Colors.black.withOpacity(0.05),
                   blurRadius: 15,
                   offset: const Offset(0, 5),
                 ),
               ],
             ),
             child: Row(
               children: [
                 CircularPercentIndicator(
                   radius: 28.0,
                   lineWidth: 5.0,
                   percent: progress,
                   center: Text("$level", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary)),
                   progressColor: AppColors.accent,
                   backgroundColor: AppColors.background,
                   circularStrokeCap: CircularStrokeCap.round,
                 ),
                 const SizedBox(width: 16),
                 Expanded(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       const Text(
                         "Level Penjelajah",
                         style: TextStyle(
                           color: AppColors.textSecondary,
                           fontSize: 12,
                         ),
                       ),
                       const SizedBox(height: 2),
                       Text(
                         "Level $level",
                         style: const TextStyle(
                           color: AppColors.textPrimary,
                           fontWeight: FontWeight.bold,
                           fontSize: 16,
                         ),
                       ),
                     ],
                   ),
                 ),
                 Container(
                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                   decoration: BoxDecoration(
                     color: AppColors.sunYellow.withOpacity(0.2),
                     borderRadius: BorderRadius.circular(12),
                   ),
                   child: Row(
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       const Icon(Icons.star, color: AppColors.sunYellow, size: 16),
                       const SizedBox(width: 4),
                       Text(
                         "$userXP XP",
                         style: const TextStyle(
                           color: AppColors.sunYellow,
                           fontWeight: FontWeight.bold,
                           fontSize: 12,
                         ),
                       ),
                     ],
                   ),
                 ),
               ],
             ),
           )
        ],
      ),
    ).animate().fadeIn().slideY();
  }

  Widget _buildRecommendedGame(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GestureDetector(
        onTap: () {
             Navigator.push(context, MaterialPageRoute(builder: (context) => const TebakLingkunganPage()));
        },
        child: Container(
          width: double.infinity,
          // height: 150, // Removed fixed height to prevent overflow
          constraints: const BoxConstraints(minHeight: 150), // Ensure minimum height
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary.withOpacity(0.9),
                AppColors.primaryLight,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
               BoxShadow(
                color: AppColors.primary.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ]
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(Icons.nature_people, size: 130, color: Colors.white.withOpacity(0.2)),
              ),
              Positioned(
                left: 20,
                top: 20,
                child: Icon(Icons.eco, size: 30, color: Colors.white.withOpacity(0.3)),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.sunYellow,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.sunYellow.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text(
                                "BARU", 
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Text(
                            "Rekomendasi", 
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "Tebak Lingkungan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Alam atau buatan? Tebak dengan benar!",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 20,
                bottom: 20,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.play_arrow_rounded, color: AppColors.primary, size: 24),
                ),
              ),
            ],
          ),
        ).animate().scale(delay: 200.ms, curve: Curves.easeOut),
      ),
    );
  }

  Widget _buildMateriSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            "Materi Belajar",
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 110,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            children: [
              _buildMateriCard(
                context,
                'Lingkungan Alam',
                Icons.forest,
                AppColors.primary,
                const LingkunganAlamPage(),
              ),
              const SizedBox(width: 14),
              _buildMateriCard(
                context,
                'Lingkungan Buatan',
                Icons.location_city,
                AppColors.earthBrown,
                const LingkunganBuatanPage(),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 300.ms).slideX(),
      ],
    );
  }

  Widget _buildMateriCard(BuildContext context, String title, IconData icon, Color color, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.8), color],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameList(BuildContext context) {
     final List<Map<String, dynamic>> games = [
      {
        "title": "Jelajah",
        "icon": Icons.explore,
        "color": AppColors.pastelTeal,
        "page": const PetualanganPage()
      },
      {
        "title": "Seret",
        "icon": Icons.touch_app,
        "color": AppColors.pastelPurple,
        "page": const DragDropPage()
      },
      {
         "title": "Kuis",
         "icon": Icons.quiz,
         "color": AppColors.skyBlue,
         "page": const KuisInteraktifPage()
      },
       {
         "title": "Puzzle",
         "icon": Icons.grid_view,
         "color": AppColors.earthBrown,
         "page": const PuzzleLingkunganPage()
      },
    ];

    return SizedBox(
      height: 130,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        scrollDirection: Axis.horizontal,
        itemCount: games.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final game = games[index];
          return GestureDetector(
             onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => game['page']));
             },
             child: Container(
               width: 100,
               decoration: BoxDecoration(
                 color: Colors.white,
                 borderRadius: BorderRadius.circular(20),
                 boxShadow: [
                   BoxShadow(
                     color: (game['color'] as Color).withOpacity(0.15),
                     blurRadius: 12,
                     offset: const Offset(0, 4)
                   )
                 ]
               ),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Container(
                     padding: const EdgeInsets.all(12),
                     decoration: BoxDecoration(
                       gradient: LinearGradient(
                         colors: [
                           (game['color'] as Color).withOpacity(0.8),
                           game['color'] as Color,
                         ],
                       ),
                       borderRadius: BorderRadius.circular(14),
                     ),
                     child: Icon(game['icon'], color: Colors.white, size: 26),
                   ),
                   const SizedBox(height: 10),
                   Text(
                     game['title'],
                     textAlign: TextAlign.center,
                     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                     maxLines: 1,
                     overflow: TextOverflow.ellipsis,
                   )
                 ],
               ),
             ).animate().fadeIn(delay: (300 + index * 80).ms).slideX(),
          );
        },
      ),
    );
  }
}

