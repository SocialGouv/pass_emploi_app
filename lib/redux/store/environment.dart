import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart' as redux;

import '../../repositories/saved_search/saved_search_delete_repository.dart';

class Environment {
  final redux.Store<AppState> storeV1;
  final SavedSearchDeleteRepository savedSearchDeleteRepository;

  Environment({required this.storeV1, required this.savedSearchDeleteRepository});
}
