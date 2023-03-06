import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/saved_search/saved_search.dart';

abstract class RecherchesRecentesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RecherchesRecentesNotInitializedState extends RecherchesRecentesState {}

class RecherchesRecentesLoadingState extends RecherchesRecentesState {}

class RecherchesRecentesSuccessState extends RecherchesRecentesState {
  final List<SavedSearch> recentSearches;

  RecherchesRecentesSuccessState(this.recentSearches);

  @override
  List<Object?> get props => [recentSearches];
}
