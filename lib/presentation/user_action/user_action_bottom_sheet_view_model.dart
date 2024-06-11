import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_store_extension.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:redux/redux.dart';

class UserActionBottomSheetViewModel extends Equatable {
  final UserActionStateSource source;
  final String userActionId;
  final bool withUpdateButton;
  final bool withDeleteButton;
  final void Function() onDelete;

  UserActionBottomSheetViewModel({
    required this.source,
    required this.userActionId,
    required this.withUpdateButton,
    required this.withDeleteButton,
    required this.onDelete,
  });

  @override
  List<Object?> get props => [withUpdateButton, withDeleteButton];

  factory UserActionBottomSheetViewModel.create(
      Store<AppState> store, UserActionStateSource source, String userActionId) {
    final userAction = store.getAction(source, userActionId);

    if (userAction == null) {
      return UserActionBottomSheetViewModel(
        source: source,
        userActionId: userActionId,
        withUpdateButton: false,
        withDeleteButton: false,
        onDelete: () {},
      );
    }
    return UserActionBottomSheetViewModel(
      source: source,
      userActionId: userActionId,
      withUpdateButton: _withUpdateButton(userAction),
      withDeleteButton: _withDeleteButton(userAction),
      onDelete: () {
        store.dispatch(UserActionDeleteRequestAction(userAction.id));
        PassEmploiMatomoTracker.instance.trackScreen(AnalyticsActionNames.deleteUserAction);
      },
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
