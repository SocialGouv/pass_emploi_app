import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

class EvenementEmploiDetails extends Equatable {
  final String id;
  final String? ville;
  final String? codePostal;
  final String? description;
  final String? titre;
  final String? typeEvenement;
  final DateTime? dateEvenement;
  final DateTime? heureDebut;
  final DateTime? heureFin;
  final String? url;

  EvenementEmploiDetails({
    required this.id,
    required this.ville,
    required this.codePostal,
    required this.description,
    required this.titre,
    required this.typeEvenement,
    required this.dateEvenement,
    required this.heureDebut,
    required this.heureFin,
    required this.url,
  });

  factory EvenementEmploiDetails.fromJson(dynamic json) {
    return EvenementEmploiDetails(
      id: json['id'] as String,
      ville: json['ville'] as String?,
      codePostal: json['codePostal'] as String?,
      description: json['description'] as String?,
      titre: json['titre'] as String?,
      typeEvenement: json['typeEvenement'] as String?,
      dateEvenement: (json['dateEvenement'] as String?)?.toDateTimeUnconsideringTimeZone(),
      heureDebut: (json['dateTimeDebut'] as String?)?.toDateTimeUtcOnLocalTimeZone(),
      heureFin: (json['dateTimeFin'] as String?)?.toDateTimeUtcOnLocalTimeZone(),
      url: json['url'] as String?,
    );
  }

  @override
  List<Object?> get props => [
        id,
        ville,
        codePostal,
        description,
        titre,
        typeEvenement,
        dateEvenement,
        heureDebut,
        heureFin,
        url,
      ];
}
