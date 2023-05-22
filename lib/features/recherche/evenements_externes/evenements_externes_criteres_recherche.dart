import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/location.dart';

class EvenementsExternesCriteresRecherche extends Equatable {
  final Location location;

  EvenementsExternesCriteresRecherche({
    required this.location,
  });

  @override
  List<Object?> get props => [location];
}
