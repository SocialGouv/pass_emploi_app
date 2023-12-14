import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/user_action_form/form_state/create_user_action_form_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_stepper.dart';

class UserActionStepper extends StatelessWidget {
  const UserActionStepper({super.key, required this.view, required this.category});
  final CreateUserActionView view;
  final String category;

  @override
  Widget build(BuildContext context) {
    return PassEmploiStepper(
        stepCount: 3,
        currentStep: switch (view) {
          CreateUserActionView.step1 => 0,
          CreateUserActionView.step2 => 1,
          CreateUserActionView.step3 => 2,
          _ => 0,
        },
        stepTitle: switch (view) {
          CreateUserActionView.step1 => Strings.user_action_title_step_1,
          CreateUserActionView.step2 => "${Strings.user_action_title_step_2} $category",
          CreateUserActionView.step3 => Strings.user_action_title_step_3,
          _ => '',
        });
  }
}
