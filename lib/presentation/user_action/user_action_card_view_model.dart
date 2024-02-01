import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/pages/user_action/create/create_user_action_form_step1.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_state_source.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_store_extension.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_view_model_helper.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_pillule.dart';
import 'package:redux/redux.dart';

class UserActionCardViewModel extends Equatable {
  final String id;
  final String title;
  final String semanticLabel;
  final bool isLate;
  final IconData categoryIcon;
  final String categoryText;
  final CardPilluleType pillule;

  UserActionCardViewModel({
    required this.id,
    required this.title,
    required this.semanticLabel,
    required this.isLate,
    required this.categoryIcon,
    required this.categoryText,
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
      semanticLabel: _semanticLabel(action),
      isLate: action.status.todo() && action.isLate(),
      categoryIcon: action.type?.icon ?? AppIcons.emploi,
      categoryText: action.type?.label ?? Strings.accueilActionSingular,
      pillule: action.pillule(),
    );
  }

  @override
  List<Object?> get props => [id, title, semanticLabel, isLate, categoryText, pillule];
}

String _semanticLabel(UserAction action) {
  final prefix = action.type != null
      ? '${Strings.accueilActionSingular} ${action.type!.label}' //
      : Strings.accueilActionSingular;

  final suffix = switch (action.pillule()) {
    CardPilluleType.todo => Strings.doingPillule,
    CardPilluleType.doing => Strings.doingPillule,
    CardPilluleType.done => Strings.donePillule,
    CardPilluleType.late => Strings.latePillule,
    CardPilluleType.canceled => Strings.donePillule,
  };

  return '$prefix : ${action.content} - $suffix';
}
