import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/rendezvous/rendezvous_details_page.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_card_view_model.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/rendezvous_tag.dart';
import 'package:redux/redux.dart';

class RendezvousCard extends StatelessWidget {
  final RendezvousCardViewModel Function(Store<AppState>) converter;
  final VoidCallback onTap;
  final bool simpleCard;

  const RendezvousCard({
    Key? key,
    required this.converter,
    required this.onTap,
    this.simpleCard = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RendezvousCardViewModel>(
      converter: converter,
      builder: (context, viewModel) => _Container(viewModel, onTap, simpleCard),
    );
  }
}

class _Container extends StatelessWidget {
  final RendezvousCardViewModel viewModel;
  final VoidCallback onTap;
  final bool simpleCard;

  const _Container(this.viewModel, this.onTap, this.simpleCard, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Margins.spacing_base),
        boxShadow: [Shadows.boxShadow],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Margins.spacing_base),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            splashColor: AppColors.primaryLighten,
            child: Padding(
              padding: const EdgeInsets.all(Margins.spacing_base),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (viewModel.isAnnule && simpleCard == false) _Annule(),
                  Row(
                    children: [
                      RendezvousTag(viewModel.tag, viewModel.greenTag),
                      Spacer(),
                      if (viewModel.isInscrit) _InscritTag(),
                    ],
                  ),
                  _Date(viewModel.date),
                  if (viewModel.title != null && simpleCard == false) _Titre(viewModel.title!),
                  if (viewModel.subtitle != null && simpleCard == false) _SousTitre(viewModel.subtitle!),
                  if (simpleCard == false) _Link(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Annule extends StatelessWidget {
  const _Annule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          color: AppColors.warningLight,
          border: Border.all(color: AppColors.warning),
        ),
        padding: const EdgeInsets.symmetric(vertical: Margins.spacing_xs, horizontal: Margins.spacing_base),
        child: Text(
          Strings.rendezvousCardAnnule,
          style: TextStyles.textSRegularWithColor(AppColors.warning),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _Date extends StatelessWidget {
  const _Date(this.date, {Key? key}) : super(key: key);

  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          SvgPicture.asset(Drawables.icClock, color: AppColors.primary),
          SizedBox(width: Margins.spacing_s),
          Text(date, style: TextStyles.textSRegularWithColor(AppColors.primary)),
        ],
      ),
    );
  }
}

class _Titre extends StatelessWidget {
  const _Titre(this.titre, {Key? key}) : super(key: key);

  final String titre;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(titre, style: TextStyles.textBaseBold),
    );
  }
}

class _SousTitre extends StatelessWidget {
  const _SousTitre(this.sousTitre, {Key? key}) : super(key: key);

  final String sousTitre;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(sousTitre, style: TextStyles.textSRegular(color: AppColors.grey800)),
    );
  }
}

class _Link extends StatelessWidget {
  const _Link({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Margins.spacing_base),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Container()),
          Text(Strings.linkDetailsRendezVous, style: TextStyles.textSRegularWithColor(AppColors.contentColor)),
          SizedBox(width: Margins.spacing_s),
          SvgPicture.asset(Drawables.icChevronRight, color: AppColors.contentColor),
        ],
      ),
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
          RendezvousDetailsPage.materialPageRoute(stateSource, this),
        );
      },
    );
  }
}

class _InscritTag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.accent1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(Drawables.icCalendar, color: AppColors.accent1),
      ),
    );
  }
}
