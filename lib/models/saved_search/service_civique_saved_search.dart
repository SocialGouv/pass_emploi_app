import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';
import 'package:pass_emploi_app/models/service_civique/domain.dart';
import 'package:pass_emploi_app/models/service_civique_filtres_pameters.dart';

class ServiceCiviqueSavedSearch extends Equatable implements SavedSearch {
  final String id;
  final String titre;
  final String? ville;
  final ServiceCiviqueFiltresParameters filtres;
  final Location? location;
  final Domaine? domaine;
  final DateTime? dateDeDebut;

  ServiceCiviqueSavedSearch({
    required this.id,
    required this.titre,
    required this.filtres,
    this.ville,
    this.location,
    this.domaine,
    this.dateDeDebut,
  });

  ServiceCiviqueSavedSearch copyWithTitle(String title) {
    return ServiceCiviqueSavedSearch(
      id: id,
      titre: title,
      ville: ville,
      filtres: filtres,
      location: location,
      domaine: domaine,
      dateDeDebut: dateDeDebut,
    );
  }

  @override
  String getId() {
    return id;
  }

  @override
  String getTitle() {
    return titre;
  }

  @override
  List<Object?> get props => [id, titre, ville, filtres, location, domaine, dateDeDebut];
}
