import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/service_civique/domain.dart';
import 'package:pass_emploi_app/models/service_civique_filtres_pameters.dart';

class ServiceCiviqueAlerte extends Equatable implements Alerte {
  final String id;
  final String titre;
  final String? ville;
  final ServiceCiviqueFiltresParameters filtres;
  final Location? location;
  final Domaine? domaine;
  final DateTime? dateDeDebut;

  ServiceCiviqueAlerte({
    required this.id,
    required this.titre,
    required this.filtres,
    this.ville,
    this.location,
    this.domaine,
    this.dateDeDebut,
  });

  ServiceCiviqueAlerte copyWithTitle(String title) {
    return ServiceCiviqueAlerte(
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
  String getId() => id;

  @override
  String getTitle() => titre;

  @override
  Location? getLocation() => location;

  @override
  List<Object?> get props => [id, titre, ville, filtres, location, domaine, dateDeDebut];
}
