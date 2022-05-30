import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_actions.dart';
import 'package:pass_emploi_app/features/user_action_pe/list/user_action_pe_list_state.dart';
import 'package:pass_emploi_app/models/user_action_pe.dart';
import 'package:pass_emploi_app/presentation/user_action/user_action_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

void _emptyFunction(UserActionTagViewModel) {
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
  });

  factory DemarcheDetailViewModel.create(Store<AppState> store, String id) {
    final UserActionPE userAction = (store.state.userActionPEListState as UserActionPEListSuccessState).userActions.firstWhere((element) => element.id == id);
    userAction.possibleStatus.sort((a, b) => a.compareTo(b));
    return DemarcheDetailViewModel(
      createdByAdvisor: userAction.createdByAdvisor,
      modifiedByAdvisor: userAction.modifiedByAdvisor,
      formattedDate: _setFormattedDate(userAction.status, userAction.endDate?.toDay(), userAction.deletionDate?.toDay()),
      label: userAction.label,
      titreDetail: userAction.titre,
      sousTitre: userAction.sousTitre,
      attributs: userAction.attributs.map((e) => e.valeur).toList(),
      statutsPossibles: userAction.possibleStatus.map((e) => _getTagViewModel(e, userAction.status)).toList(),
      modificationDate: userAction.modificationDate?.toDay(),
      creationDate: userAction.creationDate?.toDay(),
      onModifyStatus: (tag) {
        final status = _getStatusFromTag(tag);
        if (!tag.isSelected && status != null) {
          store.dispatch(ModifyDemarcheStatusAction(userAction.id, userAction.creationDate, status));
        }
      },
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

UserActionTagViewModel _getTagViewModel(UserActionPEStatus status, UserActionPEStatus currentStatus) {
  final bool isSelected = status == currentStatus;
  switch (status) {
    case UserActionPEStatus.NOT_STARTED:
      return UserActionTagViewModel(
        title: Strings.actionPEToDo,
        backgroundColor: isSelected ? AppColors.accent1Lighten : Colors.transparent,
        textColor: isSelected ? AppColors.accent1 : AppColors.grey800,
        isSelected: isSelected,
      );
    case UserActionPEStatus.IN_PROGRESS:
      return UserActionTagViewModel(
        title: Strings.actionPEInProgress,
        backgroundColor: isSelected ? AppColors.accent3Lighten : Colors.transparent,
        textColor: isSelected ? AppColors.accent3 : AppColors.grey800,
        isSelected: isSelected,
      );
    case UserActionPEStatus.RETARDED:
      return UserActionTagViewModel(
        title: Strings.actionPERetarded,
        backgroundColor: isSelected ? AppColors.warningLighten : Colors.transparent,
        textColor: isSelected ? AppColors.warning : AppColors.grey800,
        isSelected: isSelected,
      );
    case UserActionPEStatus.DONE:
      return UserActionTagViewModel(
        title: Strings.actionPEDone,
        backgroundColor: isSelected ? AppColors.accent2Lighten : Colors.transparent,
        textColor: isSelected ? AppColors.accent2 : AppColors.grey800,
        isSelected: isSelected,
      );
    case UserActionPEStatus.CANCELLED:
      return UserActionTagViewModel(
        title: Strings.actionPECancelled,
        backgroundColor: isSelected ? AppColors.accent2Lighten : Colors.transparent,
        textColor: isSelected ? AppColors.accent2 : AppColors.grey800,
        isSelected: isSelected,
      );
  }
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

UserActionPEStatus? _getStatusFromTag(UserActionTagViewModel tag) {
  switch (tag.title) {
    case Strings.actionPEToDo:
      return UserActionPEStatus.NOT_STARTED;
    case Strings.actionPEInProgress:
      return UserActionPEStatus.IN_PROGRESS;
    case Strings.actionPECancelled:
      return UserActionPEStatus.CANCELLED;
    case Strings.actionPEDone:
      return UserActionPEStatus.DONE;
    default:
      return null;
  }
}
