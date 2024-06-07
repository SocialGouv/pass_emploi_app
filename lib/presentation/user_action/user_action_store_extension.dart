import 'package:collection/collection.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
import 'package:pass_emploi_app/features/user_action/details/user_action_details_state.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

extension UserActionStoreExtension on Store<AppState> {
  UserAction? getAction(UserActionStateSource stateSource, String actionId) {
    switch (stateSource) {
      case UserActionStateSource.monSuivi:
        final state = this.state.monSuiviState;
        if (state is MonSuiviSuccessState) {
          return state.monSuivi.actions.firstWhereOrNull((e) => e.id == actionId);
        }
      case UserActionStateSource.noSource:
        final state = this.state.userActionDetailsState;
        if (state is UserActionDetailsSuccessState && state.result.id == actionId) return state.result;
        return null;
    }
    return null;
  }
}
