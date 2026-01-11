import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/models/user_model.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Papan Peringkat'),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: FirestoreService().getLeaderboard(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada data peringkat."));
          }

          final users = snapshot.data!;
          // Map to format expected by widgets (adding rank index)
          final List<Map<String, dynamic>> rankedUsers = users.asMap().entries.map((entry) {
            final index = entry.key;
            final user = entry.value;
            return {
              'name': user.name,
              'xp': user.xp,
              'rank': index + 1,
              'avatar': Icons.face, // Placeholder. Could be user.photoUrl if implemented
            };
          }).toList();

          return Column(
            children: [
              if (rankedUsers.isNotEmpty) _buildPodium(context, rankedUsers.take(3).toList()),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: rankedUsers.length > 3 ? rankedUsers.length - 3 : 0,
                    itemBuilder: (context, index) {
                      final user = rankedUsers[index + 3];
                      return _buildRankItem(user);
                    },
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildPodium(BuildContext context, List<Map<String, dynamic>> topUsers) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary, // Pastel Green/Blue background
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: _buildPodiumItem(topUsers[1], 80, 2)), // 2nd Place
          Expanded(child: _buildPodiumItem(topUsers[0], 110, 1)), // 1st Place (Larger)
          Expanded(child: _buildPodiumItem(topUsers[2], 80, 3)), // 3rd Place
        ],
      ),
    );
  }

  Widget _buildPodiumItem(Map<String, dynamic> user, double size, int rank) {
    Color ringColor = rank == 1 ? const Color(0xFFFFD700) : (rank == 2 ? const Color(0xFFC0C0C0) : const Color(0xFFCD7F32));
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: ringColor, width: 3),
                color: Colors.white,
              ),
              child: Icon(user['avatar'], size: size / 2, color: AppColors.textPrimary),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: ringColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Text(
                '#$rank',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          user['name'],
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '${user['xp']} XP',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRankItem(Map<String, dynamic> user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            '#${user['rank']}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            backgroundColor: AppColors.pastelBlue.withOpacity(0.1),
            child: Icon(user['avatar'], color: AppColors.textPrimary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              user['name'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            '${user['xp']} XP',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideX();
  }
}
