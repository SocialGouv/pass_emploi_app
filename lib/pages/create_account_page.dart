import 'package:flutter/material.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/ui/strings.dart';
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
          Strings.createAccountPlaceholder,
          textAlign: TextAlign.center,
          style: TextStyles.textBaseRegular,
        ),
      ),
    );
  }
}
