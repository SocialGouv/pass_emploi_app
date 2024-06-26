import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/user_action/creation_form/create_user_action_form_view_model.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_stepper.dart';

class UserActionStepperTexts extends StatelessWidget {
  const UserActionStepperTexts({super.key, required this.displayState, required this.category});
  final CreateUserActionDisplayState displayState;
  final String category;

  @override
  Widget build(BuildContext context) {
    return PassEmploiStepperTexts(
        stepCount: 3,
        currentStep: displayState.stepIndex,
        stepTitle: switch (displayState) {
          CreateUserActionDisplayState.step1 => Strings.userActionTitleStep1,
          CreateUserActionDisplayState.step2 => "${Strings.userActionTitleStep2} $category",
          CreateUserActionDisplayState.step3 => Strings.userActionTitleStep3,
          _ => '',
        });
  }
}
