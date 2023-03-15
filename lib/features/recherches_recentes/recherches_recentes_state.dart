import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';

class RecherchesRecentesState extends Equatable {
  final List<SavedSearch> recentSearches;

  RecherchesRecentesState(this.recentSearches);

  @override
  List<Object?> get props => [recentSearches];
}
