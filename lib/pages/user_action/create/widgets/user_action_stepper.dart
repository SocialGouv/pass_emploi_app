import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/user_action/creation_form/create_user_action_form_view_model.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_stepper.dart';

class UserActionStepperTexts extends StatelessWidget {
  const UserActionStepperTexts({super.key, required this.displayState});
  final CreateUserActionDisplayState displayState;

  @override
  Widget build(BuildContext context) {
    return PassEmploiStepperTexts(
      key: ValueKey(displayState.stepIndex),
      stepCount: 3,
      currentStep: displayState.stepIndex,
    );
  }
}
