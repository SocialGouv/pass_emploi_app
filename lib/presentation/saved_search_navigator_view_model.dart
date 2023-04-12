import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_navigation_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class SavedSearchNavigatorViewModel extends Equatable {
  final SavedSearchNavigationState searchNavigationState;

  SavedSearchNavigatorViewModel({
    required this.searchNavigationState,
  });

  static SavedSearchNavigatorViewModel create(Store<AppState> store) {
    return SavedSearchNavigatorViewModel(
      searchNavigationState: SavedSearchNavigationState.fromAppState(store.state),
    );
  }

  @override
  List<Object?> get props => [searchNavigationState];
}
