import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_creator.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';

class UserActionViewModel {
  final String id;
  final String content;
  final String comment;
  final bool withComment;
  final UserActionStatus status;
  final DateTime lastUpdate;
  final String creator;
  final UserActionTagViewModel? tag;
  final bool withDeleteOption;

  UserActionViewModel({
    required this.id,
    required this.content,
    required this.comment,
    required this.withComment,
    required this.status,
    required this.lastUpdate,
    required this.creator,
    required this.tag,
    required this.withDeleteOption,
  });

  factory UserActionViewModel.create(UserAction userAction) {
    return UserActionViewModel(
      id: userAction.id,
      content: userAction.content,
      comment: userAction.comment,
      withComment: userAction.comment.isNotEmpty,
      status: userAction.status,
      lastUpdate: userAction.lastUpdate,
      creator: _displayName(userAction.creator),
      tag: _userActionTagViewModel(userAction),
      withDeleteOption: userAction.creator is! ConseillerActionCreator,
    );
  }
}

_displayName(UserActionCreator creator) {
  if (creator is ConseillerActionCreator) {
    return creator.name;
  } else {
    return Strings.you;
  }
}

UserActionTagViewModel? _userActionTagViewModel(userAction) {
  switch (userAction.status) {
    case UserActionStatus.DONE:
      return UserActionTagViewModel(
        title: Strings.actionDone,
        backgroundColor: AppColors.blueGrey,
        textColor: AppColors.nightBlue,
      );
    case UserActionStatus.IN_PROGRESS:
      return UserActionTagViewModel(
        title: Strings.actionInProgress,
        backgroundColor: AppColors.purple,
        textColor: Colors.white,
      );
    case UserActionStatus.NOT_STARTED:
      return null;
  }
}

class UserActionTagViewModel {
  final String title;
  final Color backgroundColor;
  final Color textColor;

  UserActionTagViewModel({
    required this.title,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserActionTagViewModel &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          backgroundColor == other.backgroundColor &&
          textColor == other.textColor;

  @override
  int get hashCode => title.hashCode ^ backgroundColor.hashCode ^ textColor.hashCode;
}
