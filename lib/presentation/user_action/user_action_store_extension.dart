import 'package:collection/collection.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
import 'package:pass_emploi_app/features/user_action/details/user_action_details_state.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

extension UserActionStoreExtension on Store<AppState> {
  UserAction? getAction(UserActionStateSource stateSource, String actionId) {
    return switch (stateSource) {
      UserActionStateSource.monSuivi => _getActionFromMonSuivi(state.monSuiviState, actionId),
      UserActionStateSource.noSource ||
      UserActionStateSource.chatPartage =>
        _getActionFromDetails(state.userActionDetailsState, actionId),
    };
  }
}

UserAction? _getActionFromMonSuivi(MonSuiviState state, String actionId) {
  if (state is MonSuiviSuccessState) {
    return state.monSuivi.actions.firstWhereOrNull((e) => e.id == actionId);
  }
  return null;
}

UserAction? _getActionFromDetails(UserActionDetailsState state, String actionId) {
  if (state is UserActionDetailsSuccessState && state.result.id == actionId) {
    return state.result;
  }
  return null;
}
