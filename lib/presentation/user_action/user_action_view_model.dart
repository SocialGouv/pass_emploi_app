import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_tag_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class UserActionViewModel extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final bool withSubtitle;
  final UserActionStatus status;
  final String lastUpdate;
  final List<FormattedText> dateEcheanceFormattedTexts;
  final Color dateEcheanceColor;
  final String creator;
  final UserActionTagViewModel? tag;
  final bool withDeleteOption;

  UserActionViewModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.withSubtitle,
    required this.status,
    required this.lastUpdate,
    required this.dateEcheanceFormattedTexts,
    required this.dateEcheanceColor,
    required this.creator,
    required this.tag,
    required this.withDeleteOption,
  });

  factory UserActionViewModel.create(UserAction userAction) {
    final isLate = userAction.isLate();
    return UserActionViewModel(
      id: userAction.id,
      title: userAction.content,
      subtitle: userAction.comment,
      withSubtitle: userAction.comment.isNotEmpty,
      status: userAction.status,
      lastUpdate: Strings.lastUpdateFormat(userAction.lastUpdate.toDay()),
      dateEcheanceFormattedTexts: _dateEcheanceFormattedTexts(userAction, isLate),
      dateEcheanceColor: isLate ? AppColors.warning : AppColors.primary,
      creator: _displayName(userAction.creator),
      tag: _userActionTagViewModel(userAction.status),
      withDeleteOption: userAction.creator is! ConseillerActionCreator,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        withSubtitle,
        status,
        lastUpdate,
        dateEcheanceFormattedTexts,
        dateEcheanceColor,
        creator,
        tag,
        withDeleteOption,
      ];
}

String _displayName(UserActionCreator creator) => creator is ConseillerActionCreator ? creator.name : Strings.you;

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
