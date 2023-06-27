import 'package:equatable/equatable.dart';

class CvPoleEmploi extends Equatable {
  final String titre;
  final String url;
  final String nomFichier;

  const CvPoleEmploi({required this.titre, required this.url, required this.nomFichier});

  factory CvPoleEmploi.fromJson(dynamic json) {
    return CvPoleEmploi(
      titre: json['titre'] as String,
      url: json['url'] as String,
      nomFichier: json['nomFichier'] as String,
    );
  }

  @override
  List<Object?> get props => [titre, url, nomFichier];
}
