import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/presentation/model/date_input_source.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/a11y/auto_focus.dart';

part 'create_user_action_step1_view_model.dart';
part 'create_user_action_step2_view_model.dart';
part 'create_user_action_step3_view_model.dart';

enum CreateUserActionDisplayState {
  aborted(0),
  step1(0),
  step2(1),
  step3(2),
  descriptionConfimation(2),
  submitted(2);

  final int stepIndex;

  const CreateUserActionDisplayState(this.stepIndex);

  static int get stepCount => 3;
  String get nextLabel =>
      this == CreateUserActionDisplayState.step3 || this == CreateUserActionDisplayState.descriptionConfimation
          ? Strings.userActionFinishButton
          : Strings.userActionNextButton;
}

class CreateUserActionFormViewModel extends ChangeNotifier {
  CreateUserActionStep1ViewModel step1;
  CreateUserActionStep2ViewModel step2;
  CreateUserActionStep3ViewModel step3;
  CreateUserActionDisplayState displayState;

  CreateUserActionFormViewModel({
    CreateUserActionStep1ViewModel? initialStep1,
    CreateUserActionStep2ViewModel? initialStep2,
    CreateUserActionStep3ViewModel? initialStep3,
    CreateUserActionDisplayState? initialDisplayState,
  })  : step1 = initialStep1 ?? CreateUserActionStep1ViewModel(),
        step2 = initialStep2 ?? CreateUserActionStep2ViewModel(),
        step3 = initialStep3 ?? CreateUserActionStep3ViewModel(),
        displayState = initialDisplayState ?? CreateUserActionDisplayState.step1;

  void goBackToStep2() {
    displayState = CreateUserActionDisplayState.step2;
    notifyListeners();
  }

  void confirmDescription() {
    displayState = CreateUserActionDisplayState.submitted;
    notifyListeners();
  }

  void viewChangedForward() {
    displayState = switch (displayState) {
      CreateUserActionDisplayState.step1 => CreateUserActionDisplayState.step2,
      CreateUserActionDisplayState.step2 => CreateUserActionDisplayState.step3,
      CreateUserActionDisplayState.step3 => _displayStateOnStep3(),
      _ => displayState,
    };
    notifyListeners();
  }

  CreateUserActionDisplayState _displayStateOnStep3() {
    if ((step2.description ?? "").isEmpty && step3.estTerminee) {
      return CreateUserActionDisplayState.descriptionConfimation;
    }
    return CreateUserActionDisplayState.submitted;
  }

  void viewChangedBackward() {
    displayState = switch (displayState) {
      CreateUserActionDisplayState.step1 => CreateUserActionDisplayState.aborted,
      CreateUserActionDisplayState.step2 => CreateUserActionDisplayState.step1,
      CreateUserActionDisplayState.step3 => CreateUserActionDisplayState.step2,
      CreateUserActionDisplayState.descriptionConfimation => CreateUserActionDisplayState.step2,
      _ => displayState,
    };
    notifyListeners();
  }

  bool get canGoForward => switch (displayState) {
        CreateUserActionDisplayState.step1 => step1.isValid,
        CreateUserActionDisplayState.step2 => step2.isValid,
        CreateUserActionDisplayState.step3 => step3.isValid,
        CreateUserActionDisplayState.descriptionConfimation => step3.isValid,
        _ => false,
      };

  CreateUserActionPageViewModel get currentstate => switch (displayState) {
        CreateUserActionDisplayState.aborted => step1,
        CreateUserActionDisplayState.step1 => step1,
        CreateUserActionDisplayState.step2 => step2,
        CreateUserActionDisplayState.step3 => step3,
        CreateUserActionDisplayState.descriptionConfimation => step3,
        CreateUserActionDisplayState.submitted => step3,
      };

  void userActionTypeSelected(UserActionReferentielType type) {
    displayState = CreateUserActionDisplayState.step1;
    step1 = step1.copyWith(type: type);
    viewChangedForward();
  }

  void titleChanged(CreateActionTitleSource titleSource) {
    displayState = CreateUserActionDisplayState.step2;
    step2 = step2.copyWith(titleSource: titleSource);
    notifyListeners();

    (switch (titleSource) {
      CreateActionTitleFromUserInput() => step2.titleInputKey.requestFocusDelayed(),
      CreateActionTitleFromSuggestions() => step2.descriptionKey.requestFocusDelayed(),
      _ => null,
    });
  }

  void descriptionChanged(String description) {
    displayState = CreateUserActionDisplayState.step2;
    step2 = step2.copyWith(description: description);
    notifyListeners();
  }

  void statusChanged(bool estTerminee) {
    displayState = CreateUserActionDisplayState.step3;
    step3 = step3.copyWith(estTerminee: estTerminee);
    notifyListeners();
  }

  void dateChanged(DateInputSource dateSource) {
    displayState = CreateUserActionDisplayState.step3;
    step3 = step3.copyWith(dateSource: dateSource);
    notifyListeners();
  }

  void withRappelChanged(bool withRappel) {
    displayState = CreateUserActionDisplayState.step3;
    step3 = step3.copyWith(withRappel: withRappel);
    notifyListeners();
  }
}

sealed class CreateUserActionPageViewModel extends Equatable {
  bool get isValid;
}

extension CreateUserActionFormStateExt on CreateUserActionFormViewModel {
  bool get shouldDisplayNavigationButtons => isStep2 || isStep3 || isDescriptionConfirmation;

  bool get isAborted => displayState == CreateUserActionDisplayState.aborted;
  bool get isStep1 => displayState == CreateUserActionDisplayState.step1;
  bool get isStep2 => displayState == CreateUserActionDisplayState.step2;
  bool get isStep3 => displayState == CreateUserActionDisplayState.step3;
  bool get isSubmitted => displayState == CreateUserActionDisplayState.submitted;
  bool get isDescriptionConfirmation => displayState == CreateUserActionDisplayState.descriptionConfimation;

  UserActionCreateRequest get toRequest => UserActionCreateRequest(
        step2.titleSource.title,
        step2.description,
        step3.dateSource.selectedDate,
        step3.withRappel,
        step3.estTerminee ? UserActionStatus.DONE : UserActionStatus.IN_PROGRESS,
        step1.actionCategory ?? UserActionReferentielType.emploi,
        false,
      );
}
