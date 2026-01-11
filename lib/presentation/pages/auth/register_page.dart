import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../main_screen.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/firestore_service.dart';
import '../../../data/models/user_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      // Show Loading
      showDialog(
        context: context, 
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator())
      );

      try {
        final user = await AuthService().signUpWithEmail(
          _emailController.text.trim(), 
          _passwordController.text.trim()
        );

        if (user != null) {
          // Create User in Firestore
          final newUser = UserModel(
            id: user.uid,
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            xp: 0,
            level: 1,
            stars: 0,
          );

          await FirestoreService().createUser(newUser);

          // Hide Loading
          if (mounted) Navigator.pop(context);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Daftar Berhasil! Silakan Login."), backgroundColor: Colors.green),
            );
             Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
              (route) => false,
            );
          }
        }
      } catch (e) {
        // Hide Loading
        if (mounted) Navigator.pop(context);
        
        String errorMessage = e.toString();
        
        if (errorMessage.contains("permission-denied") || errorMessage.contains("Missing or insufficient permissions")) {
          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Izin Database Ditolak"),
                content: const Text(
                  "Akun berhasil dibuat, tapi data profil gagal disimpan.\n\n"
                  "SOLUSI: Buka Firebase Console -> Firestore Database -> Rules -> Ubah 'allow read, write: if false;' menjadi 'allow read, write: if true;' (Mode Test) untuk sementara."
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Force navigate to home anyway since auth worked
                       Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const MainScreen()),
                        (route) => false,
                      );
                    },
                    child: const Text("Siap, Lanjut Aja"),
                  )
                ],
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: $errorMessage"), backgroundColor: AppColors.error),
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
            child: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20)
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.person_add_alt_1_rounded, size: 64, color: AppColors.primary)
                    .animate().scale(curve: Curves.elasticOut),
                const SizedBox(height: 24),
                Text(
                  "Buat Akun Baru",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ).animate().fadeIn().slideY(begin: 0.3, end: 0),
                const SizedBox(height: 8),
                Text(
                  "Daftar sekarang dan jadilah juara kelas!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                ).animate().fadeIn(delay: 200.ms),
                const SizedBox(height: 32),
                
                // Form Container
                Container(
                   padding: const EdgeInsets.all(24),
                   decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(24),
                     boxShadow: [
                       BoxShadow(
                         color: Colors.grey.withOpacity(0.1),
                         blurRadius: 20,
                         offset: const Offset(0, 10),
                       )
                     ]
                   ),
                   child: Column(
                     children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: "Nama Lengkap",
                            prefixIcon: const Icon(Icons.person_outline),
                            filled: true,
                            fillColor: AppColors.background,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          ),
                          validator: (value) => value!.isEmpty ? "Nama tidak boleh kosong" : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: const Icon(Icons.email_outlined),
                            filled: true,
                            fillColor: AppColors.background,
                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          ),
                          validator: (value) => value!.isEmpty ? "Email tidak boleh kosong" : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: const Icon(Icons.lock_outline),
                            filled: true,
                            fillColor: AppColors.background,
                             border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          ),
                          validator: (value) => value!.isEmpty ? "Password tidak boleh kosong" : null,
                        ),
                     ],
                   ),
                ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0),

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _register,
                     style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 5,
                        shadowColor: AppColors.primary.withOpacity(0.4),
                      ),
                    child: const Text("Daftar Sekarang", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  ),
                ).animate().fadeIn(delay: 600.ms),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }
}
