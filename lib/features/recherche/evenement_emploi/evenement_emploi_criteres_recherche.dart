import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/evenement_emploi/secteur_activite.dart';
import 'package:pass_emploi_app/models/location.dart';

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
