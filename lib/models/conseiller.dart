import 'package:equatable/equatable.dart';

class Conseiller extends Equatable {
  final String id;
  final String firstName;
  final String lastName;

  const Conseiller({required this.id, required this.firstName, required this.lastName});

  factory Conseiller.fromJson(dynamic json) {
    return Conseiller(
      id: json['id'] as String,
      firstName: json['prenom'] as String,
      lastName: json['nom'] as String,
    );
  }

  @override
  List<Object?> get props => [id, firstName, lastName];
}
