import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';
import 'package:pass_emploi_app/models/location.dart';

/// Used only for recent searches.
class EvenementEmploiAlerte extends Equatable implements Alerte {
  final String id;
  final String titre;
  final Location location;

  EvenementEmploiAlerte({required this.id, required this.titre, required this.location});

  @override
  String getId() => id;

  @override
  String getTitle() => titre;

  @override
  Location? getLocation() => location;

  @override
  List<Object?> get props => [id, titre, location];
}
