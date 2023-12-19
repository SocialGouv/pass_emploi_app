import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';

part 'create_user_action_step1_view_model.dart';
part 'create_user_action_step2_view_model.dart';
part 'create_user_action_step3_view_model.dart';

// TODO: tester
enum CreateUserActionDisplayState {
  aborted,
  step1,
  step2,
  step3,
  submitted,
}

class CreateUserActionFormViewModel extends ChangeNotifier {
  CreateUserActionStep1ViewModel step1;
  CreateUserActionStep2ViewModel step2;
  CreateUserActionStep3ViewModel step3;
  CreateUserActionDisplayState currentView;

  CreateUserActionFormViewModel({
    CreateUserActionStep1ViewModel? initialStep1,
    CreateUserActionStep2ViewModel? initialStep2,
    CreateUserActionStep3ViewModel? initialStep3,
    CreateUserActionDisplayState? initialStep,
  })  : step1 = initialStep1 ?? CreateUserActionStep1ViewModel(),
        step2 = initialStep2 ?? CreateUserActionStep2ViewModel(),
        step3 = initialStep3 ?? CreateUserActionStep3ViewModel(),
        currentView = initialStep ?? CreateUserActionDisplayState.step1;

  void viewChangedForward() {
    currentView = switch (currentView) {
      CreateUserActionDisplayState.step1 => CreateUserActionDisplayState.step2,
      CreateUserActionDisplayState.step2 => CreateUserActionDisplayState.step3,
      CreateUserActionDisplayState.step3 => CreateUserActionDisplayState.submitted,
      _ => currentView,
    };
    notifyListeners();
  }

  void viewChangedBackward() {
    currentView = switch (currentView) {
      CreateUserActionDisplayState.step1 => CreateUserActionDisplayState.aborted,
      CreateUserActionDisplayState.step2 => CreateUserActionDisplayState.step1,
      CreateUserActionDisplayState.step3 => CreateUserActionDisplayState.step2,
      _ => currentView,
    };
    notifyListeners();
  }

  bool get canGoForward => switch (currentView) {
        CreateUserActionDisplayState.step1 => step1.isValid,
        CreateUserActionDisplayState.step2 => step2.isValid,
        CreateUserActionDisplayState.step3 => step3.isValid,
        _ => false,
      };

  CreateUserActionPageViewModel get currentstate => switch (currentView) {
        CreateUserActionDisplayState.aborted => step1,
        CreateUserActionDisplayState.step1 => step1,
        CreateUserActionDisplayState.step2 => step2,
        CreateUserActionDisplayState.step3 => step3,
        CreateUserActionDisplayState.submitted => step3,
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

sealed class CreateUserActionPageViewModel extends Equatable {
  bool get isValid;
}

extension CreateUserActionFormStateExt on CreateUserActionFormViewModel {
  bool get shouldDisplayNavigationButtons => isStep2 || isStep3;

  bool get isAborted => currentView == CreateUserActionDisplayState.aborted;
  bool get isStep1 => currentView == CreateUserActionDisplayState.step1;
  bool get isStep2 => currentView == CreateUserActionDisplayState.step2;
  bool get isStep3 => currentView == CreateUserActionDisplayState.step3;
  bool get isSubmitted => currentView == CreateUserActionDisplayState.submitted;

  UserActionCreateRequest get toRequest => UserActionCreateRequest(
        step2.titleSource.title,
        step2.description,
        step3.date.selectedDate,
        step3.withRappel,
        step3.estTerminee ? UserActionStatus.DONE : UserActionStatus.IN_PROGRESS,
        step1.actionCategory ?? UserActionReferentielType.emploi,
      );
}
