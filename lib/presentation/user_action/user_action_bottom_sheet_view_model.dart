import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_store_extension.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class UserActionBottomSheetViewModel extends Equatable {
  final UserActionStateSource source;
  final String userActionId;
  final bool withEditButton;
  final bool withDeleteButton;
  final void Function() onDuplicate;
  final void Function() onDelete;

  UserActionBottomSheetViewModel({
    required this.source,
    required this.userActionId,
    required this.withEditButton,
    required this.withDeleteButton,
    required this.onDuplicate,
    required this.onDelete,
  });

  @override
  List<Object?> get props => [withEditButton, withDeleteButton];

  factory UserActionBottomSheetViewModel.create(
      Store<AppState> store, UserActionStateSource source, String userActionId) {
    final userAction = store.getAction(source, userActionId);

    if (userAction == null) {
      return UserActionBottomSheetViewModel(
        source: source,
        userActionId: userActionId,
        withEditButton: false,
        withDeleteButton: false,
        onDuplicate: () {},
        onDelete: () {},
      );
    }
    return UserActionBottomSheetViewModel(
      source: source,
      userActionId: userActionId,
      withEditButton: _withUpdateButton(userAction),
      withDeleteButton: _withDeleteButton(userAction),
      onDuplicate: () => _onDuplicate(userAction),
      onDelete: () => store.dispatch(UserActionDeleteRequestAction(userAction.id)),
    );
  }
}

bool _withUpdateButton(UserAction? userAction) {
  return userAction?.qualificationStatus != UserActionQualificationStatus.QUALIFIEE;
}

bool _withDeleteButton(UserAction userAction) {
  return userAction.creator is JeuneActionCreator &&
      userAction.qualificationStatus != UserActionQualificationStatus.QUALIFIEE &&
      userAction.status != UserActionStatus.DONE;
}

void _onDuplicate(UserAction? userAction) {
  // TODO:
}
