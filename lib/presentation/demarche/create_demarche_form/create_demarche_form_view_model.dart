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
part 'steps/create_demarche_ia_ft_step_2_view_model.dart';
part 'steps/create_demarche_personnalisee_step_2.dart';
part 'steps/create_demarche_personnalisee_step_3.dart';
part 'steps/create_demarche_step_1.dart';

class CreateDemarcheFormViewModel extends ChangeNotifier {
  CreateDemarcheDisplayState displayState;

  CreateDemarcheFormViewModel({
    CreateDemarcheDisplayState? displayState,
    CreateDemarcheStep1ViewModel? initialStep1ViewModel,
    CreateDemarcheFromThematiqueStep2ViewModel? initialThematiqueStep2ViewModel,
    CreateDemarchePersonnaliseeStep2ViewModel? initialPersonnaliseeStep2ViewModel,
    CreateDemarcheIaFtStep2ViewModel? initialIaFtStep2ViewModel,
    CreateDemarcheFromThematiqueStep3ViewModel? initialFromThematiqueStep3ViewModel,
    CreateDemarchePersonnaliseeStep3ViewModel? initialPersonnaliseeStep3ViewModel,
    CreateDemarcheConfirmationStepViewModel? initialConfirmationStepViewModel,
  })  : displayState = displayState ?? CreateDemarcheStep1(),
        step1ViewModel = initialStep1ViewModel ?? CreateDemarcheStep1ViewModel(),
        thematiqueStep2ViewModel = initialThematiqueStep2ViewModel ?? CreateDemarcheFromThematiqueStep2ViewModel(),
        personnaliseeStep2ViewModel = initialPersonnaliseeStep2ViewModel ?? CreateDemarchePersonnaliseeStep2ViewModel(),
        iaFtStep2ViewModel = initialIaFtStep2ViewModel ?? CreateDemarcheIaFtStep2ViewModel(),
        fromThematiqueStep3ViewModel =
            initialFromThematiqueStep3ViewModel ?? CreateDemarcheFromThematiqueStep3ViewModel(),
        personnaliseeStep3ViewModel = initialPersonnaliseeStep3ViewModel ?? CreateDemarchePersonnaliseeStep3ViewModel(),
        confirmationStepViewModel = initialConfirmationStepViewModel ?? CreateDemarcheConfirmationStepViewModel();

  CreateDemarcheStep1ViewModel step1ViewModel;
  CreateDemarcheFromThematiqueStep2ViewModel thematiqueStep2ViewModel;
  CreateDemarchePersonnaliseeStep2ViewModel personnaliseeStep2ViewModel;
  CreateDemarcheIaFtStep2ViewModel iaFtStep2ViewModel;
  CreateDemarcheFromThematiqueStep3ViewModel fromThematiqueStep3ViewModel;
  CreateDemarchePersonnaliseeStep3ViewModel personnaliseeStep3ViewModel;
  CreateDemarcheConfirmationStepViewModel confirmationStepViewModel;

  void onNavigateBackward() {
    if (displayState is CreateDemarcheFromThematiqueStep3) {
      fromThematiqueStep3ViewModel = CreateDemarcheFromThematiqueStep3ViewModel();
    }

    displayState = switch (displayState) {
      CreateDemarcheStep1() => displayState,
      CreateDemarcheFromThematiqueStep2() => CreateDemarcheStep1(),
      CreateDemarchePersonnaliseeStep2() => CreateDemarcheStep1(),
      CreateDemarcheIaFtStep2() => CreateDemarcheStep1(),
      CreateDemarcheFromThematiqueStep3() => CreateDemarcheFromThematiqueStep2(),
      CreateDemarchePersonnaliseeStep3() => CreateDemarchePersonnaliseeStep2(),
      CreateDemarcheIaFtStep3() => CreateDemarcheIaFtStep2(),
      CreateDemarcheFromThematiqueSubmitted() => CreateDemarcheFromThematiqueStep2(),
      CreateDemarchePersonnaliseeSubmitted() => CreateDemarchePersonnaliseeStep2(),
      CreateDemarcheIaFtSubmitted() => CreateDemarcheIaFtStep2(),
    };
    notifyListeners();
  }

  bool get isDescriptionValid => personnaliseeStep2ViewModel.description.isNotEmpty;
  bool get isDemarchePersonnaliseeDateValid => personnaliseeStep3ViewModel.dateSource.isValid;

  void submitDemarchePersonnalisee() {
    displayState = CreateDemarchePersonnaliseeSubmitted();
    notifyListeners();
  }

  void submitDemarcheThematique() {
    displayState = CreateDemarcheFromThematiqueSubmitted();
    notifyListeners();
  }

  void submitDemarcheIaFt(List<CreateDemarcheRequestAction> createRequests) {
    displayState = CreateDemarcheIaFtSubmitted(createRequests: createRequests);
    notifyListeners();
  }

  void navigateToCreateCustomDemarche() {
    displayState = CreateDemarchePersonnaliseeStep2();
    notifyListeners();
  }

  void navigateToCreateDemarcheIaFtStep2() {
    displayState = CreateDemarcheIaFtStep2();
    notifyListeners();
  }

  void navigateToCreateDemarcheIaFtStep3() {
    displayState = CreateDemarcheIaFtStep3();
    notifyListeners();
  }

  void navigateToCreateDemarchePersonnaliseeStep3() {
    displayState = CreateDemarchePersonnaliseeStep3();
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
    displayState = CreateDemarcheFromThematiqueStep2();
    notifyListeners();
  }

  void demarcheSelected(DemarcheDuReferentielCardViewModel demarcheCardViewModel) {
    thematiqueStep2ViewModel = thematiqueStep2ViewModel.copyWith(demarcheCardViewModel: demarcheCardViewModel);
    displayState = CreateDemarcheFromThematiqueStep3();
    notifyListeners();
  }

  void iaFtDescriptionChanged(String value) {
    iaFtStep2ViewModel = iaFtStep2ViewModel.copyWith(description: value);
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

sealed class CreateDemarcheViewModel extends Equatable {}
