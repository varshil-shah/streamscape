class User {
  late String userId;
  final String displayName;
  final String email;

  User({
    required this.userId,
    required this.displayName,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['_id'],
      displayName: json['displayName'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'displayName': displayName,
      'email': email,
    };
  }
}
