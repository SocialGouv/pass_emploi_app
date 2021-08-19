class User {
  final String id;
  final String firstName;
  final String lastName;

  User({required this.id, required this.firstName, required this.lastName});

  factory User.fromJson(dynamic json) {
    return User(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
