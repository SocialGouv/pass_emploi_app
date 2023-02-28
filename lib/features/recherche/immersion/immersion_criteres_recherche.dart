import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/metier.dart';

class ImmersionCriteresRecherche extends Equatable {
  final Metier metier;
  final Location location;

  ImmersionCriteresRecherche({
    required this.metier,
    required this.location,
  });

  @override
  List<Object?> get props => [metier, location];
}
