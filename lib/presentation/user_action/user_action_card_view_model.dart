import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_store_extension.dart';
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
    final action = store.getAction(stateSource, actionId);
    if (action == null) throw Exception('No UserAction matching id $actionId');

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
  List<Object?> get props => [id, title, subtitle, withSubtitle, pillule, isLate, dateEcheance];
}

bool _isLate(UserAction action) {
  if ((action.status == UserActionStatus.NOT_STARTED || action.status == UserActionStatus.IN_PROGRESS)) {
    return action.isLate();
  }
  return false;
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
