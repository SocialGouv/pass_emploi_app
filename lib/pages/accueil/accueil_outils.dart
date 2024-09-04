import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/models/outil.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_item.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/boite_a_outils_card.dart';
import 'package:pass_emploi_app/widgets/textes.dart';

class AccueilOutils extends StatelessWidget {
  final AccueilOutilsItem item;

  AccueilOutils(this.item);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LargeSectionTitle(Strings.accueilOutilsSection),
        SizedBox(height: Margins.spacing_base),
        Text(Strings.accueilOutilsSectionDescription, style: TextStyles.textBaseRegular),
        SizedBox(height: Margins.spacing_base),
        Semantics(
          label: Strings.listSemanticsLabel,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: item.outils.map((outil) => _Outil(outil)).toList(),
          ),
        ),
        SizedBox(height: Margins.spacing_s),
        SecondaryButton(label: Strings.accueilVoirLesOutils, onPressed: () => goToOutils(context)),
      ],
    );
  }

  void goToOutils(BuildContext context) {
    StoreProvider.of<AppState>(context).dispatch(
      HandleDeepLinkAction(
        OutilsDeepLink(),
        DeepLinkOrigin.inAppNavigation,
      ),
    );
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
