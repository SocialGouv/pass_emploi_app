import 'package:equatable/equatable.dart';

class EvenementEmploi extends Equatable {
  final String id;
  final String titre;

  EvenementEmploi({
    required this.id,
    required this.titre,
  });

  @override
  List<Object?> get props => [id];

  factory EvenementEmploi.fromJson(dynamic json) {
    return EvenementEmploi(
      id: json['id'] as String,
      titre: json['titre'] as String,
    );
  }
}
