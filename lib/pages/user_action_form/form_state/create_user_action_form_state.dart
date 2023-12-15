import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/pages/user_action_form/create_user_action_form_step1_page.dart';

part 'create_user_action_step1_state.dart';
part 'create_user_action_step2_state.dart';
part 'create_user_action_step3_state.dart';

enum CreateUserActionView {
  aborted,
  step1,
  step2,
  step3,
  submitted,
}

class CreateUserActionFormState extends ChangeNotifier {
  CreateUserActionStep1State step1;
  CreateUserActionStep2State step2;
  CreateUserActionStep3State step3;
  CreateUserActionView currentView;

  CreateUserActionFormState({
    CreateUserActionStep1State? initialStep1,
    CreateUserActionStep2State? initialStep2,
    CreateUserActionStep3State? initialStep3,
    CreateUserActionView? initialStep,
  })  : step1 = initialStep1 ?? CreateUserActionStep1State(),
        step2 = initialStep2 ?? CreateUserActionStep2State(),
        step3 = initialStep3 ?? CreateUserActionStep3State(),
        currentView = initialStep ?? CreateUserActionView.step1;

  void viewChangedForward() {
    currentView = switch (currentView) {
      CreateUserActionView.step1 => CreateUserActionView.step2,
      CreateUserActionView.step2 => CreateUserActionView.step3,
      CreateUserActionView.step3 => CreateUserActionView.submitted,
      _ => currentView,
    };
    notifyListeners();
  }

  void viewChangedBackward() {
    currentView = switch (currentView) {
      CreateUserActionView.step1 => CreateUserActionView.aborted,
      CreateUserActionView.step2 => CreateUserActionView.step1,
      CreateUserActionView.step3 => CreateUserActionView.step2,
      _ => currentView,
    };
    notifyListeners();
  }

  bool get canGoForward => switch (currentView) {
        CreateUserActionView.step1 => step1.isValid,
        CreateUserActionView.step2 => step2.isValid,
        CreateUserActionView.step3 => step3.isValid,
        _ => false,
      };

  CreateUserActionPageState get currentstate => switch (currentView) {
        CreateUserActionView.aborted => step1,
        CreateUserActionView.step1 => step1,
        CreateUserActionView.step2 => step2,
        CreateUserActionView.step3 => step3,
        CreateUserActionView.submitted => step3,
      };

  void userActionTypeSelected(UserActionReferentielType type) {
    step1 = step1.copyWith(type: type);
    viewChangedForward();
  }

  void titleChanged(CreateActionTitleSource titleSource) {
    step2 = step2.copyWith(titleSource: titleSource);
    notifyListeners();
  }

  void descriptionChanged(String description) {
    step2 = step2.copyWith(description: description);
    notifyListeners();
  }

  void statusChanged(bool isCompleted) {
    step3 = step3.copyWith(estTerminee: isCompleted);
    notifyListeners();
  }

  void dateChanged(CreateActionDateSource date) {
    step3 = step3.copyWith(date: date);
    notifyListeners();
  }

  void withRappelChanged(bool value) {
    step3 = step3.copyWith(withRappel: value);
    notifyListeners();
  }
}

sealed class CreateUserActionPageState extends Equatable {
  bool get isValid;
}

extension CreateUserActionFormStateExt on CreateUserActionFormState {
  bool get shouldDisplayNavigationButtons => isStep2 || isStep3;

  bool get isAborted => currentView == CreateUserActionView.aborted;
  bool get isStep1 => currentView == CreateUserActionView.step1;
  bool get isStep2 => currentView == CreateUserActionView.step2;
  bool get isStep3 => currentView == CreateUserActionView.step3;
  bool get isSubmitted => currentView == CreateUserActionView.submitted;

  UserActionCreateRequest get toRequest => UserActionCreateRequest(
        // TODO: Vérifier ces champs + ajouter le type
        step2.titleSource.title,
        step2.description,
        step3.date.selectedDate,
        step3.withRappel,
        step3.estTerminee ? UserActionStatus.DONE : UserActionStatus.IN_PROGRESS,
      );
}
