import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class UserActionPEViewModel extends Equatable {
  final String id;
  final String title;
  final DemarcheStatus status;
  final bool createdByAdvisor;
  final bool modifiedByAdvisor;
  final UserActionTagViewModel? tag;
  final String formattedDate;
  final bool isLate;
  final bool isDetailEnabled;

  UserActionPEViewModel({
    required this.id,
    required this.title,
    required this.status,
    required this.createdByAdvisor,
    required this.modifiedByAdvisor,
    required this.tag,
    required this.formattedDate,
    required this.isLate,
    required this.isDetailEnabled,
  });

  factory UserActionPEViewModel.create(Demarche userAction, bool isDetailAvailable) {
    return UserActionPEViewModel(
      id: userAction.id,
      title: userAction.content ?? Strings.withoutContent,
      status: userAction.status,
      createdByAdvisor: userAction.createdByAdvisor,
      modifiedByAdvisor: userAction.modifiedByAdvisor,
      tag: _userActionTagViewModel(userAction.status, isLateAction(userAction.status, userAction.endDate)),
      formattedDate: _setFormattedDate(userAction.status, userAction.endDate?.toDay(), userAction.deletionDate?.toDay()),
      isLate: isLateAction(userAction.status, userAction.endDate),
      isDetailEnabled: isDetailAvailable,
    );
  }

  Color getDateColor() {
    switch (status) {
      case DemarcheStatus.NOT_STARTED:
        return isLate ? AppColors.warning : AppColors.primary;
      case DemarcheStatus.IN_PROGRESS:
        return isLate ? AppColors.warning : AppColors.primary;
      case DemarcheStatus.CANCELLED:
        return AppColors.grey700;
      case DemarcheStatus.DONE:
        return AppColors.grey700;
    }
  }

  @override
  List<Object?> get props => [id, title, status, formattedDate, createdByAdvisor, tag];
}

String _setFormattedDate(DemarcheStatus status, String? endDate, String? deletionDate) {
  if (status == DemarcheStatus.CANCELLED) {
    return (deletionDate != null && deletionDate.isNotEmpty) ? _getDateText(status, deletionDate) : Strings.withoutDate;
  } else {
    return (endDate != null && endDate.isNotEmpty) ? _getDateText(status, endDate) : Strings.withoutDate;
  }
}

String _getDateText(DemarcheStatus status, String date) {
  switch (status) {
    case DemarcheStatus.DONE:
      return Strings.actionPEDoneDateFormat(date);
    case DemarcheStatus.CANCELLED:
      return Strings.actionPECancelledDateFormat(date);
    default:
      return Strings.actionPEActiveDateFormat(date);
  }
}

UserActionTagViewModel? _userActionTagViewModel(DemarcheStatus status, bool isLate) {
  switch (status) {
    case DemarcheStatus.NOT_STARTED:
      return UserActionTagViewModel(
        title: Strings.actionPEToDo,
        backgroundColor: isLate ? AppColors.warningLighten : AppColors.accent1Lighten,
        textColor: isLate ? AppColors.warning : AppColors.accent1,
      );
    case DemarcheStatus.IN_PROGRESS:
      return UserActionTagViewModel(
        title: Strings.actionPEInProgress,
        backgroundColor: isLate ? AppColors.warningLighten : AppColors.accent3Lighten,
        textColor: isLate ? AppColors.warning : AppColors.accent3,
      );
    case DemarcheStatus.DONE:
      return UserActionTagViewModel(
        title: Strings.actionPEDone,
        backgroundColor: AppColors.accent2Lighten,
        textColor: AppColors.accent2,
      );
    case DemarcheStatus.CANCELLED:
      return UserActionTagViewModel(
        title: Strings.actionPECancelled,
        backgroundColor: AppColors.accent2Lighten,
        textColor: AppColors.accent2,
      );
  }
}

bool isLateAction(DemarcheStatus status, DateTime? endDate) {
  if (endDate != null && (status == DemarcheStatus.NOT_STARTED || status == DemarcheStatus.IN_PROGRESS)) {
    return endDate.isBefore(DateTime.now()) && (endDate.numberOfDaysUntilToday() > 0);
  }
  return false;
}
