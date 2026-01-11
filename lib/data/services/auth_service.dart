import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Success
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'Pengguna tidak ditemukan.';
      } else if (e.code == 'wrong-password') {
        return 'Password salah.';
      } else if (e.code == 'invalid-email') {
        return 'Email tidak valid.';
      }
      return 'Error: ${e.message}';
    } catch (e) {
      return 'Error login: $e';
    }
  }

  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code}');
      throw e.message ?? 'Terjadi kesalahan saat daftar.';
    } catch (e) {
      print('Error signing up: $e');
      throw 'Gagal mendaftar: $e';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
