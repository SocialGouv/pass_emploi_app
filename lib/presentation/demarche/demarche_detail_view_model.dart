import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_state.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_state_source.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_view_model_helper.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_tag_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

class DemarcheDetailViewModel extends Equatable {
  final bool createdByAdvisor;
  final bool modifiedByAdvisor;
  final List<FormattedText> dateFormattedTexts;
  final Color dateTextColor;
  final Color dateBackgroundColor;
  final List<IconData> dateIcons;
  final String? label;
  final String? titreDetail;
  final String? sousTitre;
  final String? modificationDate;
  final String? creationDate;
  final String? withDateDerniereMiseAJour;
  final List<String> attributs;
  final List<UserActionTagViewModel> statutsPossibles;
  final Function(UserActionTagViewModel) onModifyStatus;
  final Function() resetUpdateStatus;
  final DisplayState updateDisplayState;

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
    required this.withDateDerniereMiseAJour,
    required this.onModifyStatus,
    required this.resetUpdateStatus,
    required this.updateDisplayState,
  });

  factory DemarcheDetailViewModel.create(Store<AppState> store, DemarcheStateSource stateSource, String demarcheId) {
    final demarche = getDemarche(store, stateSource, demarcheId);
    final dateDerniereMiseAJour = _getDateDerniereMiseAJour(store, stateSource);
    demarche.possibleStatus.sort((a, b) => a.compareTo(b));
    final isLate = _isLate(demarche.status, demarche.endDate);
    final updateState = store.state.updateDemarcheState;
    return DemarcheDetailViewModel(
      createdByAdvisor: demarche.createdByAdvisor,
      modifiedByAdvisor: demarche.modifiedByAdvisor,
      dateFormattedTexts: _formattedDate(demarche),
      dateBackgroundColor: isLate ? AppColors.warningLighten : AppColors.accent3Lighten,
      dateTextColor: isLate ? AppColors.warning : AppColors.accent2,
      dateIcons: [if (isLate) AppIcons.error_rounded, AppIcons.schedule_rounded],
      label: demarche.label,
      titreDetail: demarche.titre,
      sousTitre: demarche.sousTitre,
      attributs: demarche.attributs.map((e) => e.value).toList(),
      statutsPossibles: demarche.possibleStatus.map((e) => _getTagViewModel(e, demarche.status)).toList(),
      modificationDate: demarche.modificationDate?.toDay(),
      creationDate: demarche.creationDate?.toDay(),
      withDateDerniereMiseAJour: _withDateDerniereMiseAJour(dateDerniereMiseAJour),
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
        withDateDerniereMiseAJour,
        attributs,
        statutsPossibles,
        updateDisplayState,
      ];
}

DateTime? _getDateDerniereMiseAJour(Store<AppState> store, DemarcheStateSource stateSource) {
  if (stateSource == DemarcheStateSource.agenda && store.state.agendaState is AgendaSuccessState) {
    return (store.state.agendaState as AgendaSuccessState).agenda.dateDerniereMiseAJour;
  } else if (stateSource == DemarcheStateSource.demarcheList &&
      store.state.demarcheListState is DemarcheListSuccessState) {
    return (store.state.demarcheListState as DemarcheListSuccessState).dateDerniereMiseAJour;
  }
  return null;
}

String? _withDateDerniereMiseAJour(DateTime? dateDerniereMiseAJour) {
  if (dateDerniereMiseAJour == null) return null;
  return Strings.dateDerniereMiseAJourDemarches(dateDerniereMiseAJour.toDayandHour());
}

UserActionTagViewModel _getTagViewModel(DemarcheStatus status, DemarcheStatus currentStatus) {
  final bool isSelected = status == currentStatus;
  switch (status) {
    case DemarcheStatus.NOT_STARTED:
      return UserActionTagViewModel(
        title: Strings.demarcheToDo,
        backgroundColor: isSelected ? AppColors.accent1Lighten : Colors.transparent,
        textColor: isSelected ? AppColors.accent1 : AppColors.grey800,
        isSelected: isSelected,
      );
    case DemarcheStatus.IN_PROGRESS:
      return UserActionTagViewModel(
        title: Strings.demarcheInProgress,
        backgroundColor: isSelected ? AppColors.accent3Lighten : Colors.transparent,
        textColor: isSelected ? AppColors.accent3 : AppColors.grey800,
        isSelected: isSelected,
      );
    case DemarcheStatus.DONE:
      return UserActionTagViewModel(
        title: Strings.demarcheDone,
        backgroundColor: isSelected ? AppColors.accent2Lighten : Colors.transparent,
        textColor: isSelected ? AppColors.accent2 : AppColors.grey800,
        isSelected: isSelected,
      );
    case DemarcheStatus.CANCELLED:
      return UserActionTagViewModel(
        title: Strings.demarcheCancelled,
        backgroundColor: isSelected ? AppColors.accent2Lighten : Colors.transparent,
        textColor: isSelected ? AppColors.accent2 : AppColors.grey800,
        isSelected: isSelected,
      );
  }
}

List<FormattedText> _formattedDate(Demarche demarche) {
  if (demarche.status == DemarcheStatus.CANCELLED && demarche.deletionDate != null) {
    return [
      FormattedText(Strings.demarcheCancelledLabel),
      FormattedText(demarche.deletionDate!.toDay(), bold: true),
    ];
  } else if (demarche.status == DemarcheStatus.DONE && demarche.endDate != null) {
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
  if (endDate != null && (status == DemarcheStatus.NOT_STARTED || status == DemarcheStatus.IN_PROGRESS)) {
    return endDate.isBefore(DateTime.now()) && (endDate.numberOfDaysUntilToday() > 0);
  }
  return false;
}

DisplayState _updateStateDisplayState(UpdateDemarcheState state) {
  if (state is UpdateDemarcheLoadingState) return DisplayState.LOADING;
  if (state is UpdateDemarcheFailureState) return DisplayState.FAILURE;
  return DisplayState.EMPTY;
}
