import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/user_action_pe.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class UserActionPEViewModel extends Equatable {
  final String id;
  final String title;
  final UserActionPEStatus status;
  final bool createdByAdvisor;
  final bool modifiedByAdvisor;
  final UserActionTagViewModel? tag;
  final String formattedDate;
  final bool isLate;
  final bool isDetailEnabled;
  final String? label;
  final String? titreDetail;
  final String? sousTitre;
  final String? modificationDate;
  final String? creationDate;
  final List<String> attributs;
  final List<UserActionTagViewModel> statutsPossibles;

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
    required this.label,
    required this.titreDetail,
    required this.sousTitre,
    required this.attributs,
    required this.statutsPossibles,
    required this.modificationDate,
    required this.creationDate,
  });

  factory UserActionPEViewModel.create(
      UserActionPE userAction, bool isDetailAvailable) {
    return UserActionPEViewModel(
      id: userAction.id,
      title: userAction.content ?? Strings.withoutContent,
      status: userAction.status,
      createdByAdvisor: userAction.createdByAdvisor,
      modifiedByAdvisor: userAction.modifiedByAdvisor,
      tag: _userActionTagViewModel(userAction.status,
          _isLateAction(userAction.status, userAction.endDate)),
      formattedDate: _setFormattedDate(userAction.status,
          userAction.endDate?.toDay(), userAction.deletionDate?.toDay()),
      isLate: _isLateAction(userAction.status, userAction.endDate),
      isDetailEnabled: isDetailAvailable,
      label: userAction.label,
      titreDetail: userAction.titre,
      sousTitre: userAction.sousTitre,
      attributs: userAction.attributs.map((e) => e.valeur).toList(),
      statutsPossibles: userAction.possibleStatus
          .map((e) => _getTagViewModel(e, userAction.status))
          .toList(),
      modificationDate: userAction.modificationDate?.toDay(),
      creationDate: userAction.creationDate?.toDay(),
    );
  }

  Color getDateColor() {
    switch (status) {
      case UserActionPEStatus.NOT_STARTED:
        return isLate ? AppColors.warning : AppColors.primary;
      case UserActionPEStatus.IN_PROGRESS:
        return isLate ? AppColors.warning : AppColors.primary;
      case UserActionPEStatus.RETARDED:
        return AppColors.warning;
      case UserActionPEStatus.CANCELLED:
        return AppColors.grey700;
      case UserActionPEStatus.DONE:
        return AppColors.grey700;
    }
  }

  @override
  List<Object?> get props => [id, title, status, formattedDate, createdByAdvisor, tag];
}

String _setFormattedDate(UserActionPEStatus status, String? endDate, String? deletionDate) {
  if (status == UserActionPEStatus.CANCELLED) {
    return (deletionDate != null && deletionDate.isNotEmpty) ? _getDateText(status, deletionDate) : Strings.withoutDate;
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

UserActionTagViewModel? _userActionTagViewModel(UserActionPEStatus status, bool isLate) {
  switch (status) {
    case UserActionPEStatus.NOT_STARTED:
      return UserActionTagViewModel(
        title: Strings.actionPEToDo,
        backgroundColor: isLate ? AppColors.warningLighten : AppColors.accent1Lighten,
        textColor: isLate ? AppColors.warning : AppColors.accent1,
      );
    case UserActionPEStatus.IN_PROGRESS:
      return UserActionTagViewModel(
        title: Strings.actionPEInProgress,
        backgroundColor: isLate ? AppColors.warningLighten : AppColors.accent3Lighten,
        textColor: isLate ? AppColors.warning : AppColors.accent3,
      );
    case UserActionPEStatus.RETARDED:
      return UserActionTagViewModel(
        title: Strings.actionPERetarded,
        backgroundColor: AppColors.warningLighten,
        textColor: AppColors.warning,
      );
    case UserActionPEStatus.DONE:
      return UserActionTagViewModel(
        title: Strings.actionPEDone,
        backgroundColor: AppColors.accent2Lighten,
        textColor: AppColors.accent2,
      );
    case UserActionPEStatus.CANCELLED:
      return UserActionTagViewModel(
        title: Strings.actionPECancelled,
        backgroundColor: AppColors.accent2Lighten,
        textColor: AppColors.accent2,
      );
  }
}

bool _isLateAction(UserActionPEStatus status, DateTime? endDate) {
  if (endDate != null &&
      (status == UserActionPEStatus.NOT_STARTED ||
          status == UserActionPEStatus.IN_PROGRESS)) {
    return endDate.isBefore(DateTime.now()) &&
        (endDate.numberOfDaysUntilToday() > 0);
  }
  return false;
}

UserActionTagViewModel _getTagViewModel(
    UserActionPEStatus status, UserActionPEStatus currentStatus) {
  final bool isSelected = status == currentStatus;
  switch (status) {
    case UserActionPEStatus.NOT_STARTED:
      return UserActionTagViewModel(
        title: Strings.actionPEToDo,
        backgroundColor:
            isSelected ? AppColors.accent1Lighten : Colors.transparent,
        textColor: isSelected ? AppColors.accent1 : AppColors.grey800,
        isSelected: isSelected,
      );
    case UserActionPEStatus.IN_PROGRESS:
      return UserActionTagViewModel(
        title: Strings.actionPEInProgress,
        backgroundColor:
            isSelected ? AppColors.accent3Lighten : Colors.transparent,
        textColor: isSelected ? AppColors.accent3 : AppColors.grey800,
        isSelected: isSelected,
      );
    case UserActionPEStatus.RETARDED:
      return UserActionTagViewModel(
        title: Strings.actionPERetarded,
        backgroundColor:
            isSelected ? AppColors.warningLighten : Colors.transparent,
        textColor: isSelected ? AppColors.warning : AppColors.grey800,
        isSelected: isSelected,
      );
    case UserActionPEStatus.DONE:
      return UserActionTagViewModel(
        title: Strings.actionPEDone,
        backgroundColor:
            isSelected ? AppColors.accent2Lighten : Colors.transparent,
        textColor: isSelected ? AppColors.accent2 : AppColors.grey800,
        isSelected: isSelected,
      );
    case UserActionPEStatus.CANCELLED:
      return UserActionTagViewModel(
        title: Strings.actionPECancelled,
        backgroundColor:
            isSelected ? AppColors.accent2Lighten : Colors.transparent,
        textColor: isSelected ? AppColors.accent2 : AppColors.grey800,
        isSelected: isSelected,
      );
  }
}
