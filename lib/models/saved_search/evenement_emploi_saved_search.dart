import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';

/// Used only for recent searches.
class EvenementEmploiSavedSearch extends Equatable implements SavedSearch {
  final String id;
  final String titre;
  final Location location;

  EvenementEmploiSavedSearch({required this.id, required this.titre, required this.location});

  @override
  String getId() => id;

  @override
  String getTitle() => titre;

  @override
  Location? getLocation() => location;

  @override
  List<Object?> get props => [id, titre, location];
}
