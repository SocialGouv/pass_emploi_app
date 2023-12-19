import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/user_action/creation_form/create_user_action_form_view_model.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_stepper.dart';

class UserActionStepper extends StatelessWidget {
  const UserActionStepper({super.key, required this.displayState, required this.category});
  final CreateUserActionDisplayState displayState;
  final String category;

  @override
  Widget build(BuildContext context) {
    return PassEmploiStepper(
        stepCount: 3,
        currentStep: switch (displayState) {
          CreateUserActionDisplayState.step1 => 0,
          CreateUserActionDisplayState.step2 => 1,
          CreateUserActionDisplayState.step3 => 2,
          _ => 0,
        },
        stepTitle: switch (displayState) {
          CreateUserActionDisplayState.step1 => Strings.user_action_title_step_1,
          CreateUserActionDisplayState.step2 => "${Strings.user_action_title_step_2} $category",
          CreateUserActionDisplayState.step3 => Strings.user_action_title_step_3,
          _ => '',
        });
  }
}
