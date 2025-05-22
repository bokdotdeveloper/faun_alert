class User {
  final String uid;
  final String email;
  final String firstName;
  final String middleName;
  final String lastName;
  final String role;
  final String password;

  User({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.role,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'] ?? '',
      middleName: json['middle_name'] ?? '',
      lastName: json['last_name'] ?? '',
      role: json['role'] ?? 'user',
      password: json['password'] ?? '',
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'role': role,
      'password': password,
    };
  }
}