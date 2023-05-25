import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/location.dart';

class EvenementEmploiCriteresRecherche extends Equatable {
  final Location location;

  EvenementEmploiCriteresRecherche({
    required this.location,
  });

  @override
  List<Object?> get props => [location];
}
