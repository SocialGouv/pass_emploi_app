import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/comptage_des_heures/comptage_des_heures_actions.dart';
import 'package:pass_emploi_app/presentation/comptage_des_heures_card_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

class AccueilComptageDesHeures extends StatelessWidget {
  const AccueilComptageDesHeures({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ComptageDesHeuresCardViewModel>(
      converter: (store) => ComptageDesHeuresCardViewModel.create(store),
      onInit: (store) => store.dispatch(ComptageDesHeuresRequestAction()),
      builder: (context, viewModel) {
        return CardContainer(
          padding: EdgeInsets.all(Margins.spacing_s),
          child: switch (viewModel.displayState) {
            DisplayState.CONTENT => _Content(viewModel: viewModel),
            DisplayState.LOADING => const Center(child: CircularProgressIndicator()),
            DisplayState.FAILURE => Retry(
                Strings.comptageDesHeuresError,
                () => viewModel.retry(),
                small: true,
              ),
            DisplayState.EMPTY => const Center(child: Text("Aucune donnée")),
          },
        );
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.viewModel});

  final ComptageDesHeuresCardViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          viewModel.title,
          style: TextStyles.textSBold,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: Margins.spacing_s),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _CompteurIllustration(
                pourcentageHeuresValidees: viewModel.pourcentageHeuresValidees,
                pourcentageHeuresDeclarees: viewModel.pourcentageHeuresDeclarees,
                emoji: viewModel.emoji,
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCompteurText(viewModel.heuresDeclarees, Strings.declaredHours, AppColors.additional6),
                    _buildCompteurText(viewModel.heuresValidees, Strings.realizedHours, AppColors.additional5),
                    SizedBox(height: Margins.spacing_s),
                    Text(viewModel.dateDerniereMiseAJour, style: TextStyles.textXsRegular()),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: Margins.spacing_s),
      ],
    );
  }

  Widget _buildCompteurText(String compteur, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: Margins.spacing_s),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: "${compteur}h ", style: TextStyles.textSBold),
              TextSpan(text: label, style: TextStyles.textSRegular()),
            ],
          ),
        ),
      ],
    );
  }
}

class _CompteurIllustration extends StatelessWidget {
  const _CompteurIllustration({
    required this.pourcentageHeuresValidees,
    required this.pourcentageHeuresDeclarees,
    required this.emoji,
  });

  final double pourcentageHeuresValidees;
  final double pourcentageHeuresDeclarees;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Arcs
          CustomPaint(
            size: const Size(140, 90),
            painter: _CompteurArcsPainter(
              purpleCurve: pourcentageHeuresDeclarees,
              greenCurve: pourcentageHeuresValidees,
            ),
          ),
          // Emoji
          Positioned(
            bottom: -5,
            child: Text(
              emoji,
              style: const TextStyle(fontSize: 32),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompteurArcsPainter extends CustomPainter {
  final double purpleCurve;
  final double greenCurve;

  _CompteurArcsPainter({
    required this.purpleCurve,
    required this.greenCurve,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.95);
    final outerRadius = size.width * 0.48;
    final innerRadius = size.width * 0.34;
    const arcThickness = 9.0;
    const startAngle = 3.14; // 180°
    const sweepAngle = 3.14; // 180°

    // Background arcs
    final bgPaintOuter = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = arcThickness;
    final bgPaintInner = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = arcThickness;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius),
      startAngle,
      sweepAngle,
      false,
      bgPaintOuter,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerRadius),
      startAngle,
      sweepAngle,
      false,
      bgPaintInner,
    );

    // Colored arcs
    final arcPaintOuter = Paint()
      ..color = AppColors.additional6 // purple
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = arcThickness;
    final arcPaintInner = Paint()
      ..color = AppColors.additional5 // teal
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = arcThickness;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius),
      startAngle,
      sweepAngle * purpleCurve,
      false,
      arcPaintOuter,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerRadius),
      startAngle,
      sweepAngle * greenCurve,
      false,
      arcPaintInner,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
