import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/location.dart';

class ServiceCiviqueCriteresRecherche extends Equatable {
  final Location? location;

  ServiceCiviqueCriteresRecherche({
    required this.location,
  });

  @override
  List<Object?> get props => [location];
}
