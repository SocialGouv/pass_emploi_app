import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/service_civique/domain.dart';

class ServiceCiviqueFiltresRecherche extends Equatable {
  final int? distance;
  final DateTime? startDate;
  final Domaine? domain;

  ServiceCiviqueFiltresRecherche({
    required this.distance,
    required this.startDate,
    required this.domain,
  });

  factory ServiceCiviqueFiltresRecherche.noFiltre() {
    return ServiceCiviqueFiltresRecherche(distance: null, startDate: null, domain: null);
  }

  @override
  List<Object?> get props => [distance, startDate, domain];
}
