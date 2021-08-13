class Conseiller {
  final String id;
  final String firstName;
  final String lastName;

  Conseiller({required this.id, required this.firstName, required this.lastName});

  factory Conseiller.fromJson(dynamic json) {
    return Conseiller(
        id: json['id'] as String, firstName: json['firstName'] as String, lastName: json['lastName'] as String);
  }
}
