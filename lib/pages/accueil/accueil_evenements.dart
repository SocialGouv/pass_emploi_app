import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/presentation/accueil/accueil_evenements_item.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/store_extensions.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/rendezvous_card.dart';

class AccueilEvenements extends StatelessWidget {
  final AccueilEvenementsItem item;

  AccueilEvenements(this.item);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(Strings.accueilEvenementsSection, style: TextStyles.accueilSection),
        SizedBox(height: Margins.spacing_base),
        ...item.evenementIds.map((id) => _EventCard(id)),
        SizedBox(height: Margins.spacing_s),
        SecondaryButton(label: Strings.accueilVoirLesEvenements, onPressed: () => goToEventList(context)),
      ],
    );
  }

  void goToEventList(BuildContext context) {
    StoreProvider.of<AppState>(context).dispatchEventListDeeplink();
  }
}

class _EventCard extends StatelessWidget {
  final String id;

  _EventCard(this.id);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        id.rendezvousCard(
          context: context,
          stateSource: RendezvousStateSource.accueilLesEvenements,
          trackedEvent: EventType.RDV_DETAIL,
        ),
        SizedBox(height: Margins.spacing_base),
      ],
    );
  }
}