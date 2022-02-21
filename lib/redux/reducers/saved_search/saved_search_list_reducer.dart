import 'package:pass_emploi_app/redux/actions/saved_search_actions.dart';

import '../../../models/saved_search/saved_search.dart';
import '../../states/state.dart';

class SavedSearchListReducer {
  State<List<SavedSearch>> reduce(SavedSearchListAction action) {
    if (action is RequestSavedSearchListAction) {
      return State.loading();
    } else if (action is SavedSearchListFailureAction) {
      return State.failure();
    } else if (action is SavedSearchListSuccessAction) {
      return State.success(action.savedSearches);
    } else {
      return State.notInitialized();
    }
  }
}
