import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/location.dart';

class ImmersionCriteresRecherche extends Equatable {
  final String codeRome;
  final Location? location;

  ImmersionCriteresRecherche({
    required this.codeRome,
    required this.location,
  });

  @override
  List<Object?> get props => [codeRome, location];
}
