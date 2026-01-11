import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import 'pages/auth/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() async {
    await Future.delayed(const Duration(milliseconds: 3500));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF81C784), // Light green (sky/nature)
              Color(0xFF2E7D32), // Forest green
              Color(0xFF1B5E20), // Dark green (ground)
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Animated decorative elements (clouds/leaves)
              _buildFloatingElements(),
              const SizedBox(height: 20),
              // Logo with animation
              _buildAnimatedLogo(),
              const SizedBox(height: 32),
              // App name with animation
              _buildAppName(),
              const SizedBox(height: 12),
              // Tagline with animation
              _buildTagline(),
              const Spacer(flex: 2),
              // Loading indicator
              _buildLoadingIndicator(),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingElements() {
    return SizedBox(
      height: 60,
      child: Stack(
        children: [
          // Floating leaf/cloud elements
          Positioned(
            left: 40,
            child: Icon(
              Icons.eco,
              color: Colors.white.withOpacity(0.3),
              size: 40,
            )
                .animate(onPlay: (c) => c.repeat())
                .moveY(begin: 0, end: -10, duration: 2000.ms)
                .then()
                .moveY(begin: -10, end: 0, duration: 2000.ms),
          ),
          Positioned(
            right: 60,
            top: 10,
            child: Icon(
              Icons.park,
              color: Colors.white.withOpacity(0.3),
              size: 35,
            )
                .animate(onPlay: (c) => c.repeat())
                .moveY(begin: 0, end: -8, duration: 1800.ms, delay: 300.ms)
                .then()
                .moveY(begin: -8, end: 0, duration: 1800.ms),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 20,
            child: Icon(
              Icons.nature,
              color: Colors.white.withOpacity(0.25),
              size: 45,
            )
                .animate(onPlay: (c) => c.repeat())
                .moveY(begin: 0, end: -12, duration: 2200.ms, delay: 500.ms)
                .then()
                .moveY(begin: -12, end: 0, duration: 2200.ms),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/icone/logo.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    )
        .animate()
        .scale(
          begin: const Offset(0.5, 0.5),
          end: const Offset(1, 1),
          duration: 800.ms,
          curve: Curves.elasticOut,
        )
        .fadeIn(duration: 600.ms)
        .then()
        .animate(onPlay: (c) => c.repeat())
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.05, 1.05),
          duration: 1500.ms,
        )
        .then()
        .scale(
          begin: const Offset(1.05, 1.05),
          end: const Offset(1, 1),
          duration: 1500.ms,
        );
  }

  Widget _buildAppName() {
    return Column(
      children: [
        Text(
          'Menjelajah',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 2,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(delay: 400.ms, duration: 600.ms)
            .slideY(begin: 0.3, end: 0),
        const SizedBox(height: 4),
        Text(
          'Lingkungan Sekitar',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.95),
            letterSpacing: 1,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(delay: 600.ms, duration: 600.ms)
            .slideY(begin: 0.3, end: 0),
      ],
    );
  }

  Widget _buildTagline() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.explore,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: 8),
          const Text(
            'Ayo jelajahi alam sekitarmu',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 900.ms, duration: 500.ms)
        .slideY(begin: 0.5, end: 0);
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        SizedBox(
          width: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 4,
            ),
          ),
        )
            .animate()
            .fadeIn(delay: 1200.ms, duration: 400.ms),
        const SizedBox(height: 12),
        Text(
          'Memuat...',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
            fontWeight: FontWeight.w500,
          ),
        )
            .animate()
            .fadeIn(delay: 1400.ms, duration: 400.ms),
      ],
    );
  }
}
