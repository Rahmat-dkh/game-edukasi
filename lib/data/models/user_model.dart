class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final int xp;
  final int level;
  final int stars;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.xp = 0,
    this.level = 1,
    this.stars = 0,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photoUrl'],
      xp: data['xp'] ?? 0,
      level: data['level'] ?? 1,
      stars: data['stars'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'xp': xp,
      'level': level,
      'stars': stars,
    };
  }
}
