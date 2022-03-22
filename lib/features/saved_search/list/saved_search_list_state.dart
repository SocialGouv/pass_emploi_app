import 'package:pass_emploi_app/models/saved_search/saved_search.dart';

abstract class SavedSearchListState {}

class SavedSearchListNotInitializedState extends SavedSearchListState {}

class SavedSearchListLoadingState extends SavedSearchListState {}

class SavedSearchListSuccessState extends SavedSearchListState {
  final List<SavedSearch> savedSearches;

  SavedSearchListSuccessState(this.savedSearches);
}

class SavedSearchListFailureState extends SavedSearchListState {}
