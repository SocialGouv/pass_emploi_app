import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/user_action/commentaire/list/action_commentaire_list_state.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_actions.dart';
import 'package:pass_emploi_app/features/user_action/delete/user_action_delete_state.dart';
import 'package:pass_emploi_app/features/user_action/details/user_action_details_actions.dart';
import 'package:pass_emploi_app/features/user_action/details/user_action_details_state.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_actions.dart';
import 'package:pass_emploi_app/features/user_action/update/user_action_update_state.dart';
import 'package:pass_emploi_app/models/requests/user_action_update_request.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/pages/user_action/create/create_user_action_form_step1.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_store_extension.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_view_model_helper.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_pillule.dart';
import 'package:redux/redux.dart';

enum DeleteDisplayState { NOT_INIT, SHOW_LOADING, SHOW_DELETE_ERROR, TO_DISMISS_AFTER_DELETION }

enum UpdateDisplayState { NOT_INIT, SHOW_SUCCESS, SHOW_LOADING, SHOW_UPDATE_ERROR, TO_DISMISS_AFTER_UPDATE }

class UserActionDetailsViewModel extends Equatable {
  final DisplayState displayState;
  final String id;
  final String title;
  final String subtitle;
  final bool withSubtitle;
  final UserActionStatus status;
  final CardPilluleType pillule;
  final String category;
  final String date;
  final bool withFinishedButton;
  final bool withUnfinishedButton;
  final bool withUpdateButton;
  final bool withDescriptionConfirmationPopup;
  final String creationDetails;
  final bool withComments;
  final bool withOfflineBehavior;
  final Function(String actionId) onDelete;
  final Function() resetUpdateStatus;
  final Function(UserActionStatus) updateStatus;
  final Function() onRetry;
  final UpdateDisplayState updateDisplayState;
  final DeleteDisplayState deleteDisplayState;

  UserActionDetailsViewModel._({
    required this.displayState,
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
    required this.withUpdateButton,
    required this.withDescriptionConfirmationPopup,
    required this.creationDetails,
    required this.withComments,
    required this.withOfflineBehavior,
    required this.onDelete,
    required this.resetUpdateStatus,
    required this.updateStatus,
    required this.onRetry,
    required this.updateDisplayState,
    required this.deleteDisplayState,
  });

  factory UserActionDetailsViewModel.create(Store<AppState> store, UserActionStateSource source, String userActionId) {
    final userAction = store.getAction(source, userActionId);
    final updateState = store.state.userActionUpdateState;
    final deleteState = store.state.userActionDeleteState;

    if (userAction == null) {
      return UserActionDetailsViewModel.empty(
        store,
        source,
        userActionId,
        updateState,
        deleteState,
      );
    }

    final commentsState = store.state.actionCommentaireListState;
    final hasComments = commentsState is ActionCommentaireListSuccessState ? commentsState.comments.isNotEmpty : false;
    return UserActionDetailsViewModel._(
      displayState: DisplayState.CONTENT,
      id: userAction.id,
      title: userAction.content,
      subtitle: userAction.comment,
      withSubtitle: userAction.comment.isNotEmpty,
      status: userAction.status,
      pillule: userAction.pillule(),
      category: _category(userAction),
      date: _date(userAction),
      withFinishedButton: _withFinishedButton(userAction),
      withUnfinishedButton: _withUnfinishedButton(userAction),
      withUpdateButton: _withUpdateButton(userAction),
      withDescriptionConfirmationPopup: userAction.comment.isEmpty,
      creationDetails: _creationDetails(userAction),
      withComments: hasComments,
      withOfflineBehavior: store.state.connectivityState.isOffline(),
      onDelete: (actionId) => store.dispatch(UserActionDeleteRequestAction(actionId)),
      onRetry: () => {},
      resetUpdateStatus: () => store.dispatch(UserActionUpdateResetAction()),
      updateStatus: (status) => store.dispatch(
        UserActionUpdateRequestAction(
          actionId: userActionId,
          request: UserActionUpdateRequest(
            status: status,
            contenu: userAction.content,
            description: userAction.comment,
            dateEcheance: userAction.dateEcheance,
            type: userAction.type,
          ),
        ),
      ),
      updateDisplayState: _updateStateDisplayState(updateState),
      deleteDisplayState: _deleteStateDisplayState(deleteState),
    );
  }

  factory UserActionDetailsViewModel.empty(
    Store<AppState> store,
    UserActionStateSource source,
    String userActionId,
    UserActionUpdateState updateState,
    UserActionDeleteState deleteState,
  ) {
    return UserActionDetailsViewModel._(
      displayState: _displayStateForEmptyViewModel(store, source),
      id: '',
      title: '',
      subtitle: '',
      withSubtitle: false,
      status: UserActionStatus.DONE,
      pillule: CardPilluleType.done,
      category: '',
      date: '',
      withFinishedButton: false,
      withUnfinishedButton: false,
      withUpdateButton: false,
      withDescriptionConfirmationPopup: false,
      creationDetails: '',
      withComments: false,
      withOfflineBehavior: false,
      onDelete: (actionId) {},
      onRetry: () => store.dispatch(UserActionDetailsRequestAction(userActionId)),
      resetUpdateStatus: () {},
      updateStatus: (status) {},
      updateDisplayState: _updateStateDisplayState(updateState),
      deleteDisplayState: _deleteStateDisplayState(deleteState),
    );
  }

  @override
  List<Object?> get props => [
        displayState,
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
        withUpdateButton,
        withDescriptionConfirmationPopup,
        creationDetails,
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

bool _withUpdateButton(UserAction? userAction) {
  return userAction?.qualificationStatus != UserActionQualificationStatus.QUALIFIEE;
}

String _category(UserAction? action) => action?.type?.label ?? Strings.userActionNoCategory;

String _date(UserAction? action) => action?.dateEcheance.toDayWithFullMonth() ?? '';

DeleteDisplayState _deleteStateDisplayState(UserActionDeleteState state) {
  return switch (state) {
    UserActionDeleteNotInitializedState() => DeleteDisplayState.NOT_INIT,
    UserActionDeleteLoadingState() => DeleteDisplayState.SHOW_LOADING,
    UserActionDeleteSuccessState() => DeleteDisplayState.TO_DISMISS_AFTER_DELETION,
    UserActionDeleteFailureState() => DeleteDisplayState.SHOW_DELETE_ERROR,
  };
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

String _creationDetails(UserAction? action) {
  if (action == null) return '';
  final creationDate = action.creationDate.toDay();
  final creatorName =
      action.creator is ConseillerActionCreator ? Strings.yourConseillerLowercase : Strings.youLowercase;
  return Strings.actionCreationInfos(creatorName, creationDate);
}

DisplayState _displayStateForEmptyViewModel(Store<AppState> store, UserActionStateSource source) {
  if (source == UserActionStateSource.noSource) {
    return switch (store.state.userActionDetailsState) {
      UserActionDetailsFailureState() => DisplayState.FAILURE,
      _ => DisplayState.LOADING,
    };
  }
  return DisplayState.LOADING;
}
