import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/user_action/list/user_action_list_state.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_pillule.dart';
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
  final String? dateEcheance;
  final bool isLate;
  final CardPilluleType? pillule;

  UserActionCardViewModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.withSubtitle,
    required this.dateEcheance,
    required this.isLate,
    required this.pillule,
  });

  factory UserActionCardViewModel.create({
    required Store<AppState> store,
    required UserActionStateSource stateSource,
    required String actionId,
  }) {
    final action = _getAction(store, stateSource, actionId);
    return UserActionCardViewModel(
      id: action.id,
      title: action.content,
      subtitle: action.comment,
      withSubtitle: action.comment.isNotEmpty,
      dateEcheance: _dateEcheanceFormattedTexts(action, action.isLate()),
      isLate: action.isLate(),
      pillule: _userActionTagViewModel(action.status, _isLate(action)),
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        withSubtitle,
        pillule,
      ];
}

bool _isLate(UserAction action) {
  if ((action.status == UserActionStatus.NOT_STARTED || action.status == UserActionStatus.IN_PROGRESS)) {
    return action.isLate();
  }
  return false;
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

String? _dateEcheanceFormattedTexts(UserAction userAction, bool isLate) {
  if (userAction.status == UserActionStatus.DONE || userAction.status == UserActionStatus.CANCELED) return null;
  return userAction.dateEcheance.toDay();
}

CardPilluleType? _userActionTagViewModel(UserActionStatus status, bool isLate) {
  if (isLate) {
    return CardPilluleType.late;
  }
  return switch (status) {
    UserActionStatus.DONE => CardPilluleType.done,
    _ => CardPilluleType.todo,
  };
}
