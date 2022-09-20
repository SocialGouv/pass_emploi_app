import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_tag_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

class UserActionDateEcheanceViewModel extends Equatable {
  final List<FormattedText> formattedTexts;
  final Color color;

  UserActionDateEcheanceViewModel({required this.formattedTexts, required this.color});

  @override
  List<Object?> get props => [formattedTexts, color];
}

class UserActionCardViewModel extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final bool withSubtitle;
  final UserActionDateEcheanceViewModel? dateEcheanceViewModel;
  final UserActionTagViewModel? tag;

  UserActionCardViewModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.withSubtitle,
    required this.dateEcheanceViewModel,
    required this.tag,
  });

  factory UserActionCardViewModel.create({
    required Store<AppState> store,
    required UserActionStateSource stateSource,
    required String actionId,
    required bool simpleCard,
  }) {
    final action = _getAction(store, stateSource, actionId);
    return UserActionCardViewModel(
      id: action.id,
      title: action.content,
      subtitle: action.comment,
      withSubtitle: simpleCard ? false : action.comment.isNotEmpty,
      dateEcheanceViewModel: simpleCard ? null : _dateEcheanceViewModel(action, action.isLate()),
      tag: _userActionTagViewModel(action.status),
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        withSubtitle,
        tag,
      ];
}

UserAction _getAction(Store<AppState> store, UserActionStateSource stateSource, String actionId) {
  switch (stateSource) {
    case UserActionStateSource.agenda:
      return _getFromAgendaState(store, actionId);
    case UserActionStateSource.list:
      return _getFromUserActionState(store, actionId);
  }
}

UserAction _getFromAgendaState(Store<AppState> store, String actionId) {
  final state = store.state.agendaState;
  if (state is! AgendaSuccessState) throw Exception('Invalid state.');
  final action = state.agenda.actions.where((e) => e.id == actionId).firstOrNull;
  if (action == null) throw Exception('No UserAction matching id $actionId');
  return action;
}

UserAction _getFromUserActionState(Store<AppState> store, String actionId) {
  final state = store.state.userActionListState;
  if (state is! UserActionListSuccessState) throw Exception('Invalid state.');
  final action = state.userActions.where((e) => e.id == actionId).firstOrNull;
  if (action == null) throw Exception('No UserAction matching id $actionId');
  return action;
}

UserActionDateEcheanceViewModel? _dateEcheanceViewModel(UserAction userAction, bool isLate) {
  if ([UserActionStatus.DONE, UserActionStatus.CANCELED].contains(userAction.status)) return null;
  return UserActionDateEcheanceViewModel(
    formattedTexts: _dateEcheanceFormattedTexts(userAction, isLate),
    color: isLate ? AppColors.warning : AppColors.primary,
  );
}

List<FormattedText> _dateEcheanceFormattedTexts(UserAction userAction, bool isLate) {
  return [
    if (isLate) FormattedText(Strings.late, bold: true),
    FormattedText(Strings.dateEcheanceFormat(userAction.dateEcheance.toDayOfWeekWithFullMonth())),
  ];
}

UserActionTagViewModel? _userActionTagViewModel(UserActionStatus status) {
  switch (status) {
    case UserActionStatus.NOT_STARTED:
      return UserActionTagViewModel(
        title: Strings.actionToDo,
        backgroundColor: AppColors.accent1Lighten,
        textColor: AppColors.accent1,
      );
    case UserActionStatus.IN_PROGRESS:
      return UserActionTagViewModel(
        title: Strings.actionInProgress,
        backgroundColor: AppColors.accent3Lighten,
        textColor: AppColors.accent3,
      );
    case UserActionStatus.CANCELED:
      return UserActionTagViewModel(
        title: Strings.actionCanceled,
        backgroundColor: AppColors.accent2Lighten,
        textColor: AppColors.accent2,
      );
    case UserActionStatus.DONE:
      return UserActionTagViewModel(
        title: Strings.actionDone,
        backgroundColor: AppColors.accent2Lighten,
        textColor: AppColors.accent2,
      );
  }
}
