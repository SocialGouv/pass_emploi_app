import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/models/deep_link.dart';
import 'package:pass_emploi_app/network/post_evenement_engagement.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_item.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/rendezvous_card.dart';
import 'package:pass_emploi_app/widgets/textes.dart';

class AccueilEvenements extends StatelessWidget {
  final AccueilEvenementsItem item;

  AccueilEvenements(this.item);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LargeSectionTitle(Strings.accueilEvenementsSection),
        SizedBox(height: Margins.spacing_base),
        Semantics(
          label: Strings.listSemanticsLabel,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: item.evenements.map((event) => _EventCard(event.$1, event.$2)).toList()
          ),
        ),
        SizedBox(height: Margins.spacing_s),
        SecondaryButton(label: Strings.accueilVoirLesEvenements, onPressed: () => goToEventList(context)),
      ],
    );
  }

  void goToEventList(BuildContext context) {
    StoreProvider.of<AppState>(context).dispatch(
      HandleDeepLinkAction(
        EventListDeepLink(),
        DeepLinkOrigin.inAppNavigation,
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  final String id;
  final AccueilEvenementsType type;

  _EventCard(this.id, this.type);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        id.rendezvousCard(
          context: context,
          stateSource: type == AccueilEvenementsType.sessionMilo
              ? RendezvousStateSource.accueilLesEvenementsSession
              : RendezvousStateSource.accueilLesEvenements,
          evenementEngagement: EvenementEngagement.RDV_DETAIL,
        ),
        SizedBox(height: Margins.spacing_base),
      ],
    );
  }
}
