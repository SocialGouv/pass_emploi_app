import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/requests/user_action_update_request.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_store_extension.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class UpdateUserActionViewModel extends Equatable {
  final String id;
  final DateTime date;
  final String title;
  final String description;
  final UserActionReferentielType? type;
  final bool showLoading;
  final void Function(DateTime date, String title, String description, UserActionReferentielType? type) save;
  final void Function() delete;

  UpdateUserActionViewModel._({
    required this.id,
    required this.date,
    required this.title,
    required this.description,
    required this.type,
    required this.showLoading,
    required this.save,
    required this.delete,
  });

  factory UpdateUserActionViewModel.create(Store<AppState> store, UserActionStateSource source, String userActionId) {
    final userAction = store.getAction(source, userActionId);

    if (userAction == null) return UpdateUserActionViewModel.empty();

    return UpdateUserActionViewModel._(
      id: userAction.id,
      date: userAction.dateEcheance,
      title: userAction.content,
      description: userAction.comment,
      type: userAction.type,
      showLoading: _showLoading(store.state.userActionUpdateState, store.state.userActionDeleteState),
      save: (date, title, description, type) => store.dispatch(
        UserActionUpdateRequestAction(
          actionId: userActionId,
          request: UserActionUpdateRequest(
            status: userAction.status,
            dateEcheance: date,
            contenu: title,
            description: description,
            type: type,
          ),
        ),
      ),
      delete: () => store.dispatch(UserActionDeleteRequestAction(userActionId)),
    );
  }

  factory UpdateUserActionViewModel.empty() {
    return UpdateUserActionViewModel._(
      id: "",
      date: DateTime.now(),
      title: "",
      description: "",
      type: null,
      showLoading: false,
      save: (date, title, description, type) {},
      delete: () {},
    );
  }

  @override
  List<Object?> get props => [id, date, title, description, type, showLoading, save, delete];
}

bool _showLoading(UserActionUpdateState updateState, UserActionDeleteState deleteState) {
  return updateState is UserActionUpdateLoadingState || deleteState is UserActionDeleteLoadingState;
}
