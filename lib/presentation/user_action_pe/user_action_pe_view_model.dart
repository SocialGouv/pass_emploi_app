import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/user_action_pe.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class UserActionPEViewModel extends Equatable {
  final String id;
  final String title;
  final UserActionPEStatus status;
  final bool createdByAdvisor;
  final UserActionPETagViewModel? tag;
  final String formattedDate;

  UserActionPEViewModel({
    required this.id,
    required this.title,
    required this.status,
    required this.createdByAdvisor,
    required this.tag,
    required this.formattedDate,
  });

  factory UserActionPEViewModel.create(UserActionPE userAction) {
    return UserActionPEViewModel(
      id: userAction.id,
      title: userAction.content ?? Strings.withoutContent,
      status: userAction.status,
      createdByAdvisor: userAction.createdByAdvisor,
      tag: _userActionPETagViewModel(userAction.status),
      formattedDate:
          _setFormattedDate(userAction.status, userAction.endDate?.toDay(), userAction.deletionDate?.toDay()),
    );
  }

  Color getDateColor() {
    switch (status) {
      case UserActionPEStatus.RETARDED:
        return AppColors.warning;
      case UserActionPEStatus.CANCELLED:
        return AppColors.grey700;
      case UserActionPEStatus.DONE:
        return AppColors.grey700;
      default:
        return AppColors.primary;
    }
  }

  @override
  List<Object?> get props => [id, title, status, formattedDate, createdByAdvisor, tag];
}

String _setFormattedDate(UserActionPEStatus status, String? endDate, String? deletionDate) {
  if (status == UserActionPEStatus.CANCELLED) {
    return (deletionDate != null && deletionDate.isNotEmpty)
        ? _getDateText(status, deletionDate)
        : Strings.withoutDate;
  } else {
    return (endDate != null && endDate.isNotEmpty) ? _getDateText(status, endDate) : Strings.withoutDate;
  }
}

String _getDateText(UserActionPEStatus status, String date) {
  switch (status) {
    case UserActionPEStatus.DONE:
      return Strings.actionPEDoneDateFormat(date);
    case UserActionPEStatus.CANCELLED:
      return Strings.actionPECancelledDateFormat(date);
    default:
      return Strings.actionPEActiveDateFormat(date);
  }
}

UserActionPETagViewModel? _userActionPETagViewModel(UserActionPEStatus status) {
  switch (status) {
    case UserActionPEStatus.NOT_STARTED:
      return UserActionPETagViewModel(
        title: Strings.actionPEToDo,
        backgroundColor: AppColors.accent1Lighten,
        textColor: AppColors.accent1,
      );
    case UserActionPEStatus.IN_PROGRESS:
      return UserActionPETagViewModel(
        title: Strings.actionPEInProgress,
        backgroundColor: AppColors.accent3Lighten,
        textColor: AppColors.accent3,
      );
    case UserActionPEStatus.RETARDED:
      return UserActionPETagViewModel(
        title: Strings.actionPERetarded,
        backgroundColor: AppColors.warningLighten,
        textColor: AppColors.warning,
      );
    case UserActionPEStatus.DONE:
      return UserActionPETagViewModel(
        title: Strings.actionPEDone,
        backgroundColor: AppColors.accent2Lighten,
        textColor: AppColors.accent2,
      );
    case UserActionPEStatus.CANCELLED:
      return UserActionPETagViewModel(
        title: Strings.actionPECancelled,
        backgroundColor: AppColors.accent2Lighten,
        textColor: AppColors.accent2,
      );
  }
}

class UserActionPETagViewModel extends Equatable {
  final String title;
  final Color backgroundColor;
  final Color textColor;

  UserActionPETagViewModel({
    required this.title,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  List<Object?> get props => [title, backgroundColor, textColor];
}
