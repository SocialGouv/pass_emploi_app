import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'create_user_action_step1_state.dart';
part 'create_user_action_step2_state.dart';
part 'create_user_action_step3_state.dart';

enum CreateUserActionStep {
  step1,
  step2,
  step3,
}

class CreateUserActionFormState extends ChangeNotifier {
  CreateUserActionStep1State step1;
  CreateUserActionStep2State step2;
  CreateUserActionStep3State step3;
  CreateUserActionStep currentStep;

  CreateUserActionFormState({
    CreateUserActionStep1State? initialStep1,
    CreateUserActionStep2State? initialStep2,
    CreateUserActionStep3State? initialStep3,
    CreateUserActionStep? initialStep,
  })  : step1 = initialStep1 ?? CreateUserActionStep1State(),
        step2 = initialStep2 ?? CreateUserActionStep2State(),
        step3 = initialStep3 ?? CreateUserActionStep3State(),
        currentStep = initialStep ?? CreateUserActionStep.step1;

  // TODO: go forward
}

sealed class CreateUserActionPageState extends Equatable {
  bool get isValid;
}
