import 'package:equatable/equatable.dart';

class OffrePartagee extends Equatable {
  final String id;
  final String titre;
  final String url;
  final String message;
  final bool isAlternance;

  OffrePartagee({
    required this.id,
    required this.titre,
    required this.url,
    required this.message,
    required this.isAlternance,
  });

  @override
  List<Object?> get props => [id, titre, url, message, isAlternance];
}
