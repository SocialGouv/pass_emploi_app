import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class CampagneFirstQuestionPage extends StatelessWidget {
  CampagneFirstQuestionPage._() : super();

  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => CampagneFirstQuestionPage._());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: passEmploiAppBar(label: Strings.firstStepTitle, context: context),
      body: Container(),
    );
  }
}
