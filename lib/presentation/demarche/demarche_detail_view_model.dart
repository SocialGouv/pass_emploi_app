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
  final bool withOfflineBehavior;
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
    required this.withOfflineBehavior,
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
      withOfflineBehavior: store.state.connectivityState.isOffline(),
      dateFormattedTexts: _formattedDate(demarche),
      dateBackgroundColor: isLate ? AppColors.warningLighten : AppColors.accent3Lighten,
      dateTextColor: isLate ? AppColors.warning : AppColors.accent2,
      dateIcons: [AppIcons.schedule_rounded],
      label: demarche.label,
      titreDetail: demarche.titre,
      sousTitre: demarche.sousTitre,
      attributs: demarche.attributs.map((e) => e.value).toList(),
      statutsPossibles: demarche.possibleStatus.map((e) => _getTagViewModel(e, demarche.status)).toList(),
      modificationDate: demarche.modificationDate?.toDay(),
      creationDate: demarche.creationDate?.toDay(),
      withDateDerniereMiseAJour: _withDateDerniereMiseAJour(dateDerniereMiseAJour),
      onModifyStatus: (tag) {
        final status = getStatusFromTag(tag);
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
  List<Object?> get props =>
      [
        createdByAdvisor,
        modifiedByAdvisor,
        withOfflineBehavior,
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
  return Strings.dateDerniereMiseAJourDemarches(dateDerniereMiseAJour.toDayAndHour());
}

UserActionTagViewModel _getTagViewModel(DemarcheStatus status, DemarcheStatus currentStatus) {
  final bool isSelected = status == currentStatus;
  switch (status) {
    case DemarcheStatus.pasCommencee:
      return UserActionTagViewModel(
        title: Strings.todoPillule,
        backgroundColor: isSelected ? AppColors.accent1Lighten : Colors.transparent,
        textColor: isSelected ? AppColors.accent1 : AppColors.grey800,
        isSelected: isSelected,
      );
    case DemarcheStatus.enCours:
      return UserActionTagViewModel(
        title: Strings.doingPillule,
        backgroundColor: isSelected ? AppColors.accent3Lighten : Colors.transparent,
        textColor: isSelected ? AppColors.accent3 : AppColors.grey800,
        isSelected: isSelected,
      );
    case DemarcheStatus.terminee:
      return UserActionTagViewModel(
        title: Strings.donePillule,
        backgroundColor: isSelected ? AppColors.accent2Lighten : Colors.transparent,
        textColor: isSelected ? AppColors.accent2 : AppColors.grey800,
        isSelected: isSelected,
      );
    case DemarcheStatus.annulee:
      return UserActionTagViewModel(
        title: Strings.canceledPillule,
        backgroundColor: isSelected ? AppColors.accent2Lighten : Colors.transparent,
        textColor: isSelected ? AppColors.accent2 : AppColors.grey800,
        isSelected: isSelected,
      );
  }
}

List<FormattedText> _formattedDate(Demarche demarche) {
  if (demarche.status == DemarcheStatus.annulee && demarche.deletionDate != null) {
    return [
      FormattedText(Strings.demarcheCancelledLabel),
      FormattedText(demarche.deletionDate!.toDay(), bold: true),
    ];
  } else if (demarche.status == DemarcheStatus.terminee && demarche.endDate != null) {
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

DemarcheStatus? getStatusFromTag(UserActionTagViewModel tag) {
  switch (tag.title) {
    case Strings.todoPillule:
      return DemarcheStatus.pasCommencee;
    case Strings.doingPillule:
      return DemarcheStatus.enCours;
    case Strings.canceledPillule:
      return DemarcheStatus.annulee;
    case Strings.donePillule:
      return DemarcheStatus.terminee;
    default:
      return null;
  }
}

bool _isLate(DemarcheStatus status, DateTime? endDate) {
  if (endDate != null && (status == DemarcheStatus.pasCommencee || status == DemarcheStatus.enCours)) {
    return endDate.isBefore(DateTime.now()) && (endDate.numberOfDaysUntilToday() > 0);
  }
  return false;
}

DisplayState _updateStateDisplayState(UpdateDemarcheState state) {
  if (state is UpdateDemarcheLoadingState) return DisplayState.chargement;
  if (state is UpdateDemarcheFailureState) return DisplayState.erreur;
  return DisplayState.vide;
}
