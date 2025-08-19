import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/requests/user_action_create_request.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/models/user_action_type.dart';
import 'package:pass_emploi_app/presentation/model/date_input_source.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/a11y/auto_focus.dart';
import 'package:uuid/uuid.dart';

part 'create_user_action_step1_view_model.dart';
part 'create_user_action_step2_view_model.dart';
part 'create_user_action_step3_view_model.dart';

enum CreateUserActionDisplayState {
  aborted(0),
  step1(0),
  step2(1),
  step3(2),
  submitted(2);

  final int stepIndex;

  const CreateUserActionDisplayState(this.stepIndex);

  static int get stepCount => 3;
  String get nextLabel =>
      this == CreateUserActionDisplayState.step3 ? Strings.userActionFinishButton : Strings.userActionNextButton;
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
    bool? initialShowErrors,
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
    if (step3.isValid) {
      return CreateUserActionDisplayState.submitted;
    } else {
      step3 = step3.copyWith(errorsVisible: true);
      return displayState;
    }
  }

  void viewChangedBackward() {
    displayState = switch (displayState) {
      CreateUserActionDisplayState.step1 => CreateUserActionDisplayState.aborted,
      CreateUserActionDisplayState.step2 => CreateUserActionDisplayState.step1,
      CreateUserActionDisplayState.step3 => CreateUserActionDisplayState.step2,
      _ => displayState,
    };
    notifyListeners();
  }

  bool get canGoForward => switch (displayState) {
        CreateUserActionDisplayState.step1 => step1.isValid,
        CreateUserActionDisplayState.step2 => step2.isValid,
        CreateUserActionDisplayState.step3 => true,
        _ => false,
      };

  CreateUserActionPageViewModel get currentstate => switch (displayState) {
        CreateUserActionDisplayState.aborted => step1,
        CreateUserActionDisplayState.step1 => step1,
        CreateUserActionDisplayState.step2 => step2,
        CreateUserActionDisplayState.step3 => step3,
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
      _ => null,
    });

    if (titleSource is CreateActionTitleFromSuggestions) {
      viewChangedForward();
    }
  }

  void descriptionChanged(String description) {
    displayState = CreateUserActionDisplayState.step2;
    step2 = step2.copyWith(description: description);
    notifyListeners();
  }

  void duplicateUserActionDateChanged(String id, DateInputSource dateSource) {
    displayState = CreateUserActionDisplayState.step3;
    step3.updateDuplicatedUserAction(id, dateSource: dateSource);
    notifyListeners();
  }

  void duplicateUserActionDescriptionChanged(String id, String description) {
    displayState = CreateUserActionDisplayState.step3;
    step3.updateDuplicatedUserAction(id, description: description);
    notifyListeners();
  }

  void deleteDuplicatedUserAction(String id) {
    displayState = CreateUserActionDisplayState.step3;
    step3.deleteDuplicatedUserAction(id);
    notifyListeners();
  }

  void addDuplicatedUserAction() {
    displayState = CreateUserActionDisplayState.step3;
    step3.addDuplicatedUserAction();
    notifyListeners();
  }
}

sealed class CreateUserActionPageViewModel extends Equatable {
  bool get isValid;
}

extension CreateUserActionFormStateExt on CreateUserActionFormViewModel {
  bool get shouldDisplayNavigationButtons => isStep2 || isStep3;

  bool get isAborted => displayState == CreateUserActionDisplayState.aborted;
  bool get isStep1 => displayState == CreateUserActionDisplayState.step1;
  bool get isStep2 => displayState == CreateUserActionDisplayState.step2;
  bool get isStep3 => displayState == CreateUserActionDisplayState.step3;
  bool get isSubmitted => displayState == CreateUserActionDisplayState.submitted;

  List<UserActionCreateRequest> get toRequests => step3.duplicatedUserActions
      .map((action) => UserActionCreateRequest(
            step2.titleSource.title,
            action.description,
            action.dateSource.selectedDate,
            false,
            action.dateSource.selectedDate.isBefore(DateTime.now())
                ? UserActionStatus.DONE
                : UserActionStatus.IN_PROGRESS,
            step1.actionCategory ?? UserActionReferentielType.emploi,
            false,
          ))
      .toList();
}
