import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_state.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_pillule.dart';
import 'package:redux/redux.dart';

enum DeleteDisplayState { NOT_INIT, SHOW_LOADING, SHOW_DELETE_ERROR, TO_DISMISS_AFTER_DELETION }

enum UpdateDisplayState { NOT_INIT, SHOW_SUCCESS, SHOW_LOADING, SHOW_UPDATE_ERROR, TO_DISMISS_AFTER_UPDATE }

class UserActionDetailDateEcheanceViewModel extends Equatable {
  final List<FormattedText> formattedTexts;
  final List<IconData> icons;
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
  final UserActionStatus status; // TODO: Remove
  final CardPilluleType? pillule;
  final bool withFinishedButton;
  final bool withUnfinishedButton;
  final String creator;
  final bool withDeleteOption;
  final UserActionDetailDateEcheanceViewModel? dateEcheanceViewModel;
  final bool withOfflineBehavior;
  final Function(String actionId, UserActionStatus newStatus) onRefreshStatus;
  final Function(String actionId) onDelete;
  final Function() resetUpdateStatus;
  final Function(UserActionStatus) updateStatus;
  final UpdateDisplayState updateDisplayState;
  final DeleteDisplayState deleteDisplayState;

  UserActionDetailsViewModel._({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.withSubtitle,
    required this.status,
    required this.pillule,
    required this.withFinishedButton,
    required this.withUnfinishedButton,
    required this.creator,
    required this.withDeleteOption,
    required this.dateEcheanceViewModel,
    required this.withOfflineBehavior,
    required this.onRefreshStatus,
    required this.onDelete,
    required this.resetUpdateStatus,
    required this.updateStatus,
    required this.updateDisplayState,
    required this.deleteDisplayState,
  });

  factory UserActionDetailsViewModel.create(Store<AppState> store, UserActionStateSource source, String userActionId) {
    final userAction = _getAction(store, source, userActionId);
    final updateState = store.state.userActionUpdateState;
    final deleteState = store.state.userActionDeleteState;
    final commentsState = store.state.actionCommentaireListState;
    final hasComments = commentsState is ActionCommentaireListSuccessState ? commentsState.comments.isNotEmpty : false;
    return UserActionDetailsViewModel._(
      id: userAction != null ? userAction.id : '',
      title: userAction != null ? userAction.content : '',
      subtitle: userAction != null ? userAction.comment : '',
      withSubtitle: userAction != null ? userAction.comment.isNotEmpty : false,
      status: userAction != null ? userAction.status : UserActionStatus.DONE,
      pillule: _pilluleViewModel(userAction?.status),
      withFinishedButton: userAction != null ? userAction.status != UserActionStatus.DONE : false,
      withUnfinishedButton: userAction != null ? userAction.status == UserActionStatus.DONE : false,
      creator: userAction != null ? _displayName(userAction.creator) : '',
      withDeleteOption: _withDeleteOption(userAction, hasComments),
      dateEcheanceViewModel: _dateEcheanceViewModel(userAction),
      withOfflineBehavior: store.state.connectivityState.isOffline(),
      onRefreshStatus: (actionId, newStatus) => _refreshStatus(store, actionId, newStatus),
      onDelete: (actionId) => store.dispatch(UserActionDeleteRequestAction(actionId)),
      resetUpdateStatus: () => store.dispatch(UserActionUpdateResetAction()),
      updateStatus: (status) =>
          store.dispatch(UserActionUpdateRequestAction(actionId: userActionId, newStatus: status)),
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
        pillule,
        withFinishedButton,
        withUnfinishedButton,
        creator,
        withDeleteOption,
        dateEcheanceViewModel,
        updateDisplayState,
        deleteDisplayState,
        withOfflineBehavior,
      ];
}

bool _withDeleteOption(UserAction? userAction, bool hasComments) =>
    userAction?.creator is JeuneActionCreator && !hasComments && userAction?.status != UserActionStatus.DONE;

UserAction? _getAction(Store<AppState> store, UserActionStateSource stateSource, String actionId) {
  switch (stateSource) {
    case UserActionStateSource.agenda:
      final state = store.state.agendaState as AgendaSuccessState;
      return state.agenda.actions.firstWhereOrNull((e) => e.id == actionId);
    case UserActionStateSource.list:
      final state = store.state.userActionListState as UserActionListSuccessState;
      return state.userActions.firstWhereOrNull((e) => e.id == actionId);
  }
}

UserActionDetailDateEcheanceViewModel? _dateEcheanceViewModel(UserAction? userAction) {
  if (userAction == null) return null;
  if ([UserActionStatus.DONE, UserActionStatus.CANCELED].contains(userAction.status)) return null;
  final isLate = userAction.isLate();
  return UserActionDetailDateEcheanceViewModel(
    formattedTexts: _formattedDate(userAction),
    icons: [AppIcons.schedule_rounded],
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

CardPilluleType? _pilluleViewModel(UserActionStatus? status) {
  if (status == null) return null;
  return switch (status) {
    UserActionStatus.DONE => CardPilluleType.done,
    _ => CardPilluleType.doing,
  };
}
