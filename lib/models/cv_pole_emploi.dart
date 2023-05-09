import 'package:equatable/equatable.dart';

class CvPoleEmploi extends Equatable {
  final String titre;
  final String url;

  const CvPoleEmploi({required this.titre, required this.url});

  factory CvPoleEmploi.fromJson(dynamic json) {
    return CvPoleEmploi(
      titre: json['titre'] as String,
      url: json['url'] as String,
    );
  }

  @override
  List<Object?> get props => [titre, url];
}
