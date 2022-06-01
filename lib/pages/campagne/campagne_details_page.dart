import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/campagne.dart';
import 'package:pass_emploi_app/pages/campagne/campagne_question_page.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
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
    return StoreConnector<AppState, Campagne?>(
      converter: (store) => store.state.campagneState.campagne,
      builder: (context, campagne) => _content(context, campagne),
      distinct: true,
    );
  }

  Widget _content(BuildContext context, Campagne? campagne) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: passEmploiAppBar(label: Strings.actionDetails, context: context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(campagne != null ? campagne.titre : Strings.evalTitle, style: TextStyles.textMBold),
            SizedBox(height: Margins.spacing_m),
            Text(campagne != null ? campagne.description : Strings.evalDescription, style: TextStyles.textSRegular()),
            SizedBox(height: Margins.spacing_m),
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: double.infinity),
              child: PrimaryActionButton(
                // ignore: ban-name, no tracking required on this page
                onPressed: () => Navigator.push(context, CampagneQuestionPage.materialPageRoute(0)),
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
