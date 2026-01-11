import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  FirestoreService() {
    print("Firestore connected to project: ${_db.app.options.projectId}");
  }

  // Collection References
  CollectionReference get _usersRef => _db.collection('users');

  // User Operations
  Future<void> createUser(UserModel user) async {
    await _usersRef.doc(user.id).set(user.toMap());
  }

  Stream<UserModel?> getUserStream(String userId) {
    return _usersRef.doc(userId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
      }
      return null;
    });
  }

  Future<void> updateUserXP(String userId, int newXP) async {
    // Logic to calculate level up can go here or Cloud Functions
    await _usersRef.doc(userId).update({'xp': FieldValue.increment(newXP)});
  }

  Future<void> updateUserProfile(String userId, String name, String? photoUrl) async {
    await _usersRef.doc(userId).set({
      'name': name,
      'photoUrl': photoUrl,
    }, SetOptions(merge: true));
  }

  // Leaderboard
  Stream<List<UserModel>> getLeaderboard() {
    return _usersRef
        .orderBy('xp', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
