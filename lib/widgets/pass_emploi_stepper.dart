import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class PassEmploiStepper extends StatelessWidget {
  const PassEmploiStepper({super.key, required this.stepCount, required this.currentStep, required this.stepTitle});
  final int stepCount;
  final int currentStep;
  final String stepTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Strings.stepCounter(currentStep + 1, stepCount), style: TextStyles.textSRegular()),
        const SizedBox(height: Margins.spacing_xs),
        Text(stepTitle, style: TextStyles.textMBold),
        const SizedBox(height: Margins.spacing_base),
        _StepProgressBar(stepCount: stepCount, currentStep: currentStep),
      ],
    );
  }
}

class _StepProgressBar extends StatelessWidget {
  const _StepProgressBar({required this.stepCount, required this.currentStep});
  final int stepCount;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < stepCount; i++) ...[
          _stepProgressIndicator(isActive: i <= currentStep),
          if (i < stepCount - 1) const SizedBox(width: Margins.spacing_s),
        ],
      ],
    );
  }

  Widget _stepProgressIndicator({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 8,
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : AppColors.grey100,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
