import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

enum StateSource { agenda, userActions }

enum DeleteDisplayState { NOT_INIT, SHOW_LOADING, SHOW_DELETE_ERROR, TO_DISMISS_AFTER_DELETION }

enum UpdateDisplayState { NOT_INIT, SHOW_SUCCESS, SHOW_LOADING, SHOW_UPDATE_ERROR, TO_DISMISS_AFTER_UPDATE }

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
  final String id;
  final String title;
  final String subtitle;
  final bool withSubtitle;
  final UserActionStatus status;
  final String creator;
  final bool withDeleteOption;
  final UserActionDetailDateEcheanceViewModel? dateEcheanceViewModel;
  final Function(String actionId, UserActionStatus newStatus) onRefreshStatus;
  final Function(String actionId) onDelete;
  final Function() resetUpdateStatus;
  final UpdateDisplayState updateDisplayState;
  final DeleteDisplayState deleteDisplayState;

  UserActionDetailsViewModel._({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.withSubtitle,
    required this.status,
    required this.creator,
    required this.withDeleteOption,
    required this.dateEcheanceViewModel,
    required this.onRefreshStatus,
    required this.onDelete,
    required this.resetUpdateStatus,
    required this.updateDisplayState,
    required this.deleteDisplayState,
  });

  // tests pour la source agenda
  factory UserActionDetailsViewModel.create(Store<AppState> store, String userActionId, StateSource source) {
    switch (source) {
      case StateSource.agenda:
        return UserActionDetailsViewModel.createFromUserAgendaState(store, userActionId);
      case StateSource.userActions:
        return UserActionDetailsViewModel.createFromUserActionListState(store, userActionId);
    }
  }

  factory UserActionDetailsViewModel.createFromUserAgendaState(Store<AppState> store, String userActionId) {
    final agendaState = store.state.agendaState as AgendaSuccessState;
    final userAction = agendaState.agenda.actions.firstWhereOrNull((e) => e.id == userActionId);
    return UserActionDetailsViewModel.createWithAction(userAction, store);
  }

  factory UserActionDetailsViewModel.createFromUserActionListState(Store<AppState> store, String userActionId) {
    final userActionListState = store.state.userActionListState as UserActionListSuccessState;
    final userAction = userActionListState.userActions.firstWhereOrNull((e) => e.id == userActionId);
    return UserActionDetailsViewModel.createWithAction(userAction, store);
  }

  factory UserActionDetailsViewModel.createWithAction(UserAction? userAction, Store<AppState> store) {
    final updateState = store.state.userActionUpdateState;
    final deleteState = store.state.userActionDeleteState;
    return UserActionDetailsViewModel._(
      id: userAction != null ? userAction.id : '',
      title: userAction != null ? userAction.content : '',
      subtitle: userAction != null ? userAction.comment : '',
      withSubtitle: userAction != null ? userAction.comment.isNotEmpty : false,
      status: userAction != null ? userAction.status : UserActionStatus.DONE,
      creator: userAction != null ? _displayName(userAction.creator) : '',
      withDeleteOption: userAction != null ? userAction.creator is! ConseillerActionCreator : false,
      dateEcheanceViewModel: _dateEcheanceViewModel(userAction),
      onRefreshStatus: (actionId, newStatus) => _refreshStatus(store, actionId, newStatus),
      onDelete: (actionId) => store.dispatch(UserActionDeleteRequestAction(actionId)),
      resetUpdateStatus: () => store.dispatch(UserActionUpdateResetAction()),
      updateDisplayState: _updateStateDisplayState(updateState),
      deleteDisplayState: _deleteStateDisplayState(deleteState),
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        withSubtitle,
        status,
        creator,
        withDeleteOption,
        dateEcheanceViewModel,
        updateDisplayState,
        deleteDisplayState,
      ];
}

UserActionDetailDateEcheanceViewModel? _dateEcheanceViewModel(UserAction? userAction) {
  if (userAction == null) return null;
  if ([UserActionStatus.DONE, UserActionStatus.CANCELED].contains(userAction.status)) return null;
  final isLate = userAction.isLate();
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

DeleteDisplayState _deleteStateDisplayState(UserActionDeleteState state) {
  if (state is UserActionDeleteSuccessState) {
    return DeleteDisplayState.TO_DISMISS_AFTER_DELETION;
  } else if (state is UserActionDeleteLoadingState) {
    return DeleteDisplayState.SHOW_LOADING;
  } else if (state is UserActionDeleteFailureState) {
    return DeleteDisplayState.SHOW_DELETE_ERROR;
  } else {
    return DeleteDisplayState.NOT_INIT;
  }
}

UpdateDisplayState _updateStateDisplayState(UserActionUpdateState state) {
  if (state is UserActionUpdateSuccessState) {
    if (state.newStatus == UserActionStatus.DONE) {
      return UpdateDisplayState.SHOW_SUCCESS;
    } else {
      return UpdateDisplayState.TO_DISMISS_AFTER_UPDATE;
    }
  } else if (state is UserActionUpdateLoadingState) {
    return UpdateDisplayState.SHOW_LOADING;
  } else if (state is UserActionUpdateFailureState) {
    return UpdateDisplayState.SHOW_UPDATE_ERROR;
  }
  return UpdateDisplayState.NOT_INIT;
}

String _displayName(UserActionCreator creator) => creator is ConseillerActionCreator ? creator.name : Strings.you;

void _refreshStatus(Store<AppState> store, String actionId, UserActionStatus newStatus) {
  store.dispatch(UserActionUpdateRequestAction(actionId: actionId, newStatus: newStatus));
}
