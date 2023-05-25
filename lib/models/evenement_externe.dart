import 'package:equatable/equatable.dart';

class EvenementExterne extends Equatable {
  final String id;
  final String titre;

  EvenementExterne({
    required this.id,
    required this.titre,
  });

  @override
  List<Object?> get props => [id];

  factory EvenementExterne.fromJson(dynamic json) {
    return EvenementExterne(
      id: json['id'] as String,
      titre: json['titre'] as String,
    );
  }
}
