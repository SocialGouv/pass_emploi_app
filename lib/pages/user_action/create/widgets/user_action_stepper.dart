import 'package:flutter/material.dart';
import 'package:pass_emploi_app/widgets/pass_emploi_stepper.dart';

class UserActionStepperTexts extends StatelessWidget {
  const UserActionStepperTexts({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return PassEmploiStepperTexts(
      stepCount: 3,
      currentStep: index,
    );
  }
}
