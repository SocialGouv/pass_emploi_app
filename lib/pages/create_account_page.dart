import 'package:flutter/material.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class CreateAccountPage extends TraceableStatelessWidget {
  const CreateAccountPage() : super(name: AnalyticsScreenNames.createAccount);

  static MaterialPageRoute materialPageRoute() {
    return MaterialPageRoute(builder: (context) => CreateAccountPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Vous êtes intéressé et vous pensez être élligible au Contrat Engagement Jeune ?\nPrenez rendez-vous avec votre conseiller principal.",
          textAlign: TextAlign.center,
          style: TextStyles.textBaseRegular,
        ),
      ),
    );
  }
}
