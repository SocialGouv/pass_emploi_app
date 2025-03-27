import 'package:flutter/material.dart';
import 'package:pass_emploi_app/pages/demarche/create_demarche_2/widgets/create_demarche_2_form.dart';

// TODO: Rename all `create_demarche_2` at the end oh the A/B test

class CreateDemarche2FormPage extends StatelessWidget {
  const CreateDemarche2FormPage({super.key});

  static MaterialPageRoute<String?> materialPageRoute() {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => const CreateDemarche2FormPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // NEXT: Store Connector ici
    return const CreateDemarche2Form();
  }
}
