import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/demarche/create_demarche_form/create_demarche_form_display_state.dart';
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
    displayState = switch (displayState) {
      CreateDemarche2ConfirmationStep() || CreateDemarche2Step1() => displayState,
      CreateDemarche2FromThematiqueStep2() => CreateDemarche2Step1(),
      CreateDemarche2PersonnaliseeStep2() => CreateDemarche2Step1(),
      CreateDemarche2FromThematiqueStep3() => CreateDemarche2FromThematiqueStep2(),
      CreateDemarche2PersonnaliseeStep3() => CreateDemarche2PersonnaliseeStep2(),
    };
    notifyListeners();
  }

  bool get isDescriptionValid => personnaliseeStep2ViewModel.description.isNotEmpty;
  bool get isDateValid => personnaliseeStep3ViewModel.dateSource.isValid;

  void navigateToCreateDemarcheConfirmation() {
    displayState = CreateDemarche2ConfirmationStep();
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
}

sealed class CreateDemarche2ViewModel extends Equatable {
  bool get isValid;
}
