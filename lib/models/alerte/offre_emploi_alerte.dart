import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/emploi/emploi_filtres_recherche.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/ui/strings.dart';

class OffreEmploiAlerte extends Equatable implements Alerte {
  final String id;
  final String title;
  final String? metier;
  final Location? location;
  final String? keyword;
  final bool onlyAlternance;
  final EmploiFiltresRecherche filters;

  OffreEmploiAlerte({
    required this.id,
    required this.title,
    required this.metier,
    required this.location,
    required this.keyword,
    required this.onlyAlternance,
    required this.filters,
  });

  String getAlerteTagLabel() {
    return onlyAlternance ? Strings.alternanceTag : Strings.emploiTag;
  }

  OffreEmploiAlerte copyWithTitle(String title) {
    return OffreEmploiAlerte(
      id: id,
      title: title,
      metier: metier,
      location: location,
      keyword: keyword,
      onlyAlternance: onlyAlternance,
      filters: filters,
    );
  }

  @override
  String getId() => id;

  @override
  String getTitle() => title;

  @override
  Location? getLocation() => location;

  @override
  List<Object?> get props => [id, title, metier, location, keyword, onlyAlternance, filters];
}
