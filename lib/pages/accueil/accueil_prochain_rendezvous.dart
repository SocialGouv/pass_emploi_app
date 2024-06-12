import 'package:flutter/material.dart';
import 'package:pass_emploi_app/network/post_evenement_engagement.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/cards/rendezvous_card.dart';
import 'package:pass_emploi_app/widgets/textes.dart';

class AccueilProchainRendezVous extends StatelessWidget {
  final String id;
  final RendezvousStateSource stateSource;

  AccueilProchainRendezVous({required this.id, required this.stateSource});

  factory AccueilProchainRendezVous.fromSession(String id) {
    return AccueilProchainRendezVous(id: id, stateSource: RendezvousStateSource.accueilProchaineSession);
  }

  factory AccueilProchainRendezVous.fromRendezVous(String id) {
    return AccueilProchainRendezVous(id: id, stateSource: RendezvousStateSource.accueilProchainRendezvous);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LargeSectionTitle(Strings.accueilRendezvousSection),
        SizedBox(height: Margins.spacing_base),
        id.rendezvousCard(
          context: context,
          stateSource: stateSource,
          trackedEvent: EvenementEngagement.RDV_DETAIL,
        ),
      ],
    );
  }
}
