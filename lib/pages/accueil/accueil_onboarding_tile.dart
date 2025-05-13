import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_actions.dart';
import 'package:pass_emploi_app/pages/onboarding_page.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_item.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';

class AccueilOnboardingTile extends StatelessWidget {
  const AccueilOnboardingTile(this.onboardingItem);
  final OnboardingItem onboardingItem;

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = onboardingItem.completedSteps == onboardingItem.totalSteps;
    return CardContainer(
      onTap: () {
        if (isCompleted) {
          StoreProvider.of<AppState>(context).dispatch(OnboardingHideAction());
        } else {
          Navigator.of(context).push(OnboardingPage.route());
        }
      },
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(Margins.spacing_base),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.gradientPrimary,
          ),
        ),
        child: Row(
          children: [
            OnboardingStepper(
              completedSteps: onboardingItem.completedSteps,
              totalSteps: onboardingItem.totalSteps,
            ),
            const SizedBox(width: Margins.spacing_base),
            if (isCompleted) ...[
              Expanded(
                child: Text(
                  Strings.onboardingAccueilTitleCompleted,
                  style: TextStyles.textBaseBold.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(width: Margins.spacing_base),
              Icon(
                Icons.close_rounded,
                color: Colors.white,
              )
            ] else ...[
              Expanded(
                child: Text(
                  Strings.onboardingAccueilTitle,
                  style: TextStyles.textBaseBold.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(width: Margins.spacing_base),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
              )
            ]
          ],
        ),
      ),
    );
  }
}

class OnboardingStepper extends StatelessWidget {
  final int completedSteps;
  final int totalSteps;
  final Color? backgroundColor;
  final Color? textColor;

  const OnboardingStepper({
    required this.completedSteps,
    required this.totalSteps,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = completedSteps / totalSteps;

    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(60, 60),
            painter: _StepperPainter(progress, backgroundColor),
          ),
          Text(
            '$completedSteps/$totalSteps',
            style: TextStyles.textSBold.copyWith(color: textColor ?? Colors.white),
          ),
        ],
      ),
    );
  }
}

class _StepperPainter extends CustomPainter {
  final double progress;
  final Color? backgroundColor;

  _StepperPainter(this.progress, this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 8.0;
    const startAngle = 3 * pi / 4; // 135°
    const sweepAngle = 1.5 * pi; // 270°

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = backgroundColor ?? Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = AppColors.additional6
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Dessine l'arc de fond
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      backgroundPaint,
    );

    // Dessine l'arc de progression
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
