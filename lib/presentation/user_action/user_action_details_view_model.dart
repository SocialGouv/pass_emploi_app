import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_state.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/requests/user_action_update_request.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/pages/user_action_form/create_user_action_form_step1_page.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_pillule.dart';
import 'package:redux/redux.dart';

enum DeleteDisplayState { NOT_INIT, SHOW_LOADING, SHOW_DELETE_ERROR, TO_DISMISS_AFTER_DELETION }

enum UpdateDisplayState { NOT_INIT, SHOW_SUCCESS, SHOW_LOADING, SHOW_UPDATE_ERROR, TO_DISMISS_AFTER_UPDATE }

class UserActionDetailsViewModel extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final bool withSubtitle;
  final UserActionStatus status;
  final CardPilluleType? pillule;
  final String category;
  final String date;
  final bool withFinishedButton;
  final bool withUnfinishedButton;
  final String creationDetails;
  final bool withComments;
  final bool withDeleteOption;
  final bool withOfflineBehavior;
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
    required this.category,
    required this.date,
    required this.withFinishedButton,
    required this.withUnfinishedButton,
    required this.creationDetails,
    required this.withComments,
    required this.withDeleteOption,
    required this.withOfflineBehavior,
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
      pillule: _pilluleViewModel(userAction),
      category: _category(userAction),
      date: _date(userAction),
      withFinishedButton: _withFinishedButton(userAction),
      withUnfinishedButton: _withUnfinishedButton(userAction),
      creationDetails: _creationDetails(userAction),
      withComments: hasComments,
      withDeleteOption: _withDeleteOption(userAction, hasComments),
      withOfflineBehavior: store.state.connectivityState.isOffline(),
      onDelete: (actionId) => store.dispatch(UserActionDeleteRequestAction(actionId)),
      resetUpdateStatus: () => store.dispatch(UserActionUpdateResetAction()),
      updateStatus: (status) => store.dispatch(UserActionUpdateRequestAction(
          actionId: userActionId,
          request: UserActionUpdateRequest(
            status: status,
            contenu: userAction?.content ?? '',
            description: userAction?.comment,
            dateEcheance: userAction?.dateEcheance ?? DateTime.now(),
            type: userAction?.type ?? UserActionReferentielType.emploi,
          ))),
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
        category,
        date,
        withFinishedButton,
        withUnfinishedButton,
        creationDetails,
        withDeleteOption,
        updateDisplayState,
        deleteDisplayState,
        withOfflineBehavior,
      ];
}

bool _withFinishedButton(UserAction? userAction) {
  if (userAction?.qualificationStatus == UserActionQualificationStatus.QUALIFIEE) {
    return false;
  }
  return userAction?.status != UserActionStatus.DONE;
}

bool _withUnfinishedButton(UserAction? userAction) {
  if (userAction?.qualificationStatus == UserActionQualificationStatus.QUALIFIEE) {
    return false;
  }
  return userAction?.status == UserActionStatus.DONE;
}

String _category(UserAction? action) => action?.type?.label ?? Strings.userActionNoCategory;

String _date(UserAction? action) => action?.dateEcheance.toDay() ?? '';

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
    if (state.request.status == UserActionStatus.DONE) {
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

CardPilluleType? _pilluleViewModel(UserAction? action) {
  if (action?.isLate() == true) {
    return CardPilluleType.late;
  }

  if (action?.status == UserActionStatus.DONE) {
    return CardPilluleType.done;
  } else {
    return CardPilluleType.doing;
  }
}

String _creationDetails(UserAction? action) {
  if (action == null) return '';
  final creationDate = action.creationDate.toDay();
  final creatorName =
      action.creator is ConseillerActionCreator ? Strings.yourConseillerLowercase : Strings.youLowercase;
  return Strings.actionCreationInfos(creatorName, creationDate);
}
