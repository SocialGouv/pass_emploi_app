import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/recherche/immersion/immersion_filtres_recherche.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/models/location.dart';

class ImmersionAlerte extends Equatable implements Alerte {
  final String id;
  final String title;
  final String codeRome;
  final String metier;
  final Location location;
  final String ville;
  final ImmersionFiltresRecherche filtres;

  ImmersionAlerte({
    required this.id,
    required this.title,
    required this.codeRome,
    required this.metier,
    required this.location,
    required this.ville,
    required this.filtres,
  });

  ImmersionAlerte copyWithTitle(String title) {
    return ImmersionAlerte(
      id: id,
      title: title,
      codeRome: codeRome,
      metier: metier,
      location: location,
      ville: ville,
      filtres: filtres,
    );
  }

  @override
  String getId() => id;

  @override
  String getTitle() => title;

  @override
  Location? getLocation() => location;

  @override
  List<Object?> get props => [id, title, codeRome, metier, location, ville, filtres];
}
