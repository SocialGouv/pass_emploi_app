import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/features/demarche/create/create_demarche_actions.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_form/create_demarche_form_display_state.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_step3_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_du_referentiel_card_view_model.dart';
import 'package:pass_emploi_app/presentation/demarche/thematiques_demarche_view_model.dart';
import 'package:pass_emploi_app/presentation/model/date_input_source.dart';

part 'steps/create_demarche_confirmation_step.dart';
part 'steps/create_demarche_from_thematique_step_2.dart';
part 'steps/create_demarche_from_thematique_step_3.dart';
part 'steps/create_demarche_personnalisee_step_2.dart';
part 'steps/create_demarche_personnalisee_step_3.dart';
part 'steps/create_demarche_step_1.dart';

class CreateDemarcheFormViewModel extends ChangeNotifier {
  CreateDemarcheDisplayState displayState;

  CreateDemarcheFormViewModel({
    CreateDemarcheDisplayState? displayState,
    CreateDemarche2Step1ViewModel? initialStep1ViewModel,
    CreateDemarche2FromThematiqueStep2ViewModel? initialThematiqueStep2ViewModel,
    CreateDemarche2PersonnaliseeStep2ViewModel? initialPersonnaliseeStep2ViewModel,
    CreateDemarche2FromThematiqueStep3ViewModel? initialFromThematiqueStep3ViewModel,
    CreateDemarche2PersonnaliseeStep3ViewModel? initialPersonnaliseeStep3ViewModel,
    CreateDemarche2ConfirmationStepViewModel? initialConfirmationStepViewModel,
  })  : displayState = displayState ?? CreateDemarche2Step1(),
        step1ViewModel = initialStep1ViewModel ?? CreateDemarche2Step1ViewModel(),
        thematiqueStep2ViewModel = initialThematiqueStep2ViewModel ?? CreateDemarche2FromThematiqueStep2ViewModel(),
        personnaliseeStep2ViewModel =
            initialPersonnaliseeStep2ViewModel ?? CreateDemarche2PersonnaliseeStep2ViewModel(),
        fromThematiqueStep3ViewModel =
            initialFromThematiqueStep3ViewModel ?? CreateDemarche2FromThematiqueStep3ViewModel(),
        personnaliseeStep3ViewModel =
            initialPersonnaliseeStep3ViewModel ?? CreateDemarche2PersonnaliseeStep3ViewModel(),
        confirmationStepViewModel = initialConfirmationStepViewModel ?? CreateDemarche2ConfirmationStepViewModel();

  CreateDemarche2Step1ViewModel step1ViewModel;
  CreateDemarche2FromThematiqueStep2ViewModel thematiqueStep2ViewModel;
  CreateDemarche2PersonnaliseeStep2ViewModel personnaliseeStep2ViewModel;
  CreateDemarche2FromThematiqueStep3ViewModel fromThematiqueStep3ViewModel;
  CreateDemarche2PersonnaliseeStep3ViewModel personnaliseeStep3ViewModel;
  CreateDemarche2ConfirmationStepViewModel confirmationStepViewModel;

  void onNavigateBackward() {
    if (displayState is CreateDemarche2FromThematiqueStep3) {
      fromThematiqueStep3ViewModel = CreateDemarche2FromThematiqueStep3ViewModel();
    }

    displayState = switch (displayState) {
      CreateDemarche2Step1() => displayState,
      CreateDemarche2FromThematiqueStep2() => CreateDemarche2Step1(),
      CreateDemarche2PersonnaliseeStep2() => CreateDemarche2Step1(),
      CreateDemarche2FromThematiqueStep3() => CreateDemarche2FromThematiqueStep2(),
      CreateDemarche2PersonnaliseeStep3() => CreateDemarche2PersonnaliseeStep2(),
      CreateDemarche2FromThematiqueSubmitted() => CreateDemarche2FromThematiqueStep2(),
      CreateDemarche2PersonnaliseeSubmitted() => CreateDemarche2PersonnaliseeStep2(),
    };
    notifyListeners();
  }

  bool get isDescriptionValid => personnaliseeStep2ViewModel.description.isNotEmpty;
  bool get isDemarchePersonnaliseeDateValid => personnaliseeStep3ViewModel.dateSource.isValid;

  void submitDemarchePersonnalisee() {
    displayState = CreateDemarche2PersonnaliseeSubmitted();
    notifyListeners();
  }

  void submitDemarcheThematique() {
    displayState = CreateDemarche2FromThematiqueSubmitted();
    notifyListeners();
  }

  void navigateToCreateCustomDemarche() {
    displayState = CreateDemarche2PersonnaliseeStep2();
    notifyListeners();
  }

  void navigateToCreateDemarchePersonnaliseeStep3() {
    displayState = CreateDemarche2PersonnaliseeStep3();
    notifyListeners();
  }

  void descriptionChanged(String value) {
    personnaliseeStep2ViewModel = personnaliseeStep2ViewModel.copyWith(description: value);
    notifyListeners();
  }

  void dateDemarchePersonnaliseeChanged(DateInputSource date) {
    personnaliseeStep3ViewModel = personnaliseeStep3ViewModel.copyWith(dateSource: date);
    notifyListeners();
  }

  void dateDemarcheThematiqueChanged(DateInputSource date) {
    fromThematiqueStep3ViewModel = fromThematiqueStep3ViewModel.copyWith(dateSource: date);
    notifyListeners();
  }

  void commentChanged(CommentItem comment) {
    fromThematiqueStep3ViewModel = fromThematiqueStep3ViewModel.copyWith(commentItem: comment);
    notifyListeners();
  }

  void thematiqueSelected(ThematiqueDemarcheItem thematique) {
    step1ViewModel = step1ViewModel.copyWith(selectedThematique: thematique);
    displayState = CreateDemarche2FromThematiqueStep2();
    notifyListeners();
  }

  void demarcheSelected(DemarcheDuReferentielCardViewModel demarcheCardViewModel) {
    thematiqueStep2ViewModel = thematiqueStep2ViewModel.copyWith(demarcheCardViewModel: demarcheCardViewModel);
    displayState = CreateDemarche2FromThematiqueStep3();
    notifyListeners();
  }

  CreateDemarcheRequestAction createDemarcheRequestAction() {
    return CreateDemarcheRequestAction(
      codeQuoi: thematiqueStep2ViewModel.selectedDemarcheVm?.codeQuoi ?? "",
      codePourquoi: thematiqueStep2ViewModel.selectedDemarcheVm?.codePourquoi ?? "",
      codeComment: fromThematiqueStep3ViewModel.commentItem?.code,
      dateEcheance: fromThematiqueStep3ViewModel.dateSource.selectedDate,
      estDuplicata: false,
    );
  }

  CreateDemarchePersonnaliseeRequestAction createDemarchePersonnaliseeRequestAction() {
    return CreateDemarchePersonnaliseeRequestAction(
      personnaliseeStep2ViewModel.description,
      personnaliseeStep3ViewModel.dateSource.selectedDate,
      false,
    );
  }
}

sealed class CreateDemarche2ViewModel extends Equatable {}
