import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/location.dart';

class EmploiCriteresRecherche extends Equatable {
  final String keywords;
  final Location? location;
  final bool onlyAlternance;

  EmploiCriteresRecherche({
    required this.keywords,
    required this.location,
    required this.onlyAlternance,
  });

  @override
  List<Object?> get props => [keywords, location, onlyAlternance];
}
