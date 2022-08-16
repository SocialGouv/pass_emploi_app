import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

enum UserActionDetailsDisplayState {
  SHOW_CONTENT,
  SHOW_SUCCESS,
  SHOW_LOADING,
  SHOW_DELETE_ERROR,
  TO_DISMISS,
  TO_DISMISS_AFTER_UPDATE,
  TO_DISMISS_AFTER_DELETION
}

class UserActionDetailDateEcheanceViewModel extends Equatable {
  final List<FormattedText> formattedTexts;
  final List<String> icons;
  final Color textColor;
  final Color backgroundColor;

  UserActionDetailDateEcheanceViewModel({
    required this.formattedTexts,
    required this.icons,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  List<Object?> get props => [formattedTexts, icons, textColor, backgroundColor];
}

class UserActionDetailsViewModel extends Equatable {
  final UserActionDetailsDisplayState displayState;
  final UserActionDetailDateEcheanceViewModel? dateEcheanceViewModel;
  final Function(String actionId, UserActionStatus newStatus) onRefreshStatus;
  final Function(String actionId) onDelete;

  UserActionDetailsViewModel._({
    required this.displayState,
    required this.dateEcheanceViewModel,
    required this.onRefreshStatus,
    required this.onDelete,
  });

  factory UserActionDetailsViewModel.create(Store<AppState> store, String userActionId) {
    final userActionListState = store.state.userActionListState as UserActionListSuccessState;
    final userAction = userActionListState.userActions.firstWhere((e) => e.id == userActionId);
    final isLate = userAction.isLate();
    return UserActionDetailsViewModel._(
      displayState: _displayState(store.state),
      dateEcheanceViewModel: _dateEcheanceViewModel(userAction, isLate),
      onRefreshStatus: (actionId, newStatus) => _refreshStatus(store, actionId, newStatus),
      onDelete: (actionId) => store.dispatch(UserActionDeleteRequestAction(actionId)),
    );
  }

  @override
  List<Object?> get props => [displayState, dateEcheanceViewModel];
}

UserActionDetailDateEcheanceViewModel? _dateEcheanceViewModel(UserAction userAction, bool isLate) {
  if ([UserActionStatus.DONE, UserActionStatus.CANCELED].contains(userAction.status)) return null;
  return UserActionDetailDateEcheanceViewModel(
    formattedTexts: _formattedDate(userAction),
    icons: [if (isLate) Drawables.icImportantOutlined, Drawables.icClock],
    textColor: isLate ? AppColors.warning : AppColors.accent2,
    backgroundColor: isLate ? AppColors.warningLighten : AppColors.accent3Lighten,
  );
}

List<FormattedText> _formattedDate(UserAction action) {
  return [
    FormattedText(Strings.demarcheActiveLabel),
    FormattedText(action.dateEcheance.toDayOfWeekWithFullMonth(), bold: true),
  ];
}

UserActionDetailsDisplayState _displayState(AppState state) {
  final updateState = state.userActionUpdateState;
  if (state.userActionDeleteState is UserActionDeleteSuccessState) {
    return UserActionDetailsDisplayState.TO_DISMISS_AFTER_DELETION;
  } else if (updateState is UserActionUpdatedState) {
    if (updateState.newStatus == UserActionStatus.DONE) {
      return UserActionDetailsDisplayState.SHOW_SUCCESS;
    } else {
      return UserActionDetailsDisplayState.TO_DISMISS_AFTER_UPDATE;
    }
  } else if (updateState is UserActionNoUpdateNeededState) {
    return UserActionDetailsDisplayState.TO_DISMISS;
  } else if (state.userActionDeleteState is UserActionDeleteLoadingState) {
    return UserActionDetailsDisplayState.SHOW_LOADING;
  } else if (state.userActionDeleteState is UserActionDeleteFailureState) {
    return UserActionDetailsDisplayState.SHOW_DELETE_ERROR;
  } else {
    return UserActionDetailsDisplayState.SHOW_CONTENT;
  }
}

void _refreshStatus(Store<AppState> store, String actionId, UserActionStatus newStatus) {
  final loginState = store.state.loginState;
  final userActionListState = store.state.userActionListState;
  if (userActionListState is UserActionListSuccessState) {
    if (loginState is LoginSuccessState) {
      final action = userActionListState.userActions.firstWhere((e) => e.id == actionId);
      if (action.status != newStatus) {
        store.dispatch(
          UserActionUpdateRequestAction(
            userId: loginState.user.id,
            actionId: actionId,
            newStatus: newStatus,
          ),
        );
      } else {
        store.dispatch(UserActionNoUpdateNeededAction());
      }
    }
  }
}
