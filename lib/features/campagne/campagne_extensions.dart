import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_state.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';


extension CampagneExtension on Store<AppState> {
  Campagne? campagne() {
    final loginState = state.loginState;
    if (loginState is! LoginSuccessState) return null;

    if (loginState.user.loginMode.isPe()) {
      final actionsState = state.userActionPEListState;
      if (actionsState is! UserActionPEListSuccessState) return null;
      return actionsState.campagne;
    } else {
      final actionsState = state.userActionListState;
      if (actionsState is! UserActionListSuccessState) return null;
      return actionsState.campagne;
    }
  }
}
