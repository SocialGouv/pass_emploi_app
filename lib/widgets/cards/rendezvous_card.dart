import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/rendezvous/rendezvous_details_page.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_card_view_model.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/base_card.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_complement.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_tag.dart';
import 'package:redux/redux.dart';

class RendezvousCard extends StatelessWidget {
  final RendezvousCardViewModel Function(Store<AppState>) converter;
  final VoidCallback onTap;
  final bool simpleCard;

  const RendezvousCard({
    super.key,
    required this.converter,
    required this.onTap,
    this.simpleCard = false,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RendezvousCardViewModel>(
      converter: converter,
      builder: (context, viewModel) => _Content(viewModel, onTap, simpleCard),
    );
  }
}

class _Content extends StatelessWidget {
  final RendezvousCardViewModel viewModel;
  final VoidCallback onTap;
  final bool simpleCard;

  const _Content(this.viewModel, this.onTap, this.simpleCard);

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      onTap: onTap,
      title: viewModel.title,
      additionalChild: viewModel.isAnnule ? CardTag.annule() : null,
      tag: CardTag.evenement(text: viewModel.tag),
      complements: [
        CardComplement.dateTime(text: viewModel.date),
        if (viewModel.place != null) CardComplement.place(text: viewModel.place!)
      ],
      secondaryTags: [
        if (viewModel.inscriptionStatus == InscriptionStatus.inscrit)
          CardTag.secondary(
            text: Strings.eventVousEtesDejaInscrit,
            icon: AppIcons.check_circle_outline_rounded,
          ),
        if (viewModel.inscriptionStatus == InscriptionStatus.notInscrit)
          CardTag.secondary(
            text: Strings.eventInscrivezVousPourParticiper,
          )
      ],
    );
  }
}

extension RendezvousCardFromId on String {
  Widget rendezvousCard({
    required BuildContext context,
    required RendezvousStateSource stateSource,
    required EventType trackedEvent,
    bool simpleCard = false,
  }) {
    return RendezvousCard(
      converter: (store) => RendezvousCardViewModel.create(store, stateSource, this),
      simpleCard: simpleCard,
      onTap: () {
        context.trackEvent(trackedEvent);
        Navigator.push(
          context,
          RendezvousDetailsPage.materialPageRoute(_stateSource(stateSource), this),
        );
      },
    );
  }
}

RendezvousStateSource _stateSource(RendezvousStateSource stateSource) {
  // Pourquoi un switch ? Pour être sûr (compliation) de ne pas oublier un futur cas ajouté.
  return switch (stateSource) {
    RendezvousStateSource.eventListSessionsMilo ||
    RendezvousStateSource.accueilProchaineSession ||
    RendezvousStateSource.accueilLesEvenementsSession ||
    RendezvousStateSource.agendaSessionMilo ||
    RendezvousStateSource.rendezvousListSession ||
    RendezvousStateSource.sessionMiloDetails =>
      RendezvousStateSource.sessionMiloDetails,
    RendezvousStateSource.noSource ||
    RendezvousStateSource.accueilProchainRendezvous ||
    RendezvousStateSource.agenda ||
    RendezvousStateSource.eventListAnimationsCollectives ||
    RendezvousStateSource.accueilLesEvenements ||
    RendezvousStateSource.rendezvousList =>
      stateSource,
  };
}
