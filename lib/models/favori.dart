import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/ui/strings.dart';

enum FavoriStatus { added, removed }

class Favori extends Equatable {
  final String id;
  final OffreType type;
  final String titre;
  final String? organisation;
  final String? localisation;

  Favori({
    required this.id,
    required this.type,
    required this.titre,
    required this.organisation,
    required this.localisation,
  });

  static Favori? fromJson(dynamic json) {
    final type = OffreType.from(json["type"] as String);
    if (type == null) return null;
    return Favori(
      id: json['idOffre'] as String,
      type: type,
      titre: json['titre'] as String,
      organisation: json['organisation'] as String?,
      localisation: json['localisation'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, type, titre, organisation, localisation];
}

extension FavoriExt on Favori {
  OffreEmploi get toOffreEmploi => OffreEmploi(
        id: id,
        title: titre,
        companyName: organisation,
        contractType: Strings.favorisUnknownContractType,
        isAlternance: false,
        location: localisation,
        duration: null,
        origin: null,
      );

  Immersion get toImmersion => Immersion(
        id: id,
        metier: titre,
        nomEtablissement: organisation ?? '',
        secteurActivite: Strings.favorisUnknownSecteur,
        ville: localisation ?? '',
      );

  ServiceCivique get toServiceCivique => ServiceCivique(
        id: id,
        title: titre,
        location: localisation,
        domain: null,
        companyName: organisation,
        startDate: null,
      );
}
