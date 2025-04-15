import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_state.dart';
import 'package:pass_emploi_app/features/user_action/details/user_action_details_actions.dart';
import 'package:pass_emploi_app/features/user_action/details/user_action_details_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/requests/user_action_update_request.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_store_extension.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class UpdateUserActionViewModel extends Equatable {
  final String id;
  final DisplayState displayState;
  final DateTime date;
  final String title;
  final String description;
  final UserActionReferentielType? type;
  final bool showLoading;
  final bool shouldPop;
  final void Function(DateTime date, String title, String description, UserActionReferentielType? type) save;
  final void Function() delete;
  final void Function() onRety;

  UpdateUserActionViewModel._({
    required this.id,
    required this.displayState,
    required this.date,
    required this.title,
    required this.description,
    required this.type,
    required this.showLoading,
    required this.shouldPop,
    required this.save,
    required this.delete,
    required this.onRety,
  });

  factory UpdateUserActionViewModel.create(Store<AppState> store, UserActionStateSource source, String userActionId) {
    final userAction = store.getAction(source, userActionId);

    final displayState = _displayState(store, source);
    if (userAction == null) return UpdateUserActionViewModel.empty(displayState);

    return UpdateUserActionViewModel._(
      id: userAction.id,
      displayState: displayState,
      date: userAction.dateFin,
      title: userAction.content,
      description: userAction.comment,
      type: userAction.type,
      showLoading: _showLoading(store.state.userActionUpdateState, store.state.userActionDeleteState),
      shouldPop: store.state.userActionUpdateState is UserActionUpdateSuccessState,
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
      onRety: () => store.dispatch(UserActionDetailsRequestAction(userActionId)),
    );
  }

  factory UpdateUserActionViewModel.empty(DisplayState displayState) {
    return UpdateUserActionViewModel._(
      id: "",
      displayState: displayState,
      date: DateTime.now(),
      title: "",
      description: "",
      type: null,
      showLoading: false,
      shouldPop: false,
      save: (date, title, description, type) {},
      delete: () {},
      onRety: () {},
    );
  }

  @override
  List<Object?> get props => [id, date, title, description, type, showLoading, save, delete];
}

bool _showLoading(UserActionUpdateState updateState, UserActionDeleteState deleteState) {
  return updateState is UserActionUpdateLoadingState || deleteState is UserActionDeleteLoadingState;
}

DisplayState _displayState(
  Store<AppState> store,
  UserActionStateSource source,
) {
  if (source == UserActionStateSource.chatPartage) {
    final detailState = store.state.userActionDetailsState;
    return switch (detailState) {
      UserActionDetailsNotInitializedState() || UserActionDetailsLoadingState() => DisplayState.LOADING,
      UserActionDetailsFailureState() => DisplayState.FAILURE,
      UserActionDetailsSuccessState() => DisplayState.CONTENT,
    };
  }
  return DisplayState.CONTENT;
}
