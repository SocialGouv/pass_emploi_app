import 'package:equatable/equatable.dart';

class OffrePartagee extends Equatable {
  final String id;
  final String titre;
  final String url;
  final String message;

  OffrePartagee({required this.id, required this.titre, required this.url, required this.message});

  @override
  List<Object?> get props => [id, titre, url, message];
}