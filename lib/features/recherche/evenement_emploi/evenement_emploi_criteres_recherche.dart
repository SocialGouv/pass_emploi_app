import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/secteur_activite.dart';

class EvenementEmploiCriteresRecherche extends Equatable {
  final Location location;
  final SecteurActivite? secteurActivite;

  EvenementEmploiCriteresRecherche({
    required this.location,
    required this.secteurActivite,
  });

  @override
  List<Object?> get props => [location, secteurActivite];
}
