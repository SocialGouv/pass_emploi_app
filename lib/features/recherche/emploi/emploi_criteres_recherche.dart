import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/location.dart';

enum RechercheType {
  offreEmploiAndAlternance,
  onlyOffreEmploi,
  onlyAlternance;

  static RechercheType from(bool onlyAlternance) {
    return onlyAlternance
        ? RechercheType.onlyAlternance
        : RechercheType.offreEmploiAndAlternance;
  }

  bool isOnlyAlternance() => this == RechercheType.onlyAlternance;
}

class EmploiCriteresRecherche extends Equatable {
  final String keyword;
  final Location? location;
  final RechercheType rechercheType;

  EmploiCriteresRecherche({
    required this.keyword,
    required this.location,
    required this.rechercheType,
  });

  @override
  List<Object?> get props => [keyword, location, rechercheType];
}
