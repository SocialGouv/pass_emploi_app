import 'package:async_redux/async_redux.dart' as async_redux;
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/store/environment.dart';
import 'package:pass_emploi_app/repositories/saved_search/saved_search_delete_repository.dart';
import 'package:redux/redux.dart' as redux;

class StoreFactoryV2 {
  final SavedSearchDeleteRepository savedSearchDeleteRepository;

  StoreFactoryV2(
    this.savedSearchDeleteRepository,
  );

  async_redux.Store<AppState> initializeReduxStoreV2({
    required AppState initialState,
    required redux.Store<AppState> storeV1,
  }) {
    return async_redux.Store<AppState>(
      initialState: initialState,
      environment: Environment(
        storeV1: storeV1,
        savedSearchDeleteRepository: savedSearchDeleteRepository,
      ),
    );
  }
}
