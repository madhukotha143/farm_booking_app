class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String avatarUrl;
  final String displayName;
  final int needUpdatePw;
  final String? accessToken;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatarUrl,
    required this.displayName,
    required this.needUpdatePw,
    this.accessToken,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Handle the case where user data is nested inside a 'user' key
    if (json.containsKey('user')) {
      final userData = json['user'] as Map<String, dynamic>;
      return User(
        id: userData['id'],
        firstName: userData['first_name'],
        lastName: userData['last_name'],
        email: userData['email'],
        avatarUrl: userData['avatar_url'],
        displayName: userData['display_name'],
        needUpdatePw: userData['need_update_pw'],
        accessToken: json['access_token'],
      );
    } else {
      // Direct parsing if the JSON is already the user object
      return User(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        avatarUrl: json['avatar_url'],
        displayName: json['display_name'],
        needUpdatePw: json['need_update_pw'],
        accessToken: null,
      );
    }
  }

  // Convert user to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'avatar_url': avatarUrl,
      'display_name': displayName,
      'need_update_pw': needUpdatePw,
    };
  }

  // Get full name
  String get fullName => '$firstName $lastName';
}
