import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_state_source.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_view_model_helper.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_tag_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

class DemarcheCardViewModel extends Equatable {
  final String id;
  final String titre;
  final String? sousTitre;
  final DemarcheStatus status;
  final bool createdByAdvisor;
  final bool modifiedByAdvisor;
  final UserActionTagViewModel? tag;
  final List<FormattedText>? dateFormattedTexts;
  final Color dateColor;

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
  });

  factory DemarcheCardViewModel.create({
    required Store<AppState> store,
    required DemarcheStateSource stateSource,
    required String demarcheId,
    required bool simpleCard,
  }) {
    final demarche = getDemarche(store, stateSource, demarcheId);
    final isLate = _isLate(demarche);
    return DemarcheCardViewModel(
      id: demarche.id,
      titre: demarche.content ?? Strings.withoutContent,
      sousTitre: simpleCard ? null : _description(demarche),
      status: demarche.status,
      createdByAdvisor: demarche.createdByAdvisor,
      modifiedByAdvisor: demarche.modifiedByAdvisor,
      tag: _userActionTagViewModel(demarche, isLate),
      dateFormattedTexts: simpleCard ? null : _dateFormattedTexts(demarche, isLate),
      dateColor: _getDateColor(demarche, isLate),
    );
  }

  @override
  List<Object?> get props => [
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

Color _getDateColor(Demarche demarche, bool isLate) {
  switch (demarche.status) {
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

List<FormattedText> _dateFormattedTexts(Demarche demarche, bool isLate) {
  final String formattedDate;
  if (demarche.status == DemarcheStatus.CANCELLED && demarche.deletionDate != null) {
    formattedDate = Strings.demarcheCancelledDateFormat(demarche.deletionDate!.toDay());
  } else if (demarche.status == DemarcheStatus.DONE && demarche.endDate != null) {
    formattedDate = Strings.demarcheDoneDateFormat(demarche.endDate!.toDay());
  } else if (demarche.endDate != null) {
    formattedDate = Strings.demarcheActiveDateFormat(demarche.endDate!.toDay());
  } else {
    formattedDate = Strings.withoutDate;
  }
  return [
    if (isLate) FormattedText(Strings.late, bold: true),
    FormattedText(formattedDate),
  ];
}

UserActionTagViewModel? _userActionTagViewModel(Demarche demarche, bool isLate) {
  switch (demarche.status) {
    case DemarcheStatus.NOT_STARTED:
      return UserActionTagViewModel(
        title: Strings.todoPillule,
        backgroundColor: isLate ? AppColors.warningLighten : AppColors.accent1Lighten,
        textColor: isLate ? AppColors.warning : AppColors.accent1,
      );
    case DemarcheStatus.IN_PROGRESS:
      return UserActionTagViewModel(
        title: Strings.doingPillule,
        backgroundColor: isLate ? AppColors.warningLighten : AppColors.accent3Lighten,
        textColor: isLate ? AppColors.warning : AppColors.accent3,
      );
    case DemarcheStatus.DONE:
      return UserActionTagViewModel(
        title: Strings.donePillule,
        backgroundColor: AppColors.accent2Lighten,
        textColor: AppColors.accent2,
      );
    case DemarcheStatus.CANCELLED:
      return UserActionTagViewModel(
        title: Strings.canceledPillule,
        backgroundColor: AppColors.accent2Lighten,
        textColor: AppColors.accent2,
      );
  }
}

bool _isLate(Demarche demarche) {
  if (demarche.endDate != null &&
      (demarche.status == DemarcheStatus.NOT_STARTED || demarche.status == DemarcheStatus.IN_PROGRESS)) {
    return demarche.endDate!.isBefore(DateTime.now()) && (demarche.endDate!.numberOfDaysUntilToday() > 0);
  }
  return false;
}
