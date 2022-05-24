import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/campagne/campagne_first_question.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class CampagneDetailsPage extends StatelessWidget {
  CampagneDetailsPage._() : super();

  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => CampagneDetailsPage._());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: passEmploiAppBar(label: Strings.actionDetails, context: context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Strings.evalTitle, style: TextStyles.textMBold),
            SizedBox(height: Margins.spacing_m),
            Text(Strings.evalDescription, style: TextStyles.textSRegular()),
            SizedBox(height: Margins.spacing_m),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: PrimaryActionButton(
                onPressed: () => Navigator.push(context, CampagneFirstQuestionPage.materialPageRoute()),
                label: Strings.evalButton,
                drawableRes: Drawables.icPencil,
                iconSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
