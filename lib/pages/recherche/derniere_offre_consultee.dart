import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/textes.dart';

class DerniereOffreConsultee extends StatelessWidget {
  const DerniereOffreConsultee({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MediumSectionTitle(Strings.rechercheDerniereOffreConsultee),
      ],
    );
  }
}
