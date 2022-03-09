import 'package:pass_emploi_app/features/immersion/list/immersion_list_actions.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_request.dart';
import 'package:pass_emploi_app/features/immersion/search/immersion_search_state.dart';

ImmersionSearchState immersionSearchReducer(ImmersionSearchState current, dynamic action) {
  if (action is ImmersionListRequestAction) {
    final ImmersionListRequest request = action.request;
    return ImmersionSearchRequestState(
      codeRome: request.codeRome,
      ville: request.location.libelle,
      latitude: request.location.latitude ?? 0,
      longitude: request.location.longitude ?? 0,
    );
  } else {
    return current;
  }
}
