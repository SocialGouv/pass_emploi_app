import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_state.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_card_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_store_extension.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/model/formatted_text.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_pillule.dart';
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
  final bool withDemarcheDoneButton;
  final Function() resetUpdateStatus;
  final DisplayState updateDisplayState;
  final CardPilluleType? pillule;

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
    required this.modificationDate,
    required this.creationDate,
    required this.withDateDerniereMiseAJour,
    required this.withDemarcheDoneButton,
    required this.resetUpdateStatus,
    required this.updateDisplayState,
    required this.pillule,
  });

  factory DemarcheDetailViewModel.create(Store<AppState> store, String demarcheId) {
    final demarche = store.getDemarcheOrNull(demarcheId);

    if (demarche == null) {
      return DemarcheDetailViewModel.empty();
    }

    final dateDerniereMiseAJour = _getDateDerniereMiseAJour(store);
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
      modificationDate: demarche.modificationDate?.toDay(),
      creationDate: demarche.creationDate?.toDay(),
      withDateDerniereMiseAJour: _withDateDerniereMiseAJour(dateDerniereMiseAJour),
      withDemarcheDoneButton: demarche.possibleStatus.contains(DemarcheStatus.DONE),
      resetUpdateStatus: () => store.dispatch(UpdateDemarcheResetAction()),
      updateDisplayState: _updateStateDisplayState(updateState),
      pillule: demarche.pillule(),
    );
  }

  factory DemarcheDetailViewModel.empty() {
    return DemarcheDetailViewModel(
      createdByAdvisor: false,
      modifiedByAdvisor: false,
      withOfflineBehavior: false,
      dateFormattedTexts: [],
      dateTextColor: Colors.black,
      dateBackgroundColor: Colors.transparent,
      dateIcons: [],
      label: null,
      titreDetail: null,
      sousTitre: null,
      attributs: [],
      modificationDate: null,
      creationDate: null,
      withDateDerniereMiseAJour: null,
      withDemarcheDoneButton: false,
      resetUpdateStatus: () {},
      updateDisplayState: DisplayState.EMPTY,
      pillule: null,
    );
  }

  @override
  List<Object?> get props => [
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
        withDemarcheDoneButton,
        updateDisplayState,
        pillule,
      ];
}

DateTime? _getDateDerniereMiseAJour(Store<AppState> store) {
  if (store.state.monSuiviState is MonSuiviSuccessState) {
    return (store.state.monSuiviState as MonSuiviSuccessState).monSuivi.dateDerniereMiseAJourPoleEmploi;
  }
  return null;
}

String? _withDateDerniereMiseAJour(DateTime? dateDerniereMiseAJour) {
  if (dateDerniereMiseAJour == null) return null;
  return Strings.dateDerniereMiseAJourDemarches(dateDerniereMiseAJour.toDayAndHour());
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
