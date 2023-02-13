import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/location.dart';

class EmploiCriteresRecherche extends Equatable {
  final String keyword;
  final Location? location;
  final bool onlyAlternance;

  EmploiCriteresRecherche({
    required this.keyword,
    required this.location,
    required this.onlyAlternance,
  });

  @override
  List<Object?> get props => [keyword, location, onlyAlternance];
}
