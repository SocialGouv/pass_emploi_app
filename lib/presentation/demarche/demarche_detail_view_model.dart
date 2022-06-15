import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/features/demarche/list/demarche_list_state.dart';
import 'package:pass_emploi_app/features/demarche/update/update_demarche_action.dart';
import 'package:pass_emploi_app/models/demarche.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_tag_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

void _emptyFunction(UserActionTagViewModel tag) {
  // Do nothing
}

class DemarcheDetailViewModel extends Equatable {
  final bool createdByAdvisor;
  final bool modifiedByAdvisor;
  final String formattedDate;
  final String? label;
  final String? titreDetail;
  final String? sousTitre;
  final String? modificationDate;
  final String? creationDate;
  final List<String> attributs;
  final List<UserActionTagViewModel> statutsPossibles;
  final Function(UserActionTagViewModel) onModifyStatus;
  final bool isLate;

  DemarcheDetailViewModel({
    required this.createdByAdvisor,
    required this.modifiedByAdvisor,
    required this.formattedDate,
    required this.label,
    required this.titreDetail,
    required this.sousTitre,
    required this.attributs,
    required this.statutsPossibles,
    required this.modificationDate,
    required this.creationDate,
    this.onModifyStatus = _emptyFunction,
    required this.isLate,
  });

  factory DemarcheDetailViewModel.create(Store<AppState> store, String id) {
    final Demarche demarche =
        (store.state.demarcheListState as DemarcheListSuccessState).demarches.firstWhere((element) => element.id == id);
    demarche.possibleStatus.sort((a, b) => a.compareTo(b));
    return DemarcheDetailViewModel(
      createdByAdvisor: demarche.createdByAdvisor,
      modifiedByAdvisor: demarche.modifiedByAdvisor,
      formattedDate: _setFormattedDate(demarche.status, demarche.endDate?.toDay(), demarche.deletionDate?.toDay()),
      label: demarche.label,
      titreDetail: demarche.titre,
      sousTitre: demarche.sousTitre,
      attributs: demarche.attributs.map((e) => e.valeur).toList(),
      statutsPossibles: demarche.possibleStatus.map((e) => _getTagViewModel(e, demarche.status)).toList(),
      modificationDate: demarche.modificationDate?.toDay(),
      creationDate: demarche.creationDate?.toDay(),
      onModifyStatus: (tag) {
        final status = _getStatusFromTag(tag);
        if (!tag.isSelected && status != null) {
          store.dispatch(UpdateDemarcheAction(
            demarche.id,
            demarche.endDate,
            demarche.creationDate,
            status,
          ));
        }
      },
      isLate: isLateAction(demarche.status, demarche.endDate),
    );
  }

  @override
  List<Object?> get props => [
        createdByAdvisor,
        modifiedByAdvisor,
        formattedDate,
        label,
        titreDetail,
        sousTitre,
        modificationDate,
        creationDate,
        attributs,
        statutsPossibles,
      ];
}

UserActionTagViewModel _getTagViewModel(DemarcheStatus status, DemarcheStatus currentStatus) {
  final bool isSelected = status == currentStatus;
  switch (status) {
    case DemarcheStatus.NOT_STARTED:
      return UserActionTagViewModel(
        title: Strings.actionPEToDo,
        backgroundColor: isSelected ? AppColors.accent1Lighten : Colors.transparent,
        textColor: isSelected ? AppColors.accent1 : AppColors.grey800,
        isSelected: isSelected,
      );
    case DemarcheStatus.IN_PROGRESS:
      return UserActionTagViewModel(
        title: Strings.actionPEInProgress,
        backgroundColor: isSelected ? AppColors.accent3Lighten : Colors.transparent,
        textColor: isSelected ? AppColors.accent3 : AppColors.grey800,
        isSelected: isSelected,
      );
    case DemarcheStatus.DONE:
      return UserActionTagViewModel(
        title: Strings.actionPEDone,
        backgroundColor: isSelected ? AppColors.accent2Lighten : Colors.transparent,
        textColor: isSelected ? AppColors.accent2 : AppColors.grey800,
        isSelected: isSelected,
      );
    case DemarcheStatus.CANCELLED:
      return UserActionTagViewModel(
        title: Strings.actionPECancelled,
        backgroundColor: isSelected ? AppColors.accent2Lighten : Colors.transparent,
        textColor: isSelected ? AppColors.accent2 : AppColors.grey800,
        isSelected: isSelected,
      );
  }
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

DemarcheStatus? _getStatusFromTag(UserActionTagViewModel tag) {
  switch (tag.title) {
    case Strings.actionPEToDo:
      return DemarcheStatus.NOT_STARTED;
    case Strings.actionPEInProgress:
      return DemarcheStatus.IN_PROGRESS;
    case Strings.actionPECancelled:
      return DemarcheStatus.CANCELLED;
    case Strings.actionPEDone:
      return DemarcheStatus.DONE;
    default:
      return null;
  }
}
