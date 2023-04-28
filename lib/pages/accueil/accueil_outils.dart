import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/outil.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_outils_item.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/store_extensions.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/boite_a_outils_card.dart';

class AccueilOutils extends StatelessWidget {
  final AccueilOutilsItem item;

  AccueilOutils(this.item);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Strings.accueilOutilsSection, style: TextStyles.accueilSection),
        SizedBox(height: Margins.spacing_base),
        Text(Strings.accueilOutilsSectionDescription, style: TextStyles.textBaseRegular),
        SizedBox(height: Margins.spacing_base),
        ...item.outils.map((outil) => _Outil(outil)),
        SizedBox(height: Margins.spacing_s),
        SecondaryButton(label: Strings.accueilVoirLesOutils, onPressed: () => goToOutils(context)),
      ],
    );
  }

  void goToOutils(BuildContext context) {
    StoreProvider.of<AppState>(context).dispatchOutilsDeeplink();
  }
}

class _Outil extends StatelessWidget {
  final Outil outil;

  _Outil(this.outil);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BoiteAOutilsCard(outil: outil),
        SizedBox(height: Margins.spacing_base),
      ],
    );
  }
}