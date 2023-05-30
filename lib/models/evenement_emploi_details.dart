import 'package:equatable/equatable.dart';

class EvenementEmploiDetails extends Equatable {
  final String tag;
  final String titre;
  final String date;
  final String heure;
  final String lieu;
  final String type;
  final String description;

  EvenementEmploiDetails({
    required this.tag,
    required this.titre,
    required this.date,
    required this.heure,
    required this.lieu,
    required this.type,
    required this.description,
  });

  factory EvenementEmploiDetails.fromJson(dynamic json) {
    return EvenementEmploiDetails(
      tag: json['tag'] as String,
      titre: json['titre'] as String,
      date: json['date'] as String,
      heure: json['heure'] as String,
      lieu: json['lieu'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
    );
  }

  @override
  List<Object?> get props => [tag, titre, date, heure, lieu, type, description];
}
