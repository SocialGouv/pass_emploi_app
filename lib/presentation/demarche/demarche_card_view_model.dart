import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_tag_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class DemarcheCardViewModel extends Equatable {
  final String id;
  final String titre;
  final String? sousTitre;
  final DemarcheStatus status;
  final bool createdByAdvisor;
  final bool modifiedByAdvisor;
  final UserActionTagViewModel? tag;
  final List<FormattedText> dateFormattedTexts;
  final Color dateColor;
  final bool isDetailEnabled;

  DemarcheCardViewModel({
    required this.id,
    required this.titre,
    required this.sousTitre,
    required this.status,
    required this.createdByAdvisor,
    required this.modifiedByAdvisor,
    required this.tag,
    required this.dateFormattedTexts,
    required this.dateColor,
    required this.isDetailEnabled,
  });

  factory DemarcheCardViewModel.create(Demarche demarche, bool isFonctionnalitesAvanceesJreActivees) {
    final isLate = _isLate(demarche.status, demarche.endDate);
    return DemarcheCardViewModel(
      id: demarche.id,
      titre: demarche.content ?? Strings.withoutContent,
      sousTitre: _description(demarche),
      status: demarche.status,
      createdByAdvisor: demarche.createdByAdvisor,
      modifiedByAdvisor: demarche.modifiedByAdvisor,
      tag: _userActionTagViewModel(demarche.status, isLate),
      dateFormattedTexts: _dateFormattedTexts(demarche.status, demarche.endDate, demarche.deletionDate),
      dateColor: _getDateColor(demarche.status, isLate),
      isDetailEnabled: isFonctionnalitesAvanceesJreActivees,
    );
  }

  @override
  List<Object?> get props =>
      [
        id,
        titre,
        sousTitre,
        status,
        dateFormattedTexts,
        createdByAdvisor,
        dateColor,
        tag,
      ];
}

Color _getDateColor(DemarcheStatus status, bool isLate) {
  switch (status) {
    case DemarcheStatus.NOT_STARTED:
    case DemarcheStatus.IN_PROGRESS:
      return isLate ? AppColors.warning : AppColors.primary;
    case DemarcheStatus.CANCELLED:
    case DemarcheStatus.DONE:
      return AppColors.grey700;
  }
}

String? _description(Demarche demarche) {
  return demarche.attributs.firstWhereOrNull((e) => e.key == 'description')?.value;
}

List<FormattedText> _dateFormattedTexts(DemarcheStatus status, DateTime? endDate, DateTime? deletionDate) {
  return [
    if (_isLate(status, endDate)) FormattedText(Strings.late, bold: true),
    FormattedText(_formattedDate(status, endDate, deletionDate)),
  ];
}

String _formattedDate(DemarcheStatus status, DateTime? endDate, DateTime? deletionDate) {
  if (status == DemarcheStatus.CANCELLED) {
    return (deletionDate != null) ? Strings.demarcheCancelledDateFormat(deletionDate.toDay()) : Strings.withoutDate;
  } else if (status == DemarcheStatus.DONE) {
    return (endDate != null) ? Strings.demarcheDoneDateFormat(endDate.toDay()) : Strings.withoutDate;
  } else {
    return (endDate != null) ? Strings.demarcheActiveDateFormat(endDate.toDay()) : Strings.withoutDate;
  }
}

UserActionTagViewModel? _userActionTagViewModel(DemarcheStatus status, bool isLate) {
  switch (status) {
    case DemarcheStatus.NOT_STARTED:
      return UserActionTagViewModel(
        title: Strings.demarcheToDo,
        backgroundColor: isLate ? AppColors.warningLighten : AppColors.accent1Lighten,
        textColor: isLate ? AppColors.warning : AppColors.accent1,
      );
    case DemarcheStatus.IN_PROGRESS:
      return UserActionTagViewModel(
        title: Strings.demarcheInProgress,
        backgroundColor: isLate ? AppColors.warningLighten : AppColors.accent3Lighten,
        textColor: isLate ? AppColors.warning : AppColors.accent3,
      );
    case DemarcheStatus.DONE:
      return UserActionTagViewModel(
        title: Strings.demarcheDone,
        backgroundColor: AppColors.accent2Lighten,
        textColor: AppColors.accent2,
      );
    case DemarcheStatus.CANCELLED:
      return UserActionTagViewModel(
        title: Strings.demarcheCancelled,
        backgroundColor: AppColors.accent2Lighten,
        textColor: AppColors.accent2,
      );
  }
}

bool _isLate(DemarcheStatus status, DateTime? endDate) {
  if (endDate != null && (status == DemarcheStatus.NOT_STARTED || status == DemarcheStatus.IN_PROGRESS)) {
    return endDate.isBefore(DateTime.now()) && (endDate.numberOfDaysUntilToday() > 0);
  }
  return false;
}
