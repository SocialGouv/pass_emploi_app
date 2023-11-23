import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/alerte/alerte.dart';

class RecherchesRecentesState extends Equatable {
  final List<Alerte> recentSearches;

  RecherchesRecentesState(this.recentSearches);

  @override
  List<Object?> get props => [recentSearches];
}
