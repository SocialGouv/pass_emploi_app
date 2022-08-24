import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_tag_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

class DemarcheDetailViewModel extends Equatable {
  final bool createdByAdvisor;
  final bool modifiedByAdvisor;
  final List<FormattedText> dateFormattedTexts;
  final Color dateTextColor;
  final Color dateBackgroundColor;
  final List<String> dateIcons;
  final String? label;
  final String? titreDetail;
  final String? sousTitre;
  final String? modificationDate;
  final String? creationDate;
  final List<String> attributs;
  final List<UserActionTagViewModel> statutsPossibles;
  final Function(UserActionTagViewModel) onModifyStatus;
  final Function() resetUpdateStatus;
  final DisplayState updateDisplayState;
  final bool errorOnUpdate;

  DemarcheDetailViewModel({
    required this.createdByAdvisor,
    required this.modifiedByAdvisor,
    required this.dateFormattedTexts,
    required this.dateTextColor,
    required this.dateBackgroundColor,
    required this.dateIcons,
    required this.label,
    required this.titreDetail,
    required this.sousTitre,
    required this.attributs,
    required this.statutsPossibles,
    required this.modificationDate,
    required this.creationDate,
    required this.onModifyStatus,
    required this.resetUpdateStatus,
    required this.updateDisplayState,
    required this.errorOnUpdate,
  });

  factory DemarcheDetailViewModel.create(Store<AppState> store, String id) {
    final Demarche demarche =
        (store.state.demarcheListState as DemarcheListSuccessState)
            .demarches
            .firstWhere((element) => element.id == id);
    demarche.possibleStatus.sort((a, b) => a.compareTo(b));
    final isLate = _isLate(demarche.status, demarche.endDate);
    final updateState = store.state.updateDemarcheState;
    return DemarcheDetailViewModel(
      createdByAdvisor: demarche.createdByAdvisor,
      modifiedByAdvisor: demarche.modifiedByAdvisor,
      dateFormattedTexts: _formattedDate(demarche),
      dateBackgroundColor:
          isLate ? AppColors.warningLighten : AppColors.accent3Lighten,
      dateTextColor: isLate ? AppColors.warning : AppColors.accent2,
      dateIcons: [if (isLate) Drawables.icImportantOutlined, Drawables.icClock],
      label: demarche.label,
      titreDetail: demarche.titre,
      sousTitre: demarche.sousTitre,
      attributs: demarche.attributs.map((e) => e.value).toList(),
      statutsPossibles: demarche.possibleStatus
          .map((e) => _getTagViewModel(e, demarche.status))
          .toList(),
      modificationDate: demarche.modificationDate?.toDay(),
      creationDate: demarche.creationDate?.toDay(),
      onModifyStatus: (tag) {
        final status = _getStatusFromTag(tag);
        if (!tag.isSelected && status != null) {
          store.dispatch(UpdateDemarcheRequestAction(
            demarche.id,
            demarche.endDate,
            demarche.creationDate,
            status,
          ));
        }
      },
      resetUpdateStatus: () => store.dispatch(UpdateDemarcheResetAction()),
      updateDisplayState: _updateStateDisplayState(updateState),
      errorOnUpdate: updateState is UpdateDemarcheFailureState,
    );
  }

  @override
  List<Object?> get props => [
        createdByAdvisor,
        modifiedByAdvisor,
        dateFormattedTexts,
        dateFormattedTexts,
        dateBackgroundColor,
        dateTextColor,
        label,
        titreDetail,
        sousTitre,
        modificationDate,
        creationDate,
        attributs,
        statutsPossibles,
        updateDisplayState,
        errorOnUpdate,
      ];
}

UserActionTagViewModel _getTagViewModel(
    DemarcheStatus status, DemarcheStatus currentStatus) {
  final bool isSelected = status == currentStatus;
  switch (status) {
    case DemarcheStatus.NOT_STARTED:
      return UserActionTagViewModel(
        title: Strings.demarcheToDo,
        backgroundColor:
            isSelected ? AppColors.accent1Lighten : Colors.transparent,
        textColor: isSelected ? AppColors.accent1 : AppColors.grey800,
        isSelected: isSelected,
      );
    case DemarcheStatus.IN_PROGRESS:
      return UserActionTagViewModel(
        title: Strings.demarcheInProgress,
        backgroundColor:
            isSelected ? AppColors.accent3Lighten : Colors.transparent,
        textColor: isSelected ? AppColors.accent3 : AppColors.grey800,
        isSelected: isSelected,
      );
    case DemarcheStatus.DONE:
      return UserActionTagViewModel(
        title: Strings.demarcheDone,
        backgroundColor:
            isSelected ? AppColors.accent2Lighten : Colors.transparent,
        textColor: isSelected ? AppColors.accent2 : AppColors.grey800,
        isSelected: isSelected,
      );
    case DemarcheStatus.CANCELLED:
      return UserActionTagViewModel(
        title: Strings.demarcheCancelled,
        backgroundColor:
            isSelected ? AppColors.accent2Lighten : Colors.transparent,
        textColor: isSelected ? AppColors.accent2 : AppColors.grey800,
        isSelected: isSelected,
      );
  }
}

List<FormattedText> _formattedDate(Demarche demarche) {
  if (demarche.status == DemarcheStatus.CANCELLED &&
      demarche.deletionDate != null) {
    return [
      FormattedText(Strings.demarcheCancelledLabel),
      FormattedText(demarche.deletionDate!.toDay(), bold: true),
    ];
  } else if (demarche.status == DemarcheStatus.DONE &&
      demarche.endDate != null) {
    return [
      FormattedText(Strings.demarcheDoneLabel),
      FormattedText(demarche.endDate!.toDay(), bold: true),
    ];
  } else if (demarche.endDate != null) {
    return [
      FormattedText(Strings.demarcheActiveLabel),
      FormattedText(demarche.endDate!.toDay(), bold: true),
    ];
  } else {
    return [FormattedText(Strings.withoutDate)];
  }
}

DemarcheStatus? _getStatusFromTag(UserActionTagViewModel tag) {
  switch (tag.title) {
    case Strings.demarcheToDo:
      return DemarcheStatus.NOT_STARTED;
    case Strings.demarcheInProgress:
      return DemarcheStatus.IN_PROGRESS;
    case Strings.demarcheCancelled:
      return DemarcheStatus.CANCELLED;
    case Strings.demarcheDone:
      return DemarcheStatus.DONE;
    default:
      return null;
  }
}

bool _isLate(DemarcheStatus status, DateTime? endDate) {
  if (endDate != null &&
      (status == DemarcheStatus.NOT_STARTED ||
          status == DemarcheStatus.IN_PROGRESS)) {
    return endDate.isBefore(DateTime.now()) &&
        (endDate.numberOfDaysUntilToday() > 0);
  }
  return false;
}

DisplayState _updateStateDisplayState(UpdateDemarcheState state) {
  if (state is UpdateDemarcheLoadingState) return DisplayState.LOADING;
  return DisplayState.EMPTY;
}
